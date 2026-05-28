import Foundation

public struct ArtifactResolver: Sendable {
    public let workspaceURL: URL

    public init(workspaceURL: URL) {
        self.workspaceURL = workspaceURL.standardizedFileURL
    }

    public func resolve(_ artifact: Artifact) -> URL? {
        let raw = artifact.path
        let url: URL
        if raw.hasPrefix("/") {
            guard artifact.kind == .external else {
                return nil
            }
            url = URL(fileURLWithPath: raw)
        } else {
            url = workspaceURL.appendingPathComponent(raw)
        }

        let standardized = url.standardizedFileURL.resolvingSymlinksInPath()
        if raw.hasPrefix("/") {
            return standardized
        }

        let resolvedWorkspace = workspaceURL.resolvingSymlinksInPath()
        let workspacePath = resolvedWorkspace.path.hasSuffix("/") ? resolvedWorkspace.path : resolvedWorkspace.path + "/"
        guard standardized.path == resolvedWorkspace.path || standardized.path.hasPrefix(workspacePath) else {
            return nil
        }
        return standardized
    }
}
