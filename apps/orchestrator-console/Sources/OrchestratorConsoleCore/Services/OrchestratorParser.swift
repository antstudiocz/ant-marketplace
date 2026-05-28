import Foundation

public enum OrchestratorParserError: Error, LocalizedError, Equatable {
    case missingOrchestratorDirectory(URL)
    case invalidRunDirectory(URL)
    case missingRunDirectory(URL)

    public var errorDescription: String? {
        switch self {
        case .missingOrchestratorDirectory(let url):
            return "No .ant/orchestrator directory found at \(url.path)"
        case .invalidRunDirectory(let url):
            return "Run directory is outside the selected workspace orchestrator folder: \(url.path)"
        case .missingRunDirectory(let url):
            return "Run directory no longer exists at \(url.path)"
        }
    }
}

public struct OrchestratorParser: Sendable {
    public init() {}

    public func loadRuns(workspaceURL: URL) throws -> [RunRecord] {
        let orchestratorURL = workspaceURL.appendingPathComponent(".ant/orchestrator", isDirectory: true)
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: orchestratorURL.path, isDirectory: &isDirectory), isDirectory.boolValue else {
            throw OrchestratorParserError.missingOrchestratorDirectory(orchestratorURL)
        }

        let children = try FileManager.default.contentsOfDirectory(
            at: orchestratorURL,
            includingPropertiesForKeys: [.isDirectoryKey, .contentModificationDateKey],
            options: [.skipsHiddenFiles]
        )

        let records = children.compactMap { url -> RunRecord? in
            guard (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true else {
                return nil
            }
            return loadRun(directoryURL: url)
        }

        return records.sorted { lhs, rhs in
            switch (lhs.updatedAt, rhs.updatedAt) {
            case let (left?, right?):
                return left > right
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            case (nil, nil):
                return lhs.runId.localizedStandardCompare(rhs.runId) == .orderedAscending
            }
        }
    }

    public func deleteRun(_ run: RunRecord, workspaceURL: URL) throws {
        let directoryURL = try validatedRunDirectory(run.directoryURL, workspaceURL: workspaceURL)
        try FileManager.default.removeItem(at: directoryURL)
    }

    public func loadRun(directoryURL: URL) -> RunRecord {
        let runId = directoryURL.lastPathComponent
        var warnings: [String] = []
        let stateURL = directoryURL.appendingPathComponent("state.json")
        let eventsURL = directoryURL.appendingPathComponent("events.jsonl")

        let decoder = OrchestratorJSON.decoder
        let state: OrchestratorRun?
        if FileManager.default.fileExists(atPath: stateURL.path) {
            do {
                state = try decoder.decode(OrchestratorRun.self, from: Data(contentsOf: stateURL))
            } catch {
                state = nil
                warnings.append("state.json could not be decoded: \(error.localizedDescription)")
            }
        } else {
            state = nil
        }

        let events: [OrchestratorEvent]
        if FileManager.default.fileExists(atPath: eventsURL.path) {
            let parsed = parseEvents(url: eventsURL)
            events = parsed.events
            warnings.append(contentsOf: parsed.warnings)
        } else {
            events = []
        }

        let markdownArtifacts = loadMarkdownArtifacts(directoryURL: directoryURL)
        if state == nil, !markdownArtifacts.isEmpty {
            warnings.append("Structured state is missing; showing markdown artifacts only.")
        }

        return RunRecord(
            runId: state?.runId ?? runId,
            directoryURL: directoryURL,
            state: state,
            events: events,
            markdownArtifacts: markdownArtifacts,
            warnings: warnings
        )
    }

    private func validatedRunDirectory(_ directoryURL: URL, workspaceURL: URL) throws -> URL {
        let workspaceRootURL = workspaceURL.standardizedFileURL.resolvingSymlinksInPath()
        let expectedOrchestratorURL = workspaceRootURL
            .appendingPathComponent(".ant/orchestrator", isDirectory: true)
            .standardizedFileURL
        let orchestratorURL = workspaceURL
            .appendingPathComponent(".ant/orchestrator", isDirectory: true)
            .standardizedFileURL
        var isOrchestratorDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: orchestratorURL.path, isDirectory: &isOrchestratorDirectory),
              isOrchestratorDirectory.boolValue
        else {
            throw OrchestratorParserError.missingOrchestratorDirectory(orchestratorURL)
        }
        let orchestratorValues = try orchestratorURL.resourceValues(forKeys: [.isSymbolicLinkKey])
        guard orchestratorValues.isSymbolicLink != true,
              orchestratorURL.resolvingSymlinksInPath().path == expectedOrchestratorURL.path
        else {
            throw OrchestratorParserError.invalidRunDirectory(directoryURL)
        }

        let standardizedDirectoryURL = directoryURL.standardizedFileURL
        let parentURL = standardizedDirectoryURL
            .deletingLastPathComponent()
            .resolvingSymlinksInPath()
        guard parentURL.path == expectedOrchestratorURL.path, !standardizedDirectoryURL.lastPathComponent.isEmpty else {
            throw OrchestratorParserError.invalidRunDirectory(directoryURL)
        }

        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: standardizedDirectoryURL.path, isDirectory: &isDirectory),
              isDirectory.boolValue
        else {
            throw OrchestratorParserError.missingRunDirectory(directoryURL)
        }

        let values = try standardizedDirectoryURL.resourceValues(forKeys: [.isDirectoryKey, .isSymbolicLinkKey])
        guard values.isSymbolicLink != true else {
            throw OrchestratorParserError.invalidRunDirectory(directoryURL)
        }

        return standardizedDirectoryURL
    }

    private func parseEvents(url: URL) -> (events: [OrchestratorEvent], warnings: [String]) {
        var events: [OrchestratorEvent] = []
        var warnings: [String] = []
        guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
            return ([], ["events.jsonl could not be read."])
        }

        for (offset, line) in contents.split(separator: "\n", omittingEmptySubsequences: true).enumerated() {
            do {
                let data = Data(line.utf8)
                events.append(try OrchestratorJSON.decoder.decode(OrchestratorEvent.self, from: data))
            } catch {
                warnings.append("events.jsonl line \(offset + 1) could not be decoded: \(error.localizedDescription)")
            }
        }

        return (events.sorted { $0.timestamp < $1.timestamp }, warnings)
    }

    private func loadMarkdownArtifacts(directoryURL: URL) -> [Artifact] {
        guard let enumerator = FileManager.default.enumerator(
            at: directoryURL,
            includingPropertiesForKeys: [.contentModificationDateKey, .isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        return enumerator.compactMap { item -> Artifact? in
            guard let url = item as? URL, url.pathExtension.lowercased() == "md" else {
                return nil
            }
            guard (try? url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true else {
                return nil
            }
            let modified = try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
            let workspaceURL = directoryURL
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
            let relativePath = url.path.replacingOccurrences(of: workspaceURL.path + "/", with: "")
            return Artifact(
                id: relativePath,
                kind: .markdown,
                path: relativePath,
                title: url.deletingPathExtension().lastPathComponent,
                phaseId: nil,
                agentId: nil,
                updatedAt: modified
            )
        }
        .sorted { $0.path.localizedStandardCompare($1.path) == .orderedAscending }
    }
}

public enum OrchestratorJSON {
    public static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let value = try decoder.singleValueContainer().decode(String.self)
            if let date = iso8601WithFractionalSeconds.date(from: value) ?? iso8601.date(from: value) {
                return date
            }
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Expected UTC/Zulu ISO-8601 timestamp.")
            )
        }
        return decoder
    }()

    private static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    private static let iso8601WithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
