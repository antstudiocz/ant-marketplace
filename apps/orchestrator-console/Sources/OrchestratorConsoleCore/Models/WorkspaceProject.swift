import Foundation

public struct WorkspaceProject: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let path: String
    public let addedAt: Date
    public let lastOpenedAt: Date

    public var url: URL {
        URL(fileURLWithPath: path, isDirectory: true)
    }

    public init(url: URL, addedAt: Date = Date(), lastOpenedAt: Date = Date()) {
        let standardizedURL = url.standardizedFileURL
        let path = standardizedURL.path
        self.id = path
        self.name = standardizedURL.lastPathComponent.isEmpty ? path : standardizedURL.lastPathComponent
        self.path = path
        self.addedAt = addedAt
        self.lastOpenedAt = lastOpenedAt
    }

    private init(id: String, name: String, path: String, addedAt: Date, lastOpenedAt: Date) {
        self.id = id
        self.name = name
        self.path = path
        self.addedAt = addedAt
        self.lastOpenedAt = lastOpenedAt
    }

    public func opened(at date: Date = Date()) -> WorkspaceProject {
        WorkspaceProject(id: id, name: name, path: path, addedAt: addedAt, lastOpenedAt: date)
    }
}

public struct WorkspaceProjectList: Codable, Equatable, Sendable {
    public let schemaVersion: Int
    public let projects: [WorkspaceProject]
    public let selectedProjectId: String?

    public init(projects: [WorkspaceProject], selectedProjectId: String?) {
        let normalizedProjects = WorkspaceProjectList.normalized(projects)
        self.schemaVersion = 1
        self.projects = normalizedProjects
        self.selectedProjectId = WorkspaceProjectList.resolvedSelectedProjectId(
            selectedProjectId,
            projects: normalizedProjects
        )
    }

    private init(schemaVersion: Int, projects: [WorkspaceProject], selectedProjectId: String?) {
        let normalizedProjects = WorkspaceProjectList.normalized(projects)
        self.schemaVersion = schemaVersion
        self.projects = normalizedProjects
        self.selectedProjectId = WorkspaceProjectList.resolvedSelectedProjectId(
            selectedProjectId,
            projects: normalizedProjects
        )
    }

    private static func normalized(_ projects: [WorkspaceProject]) -> [WorkspaceProject] {
        var seen = Set<String>()
        return projects
            .filter { project in
                let inserted = seen.insert(project.id).inserted
                return inserted
            }
    }

    private static func resolvedSelectedProjectId(_ selectedProjectId: String?, projects: [WorkspaceProject]) -> String? {
        guard !projects.isEmpty else { return nil }
        guard let selectedProjectId else { return projects.first?.id }
        return projects.contains { $0.id == selectedProjectId } ? selectedProjectId : projects.first?.id
    }
}

public enum WorkspaceProjectPersistence {
    public static func load(savedJSON: String, legacyLastWorkspacePath: String = "") -> WorkspaceProjectList {
        if let data = savedJSON.data(using: .utf8),
           let list = try? decoder.decode(WorkspaceProjectList.self, from: data) {
            return WorkspaceProjectList(
                projects: list.projects,
                selectedProjectId: list.selectedProjectId
            )
        }

        let trimmedLegacyPath = legacyLastWorkspacePath.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedLegacyPath.isEmpty else {
            return WorkspaceProjectList(projects: [], selectedProjectId: nil)
        }

        let project = WorkspaceProject(url: URL(fileURLWithPath: trimmedLegacyPath, isDirectory: true))
        return WorkspaceProjectList(projects: [project], selectedProjectId: project.id)
    }

    public static func encode(_ list: WorkspaceProjectList) throws -> String {
        let data = try encoder.encode(list)
        return String(decoding: data, as: UTF8.self)
    }

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(iso8601.string(from: date))
        }
        return encoder
    }()

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let value = try decoder.singleValueContainer().decode(String.self)
            if let date = iso8601.date(from: value) ?? iso8601WithFractionalSeconds.date(from: value) {
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
