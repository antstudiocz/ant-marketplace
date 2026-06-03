import Foundation

public struct ArtifactPreview: Equatable, Sendable {
    public let artifact: Artifact
    public let url: URL
    public let content: String
    public let displayMode: DisplayMode

    public enum DisplayMode: String, Equatable, Sendable {
        case markdown
        case text
        case code
    }
}

public enum ArtifactPreviewError: Error, LocalizedError, Equatable, Sendable {
    case missingWorkspace
    case unresolvedPath
    case unreadableKind(ArtifactKind, String)
    case missingFile(String)
    case notRegularFile(String)
    case fileTooLarge(Int, limit: Int)
    case nonUTF8(String)
    case readFailed(String)

    public var errorDescription: String? {
        switch self {
        case .missingWorkspace:
            return "No workspace is selected."
        case .unresolvedPath:
            return "Artifact path could not be resolved safely."
        case .unreadableKind(let kind, let path):
            return "Artifact is not a supported text preview type: \(kind.rawValue) (\(path))"
        case .missingFile(let path):
            return "Artifact file does not exist: \(path)"
        case .notRegularFile(let path):
            return "Artifact is not a regular file: \(path)"
        case .fileTooLarge(let size, let limit):
            return "Artifact is too large to preview in app (\(size) bytes, limit \(limit) bytes)."
        case .nonUTF8(let path):
            return "Artifact is not UTF-8 text: \(path)"
        case .readFailed(let path):
            return "Artifact could not be read: \(path)"
        }
    }
}

public struct ArtifactPreviewReader: Sendable {
    public let workspaceURL: URL
    public let maxBytes: Int

    public init(workspaceURL: URL, maxBytes: Int = 1_048_576) {
        self.workspaceURL = workspaceURL
        self.maxBytes = maxBytes
    }

    public func preview(_ artifact: Artifact) throws -> ArtifactPreview {
        guard isReadable(artifact) else {
            throw ArtifactPreviewError.unreadableKind(artifact.kind, artifact.path)
        }
        guard let url = ArtifactResolver(workspaceURL: workspaceURL).resolve(artifact) else {
            throw ArtifactPreviewError.unresolvedPath
        }

        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            throw ArtifactPreviewError.missingFile(url.path)
        }
        guard !isDirectory.boolValue else {
            throw ArtifactPreviewError.notRegularFile(url.path)
        }

        let values = try? url.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey])
        guard values?.isRegularFile == true else {
            throw ArtifactPreviewError.notRegularFile(url.path)
        }
        if let fileSize = values?.fileSize, fileSize > maxBytes {
            throw ArtifactPreviewError.fileTooLarge(fileSize, limit: maxBytes)
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw ArtifactPreviewError.readFailed(url.path)
        }
        if data.count > maxBytes {
            throw ArtifactPreviewError.fileTooLarge(data.count, limit: maxBytes)
        }
        guard !data.contains(0), var content = String(data: data, encoding: .utf8) else {
            throw ArtifactPreviewError.nonUTF8(url.path)
        }

        if artifact.kind == .json || artifact.kind == .schema || url.pathExtension.lowercased() == "json" {
            content = Self.prettyPrintedJSON(data: data) ?? content
        }

        return ArtifactPreview(
            artifact: artifact,
            url: url,
            content: content,
            displayMode: displayMode(for: artifact)
        )
    }

    private func isReadable(_ artifact: Artifact) -> Bool {
        switch artifact.kind {
        case .markdown, .json, .jsonl, .schema, .source, .test, .log:
            return true
        case .app:
            return false
        case .external, .unknown:
            return Self.readableExtensions.contains(URL(fileURLWithPath: artifact.path).pathExtension.lowercased())
        }
    }

    private func displayMode(for artifact: Artifact) -> ArtifactPreview.DisplayMode {
        if Self.isMarkdown(artifact) {
            return .markdown
        }

        return .code
    }

    private static func isMarkdown(_ artifact: Artifact) -> Bool {
        if artifact.kind == .markdown {
            return true
        }

        guard artifact.kind == .external || artifact.kind == .unknown else {
            return false
        }

        let pathExtension = URL(fileURLWithPath: artifact.path).pathExtension.lowercased()
        return pathExtension == "md" || pathExtension == "markdown"
    }

    private static func prettyPrintedJSON(data: Data) -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]) else {
            return nil
        }
        return String(data: prettyData, encoding: .utf8)
    }

    private static let readableExtensions: Set<String> = [
        "bash", "c", "cc", "conf", "cpp", "css", "csv", "gql", "graphql",
        "h", "hpp", "html", "java", "js", "json", "jsonl", "jsx", "kt",
        "log", "m", "markdown", "md", "mm", "php", "plist", "py", "rb",
        "rs", "schema", "scss", "sh", "sql", "swift", "toml", "ts", "tsx",
        "tsv", "txt", "xml", "yaml", "yml", "zsh"
    ]
}
