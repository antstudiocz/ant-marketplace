import OrchestratorConsoleCore
import SwiftUI

struct ArtifactListView: View {
    let artifacts: [Artifact]
    @ObservedObject var store: RunStore

    var body: some View {
        Panel(title: L10n.t("Evidence", "Evidence"), systemImage: "doc.text") {
            ArtifactListContent(artifacts: artifacts, store: store)
        }
    }
}

struct ArtifactListContent: View {
    let artifacts: [Artifact]
    @ObservedObject var store: RunStore
    @State private var previewPresentation: ArtifactPreviewPresentation?

    var body: some View {
        if artifacts.isEmpty {
            EmptyPanelLine(text: L10n.t("No artifacts", "Žádné artefakty"))
        } else {
            VStack(alignment: .leading, spacing: 0) {
                EvidenceTableHeader()
                ForEach(sortedArtifacts) { artifact in
                    ArtifactRow(
                        artifact: artifact,
                        store: store,
                        previewPresentation: $previewPresentation,
                        titleFont: .callout,
                        pathFont: .caption
                    )
                    .padding(.vertical, 8)
                    .overlay(alignment: .bottom) {
                        Divider().opacity(0.45)
                    }
                }
            }
            .sheet(item: $previewPresentation) { presentation in
                ArtifactPreviewSheet(presentation: presentation, store: store)
            }
        }
    }

    private var sortedArtifacts: [Artifact] {
        artifacts.sorted { lhs, rhs in
            switch (lhs.updatedAt, rhs.updatedAt) {
            case let (left?, right?):
                return left > right
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            case (nil, nil):
                return lhs.path.localizedStandardCompare(rhs.path) == .orderedAscending
            }
        }
    }
}

private struct EvidenceTableHeader: View {
    var body: some View {
        HStack {
            Text(L10n.t("Artifact", "Artefakt"))
            Spacer()
            Text(L10n.t("Actions", "Akce"))
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(.secondary)
        .padding(.bottom, 7)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

struct ArtifactRow: View {
    let artifact: Artifact
    @ObservedObject var store: RunStore
    @Binding var previewPresentation: ArtifactPreviewPresentation?
    let titleFont: Font
    let pathFont: Font

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: ArtifactIcon.name(for: artifact.kind))
                .foregroundStyle(.secondary)
                .frame(width: 18)
            Button {
                previewPresentation = ArtifactPreviewPresentation(artifact: artifact, result: store.previewArtifact(artifact))
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(artifact.displayTitle)
                        .font(titleFont)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(artifact.summaryLine)
                        .font(pathFont)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    if artifact.title?.isEmpty == false {
                        Text(artifact.path)
                            .font(.caption2.monospaced())
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .help(L10n.t("View in app", "Zobrazit v aplikaci"))

            Spacer(minLength: 8)

            Button {
                previewPresentation = ArtifactPreviewPresentation(artifact: artifact, result: store.previewArtifact(artifact))
            } label: {
                Image(systemName: "eye")
            }
            .buttonStyle(.borderless)
            .help(L10n.t("View in app", "Zobrazit v aplikaci"))

            Button {
                store.openArtifact(artifact)
            } label: {
                Image(systemName: "arrow.up.forward.app")
            }
            .buttonStyle(.borderless)
            .help(L10n.t("Open externally", "Otevřít externě"))

            Button {
                store.revealArtifact(artifact)
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(.borderless)
            .help(L10n.t("Reveal in Finder", "Ukázat ve Finderu"))
        }
    }
}

struct ArtifactPreviewPresentation: Identifiable {
    let id = UUID()
    let artifact: Artifact
    let result: Result<ArtifactPreview, ArtifactPreviewError>
}

struct ArtifactPreviewSheet: View {
    let presentation: ArtifactPreviewPresentation
    @ObservedObject var store: RunStore
    @Environment(\.dismiss) private var dismiss
    @State private var markdownMode: MarkdownPreviewMode = .rendered
    @State private var searchText = ""

    private enum Layout {
        static let sheetWidth: CGFloat = 920
        static let sheetHeight: CGFloat = 640
        static let horizontalPadding: CGFloat = 18
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(presentation.artifact.displayTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Text(presentation.artifact.path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.borderless)
                .controlSize(.small)
                .accessibilityLabel(L10n.t("Close", "Zavřít"))
                .help(L10n.t("Close", "Zavřít"))
                .keyboardShortcut(.cancelAction)
            }
            .padding(.top, 16)
            .padding(.horizontal, 18)
            .padding(.bottom, 14)

            Divider()

            if case .success = presentation.result {
                previewToolbar
                Divider()
            }

            previewBody
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .clipped()

            footerBar
        }
        .frame(width: Layout.sheetWidth, height: Layout.sheetHeight)
    }

    @ViewBuilder
    private var previewToolbar: some View {
        if case .success(let preview) = presentation.result {
            ViewThatFits(in: .horizontal) {
                toolbarRow(preview: preview)
                toolbarWrapped(preview: preview)
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, 10)
        }
    }

    private func toolbarRow(preview: ArtifactPreview) -> some View {
        HStack(alignment: .center, spacing: 16) {
            if preview.displayMode == .markdown {
                modeControl
            }

            searchCluster(preview: preview)
                .frame(minWidth: 260, idealWidth: 320, maxWidth: 380)
                .layoutPriority(1)

            Spacer(minLength: 16)

            kindLabel(for: preview)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func toolbarWrapped(preview: ArtifactPreview) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                if preview.displayMode == .markdown {
                    modeControl
                }

                Spacer(minLength: 12)

                kindLabel(for: preview)
            }

            searchCluster(preview: preview)
                .frame(maxWidth: 420, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var modeControl: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(L10n.t("Mode", "Režim"))
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 36, alignment: .leading)

            Picker(L10n.t("Mode", "Režim"), selection: $markdownMode) {
                ForEach(MarkdownPreviewMode.allCases) { mode in
                    Text(mode.label).tag(mode)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .frame(width: 176)
        }
        .fixedSize(horizontal: true, vertical: false)
    }

    private var searchField: some View {
        TextField(L10n.t("Search document", "Hledat v dokumentu"), text: $searchText)
            .textFieldStyle(.roundedBorder)
    }

    private func searchCluster(preview: ArtifactPreview) -> some View {
        HStack(alignment: .center, spacing: 8) {
            searchField

            if !searchText.isEmpty {
                matchCountLabel(for: preview)
            }
        }
    }

    private func kindLabel(for preview: ArtifactPreview) -> some View {
        Label(preview.displayMode.label, systemImage: ArtifactIcon.name(for: presentation.artifact.kind))
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: true, vertical: false)
    }

    private func matchCountLabel(for preview: ArtifactPreview) -> some View {
        Text(L10n.t("\(preview.matchCount(for: searchText)) matches", "\(preview.matchCount(for: searchText)) shod"))
            .font(.caption)
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
    }

    private var footerBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 8) {
                Spacer()

                Button {
                    store.revealArtifact(presentation.artifact)
                } label: {
                    Label(L10n.t("Reveal", "Ukázat"), systemImage: "magnifyingglass")
                }

                Button {
                    store.openArtifact(presentation.artifact)
                } label: {
                    Label(L10n.t("Open", "Otevřít"), systemImage: "arrow.up.forward.app")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
        .background(.regularMaterial)
    }

    @ViewBuilder
    private var previewBody: some View {
        switch presentation.result {
        case .success(let preview):
            previewContent(preview)
        case .failure(let error):
            VStack(alignment: .leading, spacing: 10) {
                Label(L10n.t("Preview unavailable", "Náhled není dostupný"), systemImage: "exclamationmark.triangle")
                    .font(.headline)
                    .foregroundStyle(.orange)
                Text(error.localizedUserMessage)
                    .foregroundStyle(.secondary)
            }
            .padding(18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    @ViewBuilder
    private func previewContent(_ preview: ArtifactPreview) -> some View {
        switch preview.displayMode {
        case .markdown:
            if markdownMode == .rendered {
                ScrollView(.vertical) {
                    MarkdownArtifactPreview(content: preview.content, searchText: searchText)
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .background(Color(nsColor: .textBackgroundColor))
            } else {
                rawPreviewContent(preview, axes: [.horizontal, .vertical], font: .system(.body, design: .monospaced), expandsHorizontally: false)
            }
        case .text:
            CodePreviewView(preview: preview, searchText: searchText)
        case .code:
            CodePreviewView(preview: preview, searchText: searchText)
        }
    }

    private func rawPreviewContent(_ preview: ArtifactPreview, axes: Axis.Set, font: Font, expandsHorizontally: Bool) -> some View {
        ScrollView(axes) {
            Text(preview.attributedContent(searchText: searchText))
                .font(font)
                .textSelection(.enabled)
                .padding(18)
                .frame(maxWidth: expandsHorizontally ? .infinity : nil, alignment: .topLeading)
        }
        .background(Color(nsColor: .textBackgroundColor))
    }
}

struct MarkdownArtifactPreview: View {
    let content: String
    let searchText: String
    var interactionContext: MarkdownInteractionContext? = nil

    private var blocks: [MarkdownPreviewBlock] {
        MarkdownPreviewParser.parse(content)
    }

    private var items: [MarkdownPreviewItem] {
        MarkdownPreviewSectionBuilder.items(from: blocks)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if !searchText.isEmpty {
                SearchContextLine(content: content, searchText: searchText)
            }

            ForEach(items) { item in
                MarkdownPreviewItemView(item: item, searchText: searchText, interactionContext: interactionContext)
            }
        }
        .textSelection(.enabled)
    }
}

struct MarkdownInteractionContext {
    let run: OrchestratorRun
    let artifact: Artifact?
    var artifacts: [Artifact] = []
    var workspaceURL: URL? = nil
    let onSelectAgent: (Agent) -> Void
    var onSelectArtifact: ((Artifact) -> Void)? = nil

    private var agentsById: [String: Agent] {
        Dictionary(uniqueKeysWithValues: run.agents.map { ($0.id.lowercased(), $0) })
    }

    func agent(for value: String) -> Agent? {
        let normalized = normalizedAgentToken(value)
        guard !normalized.isEmpty else { return nil }

        if let agent = agentsById[normalized] {
            return agent
        }

        if let agent = run.agents.first(where: { $0.id.lowercased().hasPrefix(normalized) }) {
            return agent
        }

        if let agent = run.agents.first(where: { normalizedAgentToken($0.displayName ?? "") == normalized }) {
            return agent
        }

        let matchingRoleAgents = run.agents.filter { agent in
            normalizedAgentToken(agent.role.rawValue) == normalized
                || normalizedAgentToken(agent.role.label) == normalized
        }

        return matchingRoleAgents.count == 1 ? matchingRoleAgents.first : nil
    }

    func ownerAgent(fallback value: String) -> Agent? {
        if let owner = artifact?.phaseId.flatMap({ phaseId in
            run.phases.first { $0.id == phaseId }?.ownerAgentId
        }).flatMap({ agent(for: $0) }) {
            return owner
        }

        if let owner = artifact?.agentId.flatMap({ agent(for: $0) }) {
            return owner
        }

        return agent(for: value)
    }

    func currentPhaseReference(in text: String) -> MarkdownPhaseReference? {
        guard let metadata = MarkdownMetadataLine.parse(text), metadata.kind == .phase else {
            return nil
        }

        let phaseText = phaseTextParts(from: metadata.value)
        let matchedPhase = phase(for: phaseText.phase) ?? phase(for: metadata.value) ?? run.currentPhaseId.flatMap { phase(for: $0) }
        guard let phase = matchedPhase else { return nil }

        let artifact = artifacts.first {
            $0.phaseId == phase.id && URL(fileURLWithPath: $0.path).lastPathComponent.lowercased() == "phase.md"
        } ?? artifacts.first {
            $0.phaseId == phase.id
        }

        return MarkdownPhaseReference(
            label: metadata.label,
            phase: phase,
            artifact: artifact,
            rest: phaseText.rest
        )
    }

    fileprivate func canonicalPhaseStatus(for metadata: MarkdownMetadataLine) -> String? {
        guard metadata.kind == .status,
              let artifact,
              URL(fileURLWithPath: artifact.path).lastPathComponent.lowercased() == "phase.md",
              let phaseId = artifact.phaseId,
              let phase = run.phases.first(where: { $0.id == phaseId }) else {
            return nil
        }

        let label = metadata.label.lowercased()
        guard [
            "status",
            "phase status",
            "close status",
            "stav",
            "stav fáze",
            "stav uzavření",
        ].contains(label) else {
            return nil
        }

        return phase.status.label
    }

    func fileReferences(in text: String) -> [Artifact] {
        var tokens: [String] = []

        if let regex = try? NSRegularExpression(pattern: #"`([^`]+)`"#) {
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            for match in regex.matches(in: text, range: range) {
                guard let tokenRange = Range(match.range(at: 1), in: text) else { continue }
                tokens.append(String(text[tokenRange]))
            }
        }

        if let regex = try? NSRegularExpression(pattern: fileReferencePattern, options: [.caseInsensitive]) {
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            for match in regex.matches(in: text, range: range) {
                guard let tokenRange = Range(match.range(at: 1), in: text) else { continue }
                tokens.append(String(text[tokenRange]))
            }
        }

        var seen = Set<String>()
        return tokens.compactMap { token -> Artifact? in
            guard let artifact = artifact(forReference: token), seen.insert(artifact.id).inserted else {
                return nil
            }
            return artifact
        }
    }

    func canPreviewArtifact(_ artifact: Artifact) -> Bool {
        guard let workspaceURL else { return true }
        guard let url = ArtifactResolver(workspaceURL: workspaceURL).resolve(artifact) else { return false }

        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), !isDirectory.boolValue else {
            return false
        }

        let values = try? url.resourceValues(forKeys: [.isRegularFileKey])
        return values?.isRegularFile == true
    }

    func leadingAgentReference(in text: String) -> MarkdownAgentReference? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let pattern = #"^`?([0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12})`?(?:\s+\("([^"]+)"\))?\s*:?\s*(.*)$"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: trimmed, range: NSRange(trimmed.startIndex..<trimmed.endIndex, in: trimmed)),
              let idRange = Range(match.range(at: 1), in: trimmed) else {
            return nil
        }

        let id = String(trimmed[idRange])
        let quotedName = Range(match.range(at: 2), in: trimmed).map { String(trimmed[$0]) }
        let rest = Range(match.range(at: 3), in: trimmed).map { String(trimmed[$0]).trimmingCharacters(in: .whitespaces) } ?? ""
        let agent = agent(for: id) ?? quotedName.flatMap(agent(for:))
        return MarkdownAgentReference(
            agent: agent,
            missingLabel: quotedName ?? shortAgentId(id),
            missingSubtitle: quotedName == nil ? nil : shortAgentId(id),
            rest: rest
        )
    }

    private func shortAgentId(_ id: String) -> String {
        String(id.prefix(8))
    }

    private func phase(for value: String) -> Phase? {
        let normalized = normalizedPathToken(value)
        guard !normalized.isEmpty else { return nil }
        return run.phases.first { phase in
            let id = phase.id.lowercased()
            let title = phase.title.lowercased()
            let localized = phase.localizedTitle.lowercased()
            return normalized.contains(id)
                || normalized.contains(title)
                || normalized.contains(localized)
        }
    }

    private func phaseTextParts(from value: String) -> (phase: String, rest: String) {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let separator = trimmed.firstIndex(where: { ".:".contains($0) }) else {
            return (trimmed, "")
        }

        let phase = String(trimmed[..<separator]).trimmingCharacters(in: .whitespacesAndNewlines)
        let rest = String(trimmed[trimmed.index(after: separator)...])
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: ".:-")))
        return (phase, rest)
    }

    private func artifact(forReference value: String) -> Artifact? {
        let normalized = normalizedPathToken(value)
        guard !normalized.isEmpty else { return nil }

        if let artifact = artifacts.first(where: { normalizedPathToken($0.path) == normalized }) {
            return artifact
        }

        if let artifact = artifacts.first(where: { candidate in
            let path = normalizedPathToken(candidate.path)
            return path.hasSuffix("/\(normalized)") || path.hasSuffix(normalized)
        }) {
            return artifact
        }

        let titleToken = normalizedTitleToken(normalized)
        if let artifact = artifacts.first(where: { candidate in
            normalizedPathToken(candidate.displayTitle) == titleToken
                || normalizedPathToken(candidate.title ?? "") == titleToken
        }) {
            return artifact
        }

        return syntheticArtifact(forReference: value)
    }

    private func normalizedAgentToken(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "`\"'()[]{}.,:;"))
            .replacingOccurrences(of: "_", with: "-")
            .replacingOccurrences(of: " ", with: "-")
            .lowercased()
    }

    private func normalizedPathToken(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "`\"'()[]{}.,:;"))
            .replacingOccurrences(of: "\\", with: "/")
            .lowercased()
    }

    private func normalizedTitleToken(_ normalizedPath: String) -> String {
        let lastComponent = URL(fileURLWithPath: normalizedPath).lastPathComponent
        let extensionToRemove = URL(fileURLWithPath: lastComponent).pathExtension
        guard !extensionToRemove.isEmpty else { return lastComponent }
        return String(lastComponent.dropLast(extensionToRemove.count + 1))
    }

    private func syntheticArtifact(forReference value: String) -> Artifact? {
        let path = resolvedFileReferencePath(value)
        guard isSupportedFileReference(path) else { return nil }

        let kind = artifactKind(forPath: path)
        return Artifact(
            id: "inline-file:\(normalizedPathToken(path))",
            kind: kind,
            path: path,
            title: syntheticTitle(forPath: path),
            phaseId: artifact?.phaseId,
            agentId: artifact?.agentId,
            updatedAt: nil
        )
    }

    private func cleanedFileReference(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "`\"'()[]{}.,:;"))
            .replacingOccurrences(of: "\\", with: "/")
    }

    private func resolvedFileReferencePath(_ value: String) -> String {
        let path = cleanedFileReference(value)
        guard !path.hasPrefix("/") else { return path }

        let normalized = normalizedPathToken(path)
        if isWorkspaceRootedReference(normalized) {
            return path
        }

        guard let currentArtifactPath = artifact?.path, !currentArtifactPath.hasPrefix("/") else {
            return path
        }

        let relativePath = path.hasPrefix("./") ? String(path.dropFirst(2)) : path
        let baseDirectory = (currentArtifactPath as NSString).deletingLastPathComponent
        guard !baseDirectory.isEmpty, baseDirectory != "." else {
            return relativePath
        }

        return "\(baseDirectory)/\(relativePath)"
    }

    private func isSupportedFileReference(_ path: String) -> Bool {
        guard !path.isEmpty else { return false }
        guard !path.contains("<"), !path.contains(">") else { return false }
        let normalized = normalizedPathToken(path)
        guard !normalized.contains("/../"), !normalized.hasPrefix("../") else { return false }
        guard normalized.contains("/") || normalized.hasPrefix(".") || artifact != nil else { return false }

        let fileExtension = URL(fileURLWithPath: normalized).pathExtension.lowercased()
        return Self.readableFileExtensions.contains(fileExtension)
    }

    private func isWorkspaceRootedReference(_ normalizedPath: String) -> Bool {
        normalizedPath.hasPrefix(".ant/")
            || normalizedPath.hasPrefix("apps/")
            || normalizedPath.hasPrefix("plugins/")
            || normalizedPath.hasPrefix("script/")
            || normalizedPath.hasPrefix("scripts/")
            || normalizedPath.hasPrefix("tests/")
            || normalizedPath.hasPrefix("sources/")
            || normalizedPath.hasPrefix("package")
            || normalizedPath.hasPrefix("readme")
    }

    private func syntheticTitle(forPath path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let fileExtension = url.pathExtension
        let filename = url.lastPathComponent
        guard !fileExtension.isEmpty else { return filename }

        let basename = String(filename.dropLast(fileExtension.count + 1))
        return basename.isEmpty ? filename : basename
    }

    private func artifactKind(forPath path: String) -> ArtifactKind {
        if path.hasPrefix("/") {
            return .external
        }

        let normalized = normalizedPathToken(path)
        let fileExtension = URL(fileURLWithPath: normalized).pathExtension.lowercased()
        let filename = URL(fileURLWithPath: normalized).lastPathComponent.lowercased()

        switch fileExtension {
        case "md", "markdown":
            return .markdown
        case "json":
            return filename.hasSuffix(".schema.json") || normalized.contains("/schema") ? .schema : .json
        case "jsonl":
            return .jsonl
        case "log":
            return .log
        case "swift":
            return normalized.contains("/tests/") || filename.contains("test") ? .test : .source
        case "bash", "c", "cc", "conf", "cpp", "css", "gql", "graphql", "h", "hpp", "html", "java",
             "js", "jsx", "kt", "m", "mm", "php", "plist", "py", "rb", "rs", "scss", "sh", "sql",
             "toml", "ts", "tsx", "xml", "yaml", "yml", "zsh":
            return .source
        default:
            return .unknown
        }
    }

    private static let readableFileExtensions: Set<String> = [
        "bash", "c", "cc", "conf", "cpp", "css", "csv", "gql", "graphql",
        "h", "hpp", "html", "java", "js", "json", "jsonl", "jsx", "kt",
        "log", "m", "markdown", "md", "mm", "php", "plist", "py", "rb",
        "rs", "schema", "scss", "sh", "sql", "swift", "toml", "ts", "tsx",
        "tsv", "txt", "xml", "yaml", "yml", "zsh"
    ]

    private var fileReferencePattern: String {
        #"(?<![\w/.-])([.~A-Za-z0-9_/@:+-][A-Za-z0-9_./@:+~-]*\.(?:bash|c|cc|conf|cpp|css|csv|gql|graphql|h|hpp|html|java|js|json|jsonl|jsx|kt|log|m|markdown|md|mm|php|plist|py|rb|rs|schema|scss|sh|sql|swift|toml|ts|tsx|tsv|txt|xml|yaml|yml|zsh))(?![\w/.-])"#
    }
}

struct MarkdownAgentReference {
    let agent: Agent?
    let missingLabel: String
    let missingSubtitle: String?
    let rest: String
}

struct MarkdownPhaseReference {
    let label: String
    let phase: Phase
    let artifact: Artifact?
    let rest: String
}

private struct MarkdownPreviewBlock: Identifiable, Equatable {
    enum Kind: Equatable {
        case heading(level: Int, text: String)
        case paragraph(String)
        case bulletList([String])
        case code(language: String?, text: String)
        case divider
    }

    let id: Int
    let kind: Kind
}

private struct MarkdownPreviewItem: Identifiable {
    enum Kind {
        case block(MarkdownPreviewBlock)
        case section(MarkdownPreviewSection)
    }

    let id: String
    let kind: Kind
}

private struct MarkdownPreviewSection: Identifiable {
    let id: String
    let title: String
    let value: String?
    let blocks: [MarkdownPreviewBlock]
}

private enum MarkdownPreviewSectionBuilder {
    static func items(from blocks: [MarkdownPreviewBlock]) -> [MarkdownPreviewItem] {
        var items: [MarkdownPreviewItem] = []
        var index = 0

        while index < blocks.count {
            let block = blocks[index]

            guard let header = sectionHeader(from: block) else {
                items.append(MarkdownPreviewItem(id: "block-\(block.id)", kind: .block(block)))
                index += 1
                continue
            }

            var sectionBlocks: [MarkdownPreviewBlock] = []
            var nextIndex = index + 1
            while nextIndex < blocks.count {
                let nextBlock = blocks[nextIndex]
                if isSectionBoundary(nextBlock) {
                    break
                }
                sectionBlocks.append(nextBlock)
                nextIndex += 1
            }

            let section = MarkdownPreviewSection(
                id: "section-\(block.id)",
                title: header.title,
                value: header.value,
                blocks: sectionBlocks
            )
            items.append(MarkdownPreviewItem(id: section.id, kind: .section(section)))
            index = nextIndex
        }

        return items
    }

    private static func isSectionBoundary(_ block: MarkdownPreviewBlock) -> Bool {
        if case .heading = block.kind {
            return true
        }
        return sectionHeader(from: block) != nil
    }

    private static func sectionHeader(from block: MarkdownPreviewBlock) -> (title: String, value: String?)? {
        guard case .paragraph(let text) = block.kind else { return nil }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let separator = trimmed.firstIndex(of: ":") else { return nil }

        let label = String(trimmed[..<separator]).trimmingCharacters(in: .whitespacesAndNewlines)
        guard sectionLabels.contains(label.lowercased()) else { return nil }

        let value = String(trimmed[trimmed.index(after: separator)...])
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return (label, value.isEmpty ? nil : value)
    }

    private static let sectionLabels: Set<String> = [
        "input",
        "goal",
        "work done",
        "evidence",
        "blockers",
        "close status",
        "delivery",
        "definition of done",
        "architecture boundaries",
        "contract decisions",
        "verification",
        "open questions",
        "active children",
        "files to read first",
        "must not assume",
        "next phase handoff",
        "next safe action",
        "next",
        "output",
        "safe assumptions",
        "user decisions",
        "repo facts",
        "recommended direction",
        "success criteria",
        "rozhodnutí uživatele",
        "bezpečné předpoklady",
        "otevřené otázky",
        "důkazy",
        "blokery",
        "hotovo",
        "výstup",
        "cíl",
        "vstup"
    ]
}

private enum MarkdownPreviewParser {
    static func parse(_ content: String) -> [MarkdownPreviewBlock] {
        var blocks: [MarkdownPreviewBlock] = []
        var paragraphLines: [String] = []
        var bulletLines: [String] = []
        var codeLines: [String] = []
        var codeLanguage: String?
        var isInCodeFence = false

        func appendParagraph() {
            guard !paragraphLines.isEmpty else { return }
            blocks.append(
                MarkdownPreviewBlock(
                    id: blocks.count,
                    kind: .paragraph(paragraphLines.joined(separator: " "))
                )
            )
            paragraphLines.removeAll()
        }

        func appendBullets() {
            guard !bulletLines.isEmpty else { return }
            blocks.append(MarkdownPreviewBlock(id: blocks.count, kind: .bulletList(bulletLines)))
            bulletLines.removeAll()
        }

        func appendCode() {
            blocks.append(
                MarkdownPreviewBlock(
                    id: blocks.count,
                    kind: .code(language: codeLanguage, text: codeLines.joined(separator: "\n"))
                )
            )
            codeLines.removeAll()
            codeLanguage = nil
        }

        for rawLine in content.components(separatedBy: .newlines) {
            let line = rawLine.trimmingCharacters(in: .whitespaces)

            if line.hasPrefix("```") {
                if isInCodeFence {
                    appendCode()
                    isInCodeFence = false
                } else {
                    appendParagraph()
                    appendBullets()
                    isInCodeFence = true
                    codeLanguage = String(line.dropFirst(3)).trimmingCharacters(in: .whitespacesAndNewlines)
                    if codeLanguage?.isEmpty == true {
                        codeLanguage = nil
                    }
                }
                continue
            }

            if isInCodeFence {
                codeLines.append(rawLine)
                continue
            }

            if line.isEmpty {
                appendParagraph()
                appendBullets()
                continue
            }

            if line == "---" || line == "***" {
                appendParagraph()
                appendBullets()
                blocks.append(MarkdownPreviewBlock(id: blocks.count, kind: .divider))
                continue
            }

            if let heading = heading(from: line) {
                appendParagraph()
                appendBullets()
                blocks.append(MarkdownPreviewBlock(id: blocks.count, kind: .heading(level: heading.level, text: heading.text)))
                continue
            }

            if let bullet = bullet(from: line) {
                appendParagraph()
                bulletLines.append(bullet)
                continue
            }

            appendBullets()
            paragraphLines.append(line)
        }

        if isInCodeFence {
            appendCode()
        }
        appendParagraph()
        appendBullets()

        return blocks.isEmpty
            ? [MarkdownPreviewBlock(id: 0, kind: .paragraph(content))]
            : blocks
    }

    private static func heading(from line: String) -> (level: Int, text: String)? {
        let hashes = line.prefix { $0 == "#" }.count
        guard (1...6).contains(hashes),
              line.dropFirst(hashes).first == " " else {
            return nil
        }
        return (hashes, String(line.dropFirst(hashes)).trimmingCharacters(in: .whitespaces))
    }

    private static func bullet(from line: String) -> String? {
        let markers = ["- ", "* ", "+ "]
        for marker in markers where line.hasPrefix(marker) {
            return String(line.dropFirst(marker.count)).trimmingCharacters(in: .whitespaces)
        }

        let components = line.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: false)
        guard components.count == 2,
              components[0].hasSuffix("."),
              components[0].dropLast().allSatisfy(\.isNumber) else {
            return nil
        }
        return String(components[1]).trimmingCharacters(in: .whitespaces)
    }
}

private struct MarkdownPreviewItemView: View {
    let item: MarkdownPreviewItem
    let searchText: String
    let interactionContext: MarkdownInteractionContext?

    var body: some View {
        switch item.kind {
        case .block(let block):
            MarkdownPreviewBlockView(block: block, searchText: searchText, interactionContext: interactionContext)
        case .section(let section):
            MarkdownPreviewSectionView(section: section, searchText: searchText, interactionContext: interactionContext)
        }
    }
}

private struct MarkdownPreviewSectionView: View {
    let section: MarkdownPreviewSection
    let searchText: String
    let interactionContext: MarkdownInteractionContext?
    @State private var isExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.14)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 10)
                    Text(section.title)
                        .font(.headline.weight(.semibold))
                    Spacer()
                    if !section.blocks.isEmpty {
                        Text("\(section.blocks.count)")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    if let value = section.value {
                        sectionValue(value)
                    }

                    ForEach(section.blocks) { block in
                        if isDecisionSection, case .bulletList(let items) = block.kind {
                            MarkdownDecisionListView(items: items, searchText: searchText, interactionContext: interactionContext)
                        } else {
                            MarkdownPreviewBlockView(block: block, searchText: searchText, interactionContext: interactionContext)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.045), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.secondary.opacity(0.10), lineWidth: 1)
        }
    }

    @ViewBuilder
    private func sectionValue(_ value: String) -> some View {
        if shouldRenderValueWithLabel {
            MarkdownPreviewInlineLine(
                text: "\(section.title): \(value)",
                searchText: searchText,
                interactionContext: interactionContext
            )
        } else {
            MarkdownPreviewInlineLine(
                text: value,
                searchText: searchText,
                interactionContext: interactionContext
            )
        }
    }

    private var shouldRenderValueWithLabel: Bool {
        ["close status"].contains(section.title.lowercased())
    }

    private var isDecisionSection: Bool {
        ["user decisions", "rozhodnutí uživatele"].contains(section.title.lowercased())
    }
}

private struct MarkdownDecisionListView: View {
    let items: [String]
    let searchText: String
    let interactionContext: MarkdownInteractionContext?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                MarkdownDecisionRow(entry: MarkdownDecisionEntry(item), searchText: searchText, interactionContext: interactionContext)
            }
        }
    }
}

private struct MarkdownDecisionRow: View {
    let entry: MarkdownDecisionEntry
    let searchText: String
    let interactionContext: MarkdownInteractionContext?

    var body: some View {
        HStack(alignment: .top, spacing: 11) {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.dateLabel)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                if let timeLabel = entry.timeLabel {
                    Text(timeLabel)
                        .font(.caption2.weight(.medium))
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .frame(width: 86, alignment: .leading)
            .background(Color.accentColor.opacity(0.11), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .foregroundStyle(Color.accentColor)

            MarkdownPreviewInlineLine(text: entry.text, searchText: searchText, interactionContext: interactionContext)
                .font(.body)
                .lineSpacing(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .textBackgroundColor).opacity(0.72), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.secondary.opacity(0.10), lineWidth: 1)
        }
    }
}

private struct MarkdownDecisionEntry {
    let dateLabel: String
    let timeLabel: String?
    let text: String

    init(_ raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        if let parsed = Self.parseTimestampPrefix(trimmed) {
            dateLabel = parsed.dateLabel
            timeLabel = parsed.timeLabel
            text = parsed.rest
        } else {
            dateLabel = L10n.t("Decision", "Rozhodnutí")
            timeLabel = nil
            text = trimmed
        }
    }

    private static func parseTimestampPrefix(_ value: String) -> (dateLabel: String, timeLabel: String?, rest: String)? {
        let pattern = #"^(\d{4}-\d{2}-\d{2}(?:T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z)?):\s*(.+)$"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: value, range: NSRange(value.startIndex..<value.endIndex, in: value)),
              let timestampRange = Range(match.range(at: 1), in: value),
              let restRange = Range(match.range(at: 2), in: value) else {
            return nil
        }

        let timestamp = String(value[timestampRange])
        let rest = String(value[restRange]).trimmingCharacters(in: .whitespacesAndNewlines)

        if timestamp.contains("T"), let date = ISO8601DateFormatter().date(from: timestamp) {
            return (
                Self.localDateFormatter.string(from: date),
                Self.localTimeFormatter.string(from: date),
                rest
            )
        }

        if let date = Self.sourceDateFormatter.date(from: timestamp) {
            return (Self.localDateFormatter.string(from: date), nil, rest)
        }

        return (timestamp, nil, rest)
    }

    private static let sourceDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let localDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = AppLanguage.current.locale
        return formatter
    }()

    private static let localTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = AppLanguage.current.locale
        return formatter
    }()
}

private struct MarkdownPreviewBlockView: View {
    let block: MarkdownPreviewBlock
    let searchText: String
    let interactionContext: MarkdownInteractionContext?

    var body: some View {
        switch block.kind {
        case .heading(let level, let text):
            Text(ArtifactPreview.highlighted(text, searchText: searchText))
                .font(font(for: level))
                .fontWeight(.semibold)
                .padding(.top, level <= 2 ? 8 : 2)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .paragraph(let text):
            MarkdownPreviewInlineLine(text: text, searchText: searchText, interactionContext: interactionContext)
                .font(.body)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .bulletList(let items):
            VStack(alignment: .leading, spacing: 7) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("-")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        MarkdownPreviewInlineLine(text: item, searchText: searchText, interactionContext: interactionContext)
                            .font(.body)
                            .lineSpacing(3)
                    }
                }
            }
            .padding(.leading, 4)
        case .code(let language, let text):
            VStack(alignment: .leading, spacing: 6) {
                if let language {
                    Text(language)
                        .font(.caption2.monospaced())
                        .foregroundStyle(.secondary)
                }
                ScrollView(.horizontal) {
                    Text(ArtifactPreview.highlighted(text, searchText: searchText))
                        .font(.system(.body, design: .monospaced))
                        .lineSpacing(3)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .background(.quaternary.opacity(0.6), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
        case .divider:
            Divider()
                .padding(.vertical, 4)
        }
    }

    private func font(for level: Int) -> Font {
        switch level {
        case 1: return .title2
        case 2: return .title3
        case 3: return .headline
        default: return .subheadline
        }
    }
}

private struct MarkdownPreviewInlineLine: View {
    let text: String
    let searchText: String
    let interactionContext: MarkdownInteractionContext?

    var body: some View {
        if let metadata = MarkdownMetadataLine.parse(text), metadata.kind == .status {
            HStack(alignment: .center, spacing: 7) {
                Text("\(metadata.label):")
                    .fontWeight(.medium)
                MarkdownStatusBadge(label: interactionContext?.canonicalPhaseStatus(for: metadata) ?? metadata.value)
            }
            .fixedSize(horizontal: false, vertical: true)
        } else if let phaseReference = interactionContext?.currentPhaseReference(in: text), let interactionContext {
            HStack(alignment: .center, spacing: 7) {
                Text("\(phaseReference.label):")
                    .fontWeight(.medium)
                MarkdownPhaseBadge(reference: phaseReference, context: interactionContext)
                if !phaseReference.rest.isEmpty {
                    Text(ArtifactPreview.highlighted(phaseReference.rest, searchText: searchText))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        } else if let metadata = MarkdownMetadataLine.parse(text), let interactionContext, metadata.kind.opensAgent {
            HStack(alignment: .center, spacing: 7) {
                Text("\(metadata.label):")
                    .fontWeight(.medium)
                if let agent = metadata.kind == .owner
                    ? interactionContext.ownerAgent(fallback: metadata.value)
                    : interactionContext.agent(for: metadata.value) {
                    MarkdownAgentBadge(agent: agent, context: interactionContext)
                } else {
                    DisabledAgentBadge(label: metadata.value, subtitle: nil)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        } else if let interactionContext, !interactionContext.fileReferences(in: text).isEmpty {
            MarkdownPreviewFileReferenceLine(
                text: text,
                searchText: searchText,
                artifacts: interactionContext.fileReferences(in: text),
                context: interactionContext
            )
        } else if let reference = interactionContext?.leadingAgentReference(in: text), let interactionContext {
            HStack(alignment: .top, spacing: 8) {
                if let agent = reference.agent {
                    MarkdownAgentBadge(agent: agent, context: interactionContext)
                } else {
                    DisabledAgentBadge(label: reference.missingLabel, subtitle: reference.missingSubtitle)
                }
                if !reference.rest.isEmpty {
                    Text(ArtifactPreview.highlighted(reference.rest, searchText: searchText))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        } else {
            Text(ArtifactPreview.highlighted(text, searchText: searchText))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct MarkdownMetadataLine {
    enum Kind {
        case status
        case phase
        case owner
        case agent

        var opensAgent: Bool {
            switch self {
            case .owner, .agent: return true
            case .status, .phase: return false
            }
        }
    }

    let kind: Kind
    let label: String
    let value: String

    static func parse(_ text: String) -> MarkdownMetadataLine? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let separator = trimmed.firstIndex(of: ":") else { return nil }

        let label = String(trimmed[..<separator]).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !label.isEmpty, label.count <= 24 else { return nil }

        let value = String(trimmed[trimmed.index(after: separator)...]).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return nil }

        switch label.lowercased() {
        case "status", "run status", "phase status", "close status", "stav", "stav běhu", "stav fáze", "stav uzavření":
            return MarkdownMetadataLine(kind: .status, label: label, value: value)
        case "current phase", "phase", "fáze", "aktuální fáze":
            return MarkdownMetadataLine(kind: .phase, label: label, value: value)
        case "owner", "parent", "agent", "actor", "reviewer", "assignee":
            return MarkdownMetadataLine(kind: label.lowercased() == "owner" ? .owner : .agent, label: label, value: value)
        default:
            return nil
        }
    }
}

private struct MarkdownPreviewFileReferenceLine: View {
    let text: String
    let searchText: String
    let artifacts: [Artifact]
    let context: MarkdownInteractionContext

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let label = leadingLabel {
                Text(label)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
            }

            FlowBadgeRow {
                ForEach(artifacts, id: \.id) { artifact in
                    MarkdownArtifactBadge(artifact: artifact, context: context)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var leadingLabel: String? {
        let patterns = [#"`([^`]+)`"#, Self.fileReferencePattern]
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { continue }
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            guard let match = regex.firstMatch(in: text, range: range),
                  let matchRange = Range(match.range, in: text) else {
                continue
            }

            let prefix = String(text[..<matchRange.lowerBound])
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
                .trimmingCharacters(in: .whitespacesAndNewlines)
            guard prefix.hasSuffix(":") else { return nil }
            return prefix
        }
        return nil
    }

    private static let fileReferencePattern = #"(?<![\w/.-])([.~A-Za-z0-9_/@:+-][A-Za-z0-9_./@:+~-]*\.(?:bash|c|cc|conf|cpp|css|csv|gql|graphql|h|hpp|html|java|js|json|jsonl|jsx|kt|log|m|markdown|md|mm|php|plist|py|rb|rs|schema|scss|sh|sql|swift|toml|ts|tsx|tsv|txt|xml|yaml|yml|zsh))(?![\w/.-])"#
}

private struct MarkdownPhaseBadge: View {
    let reference: MarkdownPhaseReference
    let context: MarkdownInteractionContext

    var body: some View {
        if let artifact = reference.artifact, let onSelectArtifact = context.onSelectArtifact {
            Button {
                onSelectArtifact(artifact)
            } label: {
                badge
            }
            .buttonStyle(.plain)
            .help(L10n.t("Open phase markdown", "Otevřít markdown fáze"))
        } else {
            badge
        }
    }

    private var badge: some View {
        HStack(spacing: 5) {
            Image(systemName: "flag")
                .font(.caption2)
            BadgePrefix(text: L10n.t("PHASE", "FÁZE"), tint: reference.phase.status.tint)
            Text(reference.phase.localizedTitle)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(reference.phase.status.tint.opacity(0.13), in: Capsule())
        .foregroundStyle(reference.phase.status.tint)
        .badgePointerCursor()
    }
}

struct BadgePrefix: View {
    let text: String
    let tint: Color

    var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .lineLimit(1)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(tint.opacity(0.16), in: Capsule())
            .foregroundStyle(tint.opacity(0.92))
    }
}

private struct MarkdownArtifactBadge: View {
    let artifact: Artifact
    let context: MarkdownInteractionContext

    private var style: MarkdownArtifactBadgeStyle {
        MarkdownArtifactBadgeStyle(artifact: artifact)
    }

    private var canPreview: Bool {
        context.canPreviewArtifact(artifact)
    }

    var body: some View {
        if canPreview, let onSelectArtifact = context.onSelectArtifact {
            Button {
                onSelectArtifact(artifact)
            } label: {
                badge
            }
            .buttonStyle(.plain)
            .help(artifact.path)
        } else {
            badge
                .opacity(canPreview ? 1 : 0.55)
                .help(canPreview ? artifact.path : L10n.t("File does not exist", "Soubor neexistuje"))
        }
    }

    @ViewBuilder
    private var badge: some View {
        let content = HStack(spacing: 5) {
            Image(systemName: style.systemImage)
                .font(.caption2)
            BadgePrefix(text: style.prefix, tint: style.tint)
            Text(artifact.displayTitle)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(style.tint.opacity(0.13), in: Capsule())
        .foregroundStyle(style.tint)

        if canPreview {
            content.badgePointerCursor()
        } else {
            content
        }
    }
}

struct MarkdownArtifactBadgeStyle {
    let tint: Color
    let systemImage: String
    let prefix: String

    init(artifact: Artifact) {
        let text = "\(artifact.path) \(artifact.title ?? "")".lowercased()
        let filePrefix = Self.filePrefix(for: artifact)

        if text.hasSuffix("state.md") {
            tint = .indigo
            systemImage = "doc.plaintext"
            prefix = filePrefix
        } else if text.contains("decision") {
            tint = .orange
            systemImage = "checkmark.bubble"
            prefix = L10n.t("DECISION", "ROZHODNUTÍ")
        } else if text.contains("handoff") {
            tint = .teal
            systemImage = "arrowshape.turn.up.right"
            prefix = L10n.t("HANDOFF", "PŘEDÁNÍ")
        } else if text.contains("finding") {
            tint = .red
            systemImage = "exclamationmark.bubble"
            prefix = L10n.t("FINDING", "NÁLEZ")
        } else if text.contains("review") {
            tint = .purple
            systemImage = "checkmark.seal"
            prefix = L10n.t("REVIEW", "KONTROLA")
        } else if text.contains("verification") || text.contains("validation") {
            tint = .green
            systemImage = "testtube.2"
            prefix = L10n.t("VERIFY", "OVĚŘENÍ")
        } else if text.contains("phase") {
            tint = .blue
            systemImage = "flag"
            prefix = L10n.t("PHASE", "FÁZE")
        } else if text.contains("plan") {
            tint = .mint
            systemImage = "list.bullet.clipboard"
            prefix = L10n.t("PLAN", "PLÁN")
        } else {
            tint = .secondary
            systemImage = "doc.richtext"
            prefix = filePrefix
        }
    }

    private static func filePrefix(for artifact: Artifact) -> String {
        let fileExtension = URL(fileURLWithPath: artifact.path).pathExtension.lowercased()
        switch artifact.kind {
        case .markdown:
            return "MD"
        case .json, .schema:
            return "JSON"
        case .jsonl:
            return "JSONL"
        case .source, .test:
            return L10n.t("CODE", "KÓD")
        case .log:
            return "LOG"
        case .external, .unknown:
            switch fileExtension {
            case "md", "markdown": return "MD"
            case "json", "schema": return "JSON"
            case "jsonl": return "JSONL"
            case "log": return "LOG"
            case "swift", "sh", "bash", "zsh", "js", "jsx", "ts", "tsx", "py", "rb", "rs", "go", "java", "css", "scss", "toml", "yaml", "yml", "xml", "html", "sql", "graphql", "gql":
                return L10n.t("CODE", "KÓD")
            default:
                return L10n.t("FILE", "SOUBOR")
            }
        case .app:
            return "APP"
        }
    }
}

private struct FlowBadgeRow<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        WrappingBadgeLayout(horizontalSpacing: 6, verticalSpacing: 6) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct WrappingBadgeLayout: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let maxWidth = proposal.width ?? .greatestFiniteMagnitude
        let result = layout(sizes: sizes, maxWidth: maxWidth)
        return CGSize(width: proposal.width ?? result.size.width, height: result.size.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let result = layout(sizes: sizes, maxWidth: bounds.width)

        for index in subviews.indices {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y),
                proposal: ProposedViewSize(sizes[index])
            )
        }
    }

    private func layout(sizes: [CGSize], maxWidth: CGFloat) -> (size: CGSize, positions: [CGPoint]) {
        guard !sizes.isEmpty else {
            return (.zero, [])
        }

        let availableWidth = max(maxWidth, 1)
        var positions: [CGPoint] = []
        var cursorX: CGFloat = 0
        var cursorY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var usedWidth: CGFloat = 0

        for size in sizes {
            let nextX = cursorX == 0 ? 0 : cursorX + horizontalSpacing
            if nextX > 0, nextX + size.width > availableWidth {
                cursorY += lineHeight + verticalSpacing
                cursorX = 0
                lineHeight = 0
            }

            let x = cursorX == 0 ? 0 : cursorX + horizontalSpacing
            positions.append(CGPoint(x: x, y: cursorY))
            cursorX = x + size.width
            lineHeight = max(lineHeight, size.height)
            usedWidth = max(usedWidth, cursorX)
        }

        return (CGSize(width: usedWidth, height: cursorY + lineHeight), positions)
    }
}

private struct MarkdownStatusBadge: View {
    let label: String

    private var tint: Color {
        let lower = label.lowercased()
        if lower.contains("closed") || lower.contains("done") || lower.contains("complete") || lower.contains("passed") || lower.contains("hotovo") {
            return .green
        }
        if lower.contains("dokon") || lower.contains("uzavř") {
            return .green
        }
        if lower.contains("fail") || lower.contains("error") || lower.contains("blocked") || lower.contains("selh") || lower.contains("blok") {
            return .red
        }
        if lower.contains("review") || lower.contains("pending") || lower.contains("wait") || lower.contains("ček") {
            return .orange
        }
        if lower.contains("probíh") {
            return .blue
        }
        if lower.contains("active") || lower.contains("open") || lower.contains("running") || lower.contains("progress") || lower.contains("prob") {
            return .blue
        }
        return .secondary
    }

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(tint)
                .frame(width: 6, height: 6)
            Text(label)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(tint.opacity(0.12), in: Capsule())
        .foregroundStyle(tint)
        .badgePointerCursor()
    }
}

private struct MarkdownAgentBadge: View {
    let agent: Agent
    let context: MarkdownInteractionContext

    var body: some View {
        AgentBadgeButton(agent: agent) {
            context.onSelectAgent(agent)
        }
    }
}

struct AgentBadgeButton: View {
    let agent: Agent
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: agent.role.systemImage)
                    .font(.caption2)
                BadgePrefix(text: L10n.t("AGENT", "AGENT"), tint: agent.role.tint)
                VStack(alignment: .leading, spacing: 0) {
                    Text(agent.displayName ?? agent.id)
                        .font(.caption.weight(.semibold))
                        .lineLimit(1)
                    Text(agent.role.label)
                        .font(.caption2.weight(.medium))
                        .lineLimit(1)
                        .foregroundStyle(agent.role.tint.opacity(0.72))
                }
                Circle()
                    .fill(agent.status.tint)
                    .frame(width: 6, height: 6)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(agent.role.tint.opacity(0.13), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .foregroundStyle(agent.role.tint)
            .badgePointerCursor()
        }
        .buttonStyle(.plain)
        .help(L10n.t("Open agent detail", "Otevřít detail agenta"))
    }
}

private struct DisabledAgentBadge: View {
    let label: String
    let subtitle: String?

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.caption2)
            BadgePrefix(text: L10n.t("AGENT", "AGENT"), tint: .secondary)
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                Text(subtitle ?? L10n.t("Missing agent", "Chybějící agent"))
                    .font(.caption2.weight(.medium))
                    .lineLimit(1)
                    .foregroundStyle(.secondary.opacity(0.72))
            }
            Circle()
                .fill(Color.secondary.opacity(0.65))
                .frame(width: 6, height: 6)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.13), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .foregroundStyle(.secondary)
        .opacity(0.78)
        .help(L10n.t("This agent is not available in the current structured state.", "Tenhle agent není dostupný v aktuálním strukturovaném stavu."))
    }
}

private struct MarkdownPlainBadge: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.caption.weight(.semibold))
            .lineLimit(1)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.secondary.opacity(0.12), in: Capsule())
            .foregroundStyle(.secondary)
            .badgePointerCursor()
    }
}

private struct SearchContextLine: View {
    let content: String
    let searchText: String

    var body: some View {
        if let context = context {
            Label(context, systemImage: "magnifyingglass")
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        } else {
            EmptyView()
        }
    }

    private var context: String? {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty, let range = content.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) else {
            return nil
        }
        let lowerBound = content.index(range.lowerBound, offsetBy: -min(content.distance(from: content.startIndex, to: range.lowerBound), 48))
        let upperBound = content.index(range.upperBound, offsetBy: min(content.distance(from: range.upperBound, to: content.endIndex), 96))
        return String(content[lowerBound..<upperBound]).replacingOccurrences(of: "\n", with: " ")
    }
}

private enum MarkdownPreviewMode: String, CaseIterable, Identifiable {
    case rendered
    case raw

    var id: String { rawValue }

    var label: String {
        switch self {
        case .rendered: return L10n.t("Rendered", "Náhled")
        case .raw: return L10n.t("Raw", "Zdroj")
        }
    }
}

private extension ArtifactPreview.DisplayMode {
    var label: String {
        switch self {
        case .markdown: return "Markdown"
        case .text: return "Text"
        case .code: return L10n.t("Source", "Zdroj")
        }
    }
}

private extension ArtifactPreview {
    func matchCount(for searchText: String) -> Int {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return 0 }
        var count = 0
        var searchRange = content.startIndex..<content.endIndex
        while let range = content.range(of: query, options: [.caseInsensitive, .diacriticInsensitive], range: searchRange) {
            count += 1
            searchRange = range.upperBound..<content.endIndex
        }
        return count
    }

    func attributedContent(searchText: String) -> AttributedString {
        Self.highlighted(content, searchText: searchText)
    }

    static func highlighted(_ content: String, searchText: String) -> AttributedString {
        var attributed = AttributedString(content)
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return attributed }

        var searchRange = content.startIndex..<content.endIndex
        while let range = content.range(of: query, options: [.caseInsensitive, .diacriticInsensitive], range: searchRange) {
            if let attributedRange = Range(range, in: attributed) {
                attributed[attributedRange].backgroundColor = .yellow.opacity(0.35)
            }
            searchRange = range.upperBound..<content.endIndex
        }
        return attributed
    }
}

enum ArtifactIcon {
    static func name(for kind: ArtifactKind) -> String {
        switch kind {
        case .markdown: return "doc.richtext"
        case .json, .jsonl, .schema: return "curlybraces"
        case .source: return "chevron.left.forwardslash.chevron.right"
        case .test: return "checklist"
        case .log: return "terminal"
        case .app: return "app"
        case .external: return "link"
        case .unknown: return "doc"
        }
    }
}

extension EvidenceCategory {
    var systemImage: String {
        switch self {
        case .decisionsPlan: return "checkmark.bubble"
        case .review: return "checkmark.seal"
        case .verification: return "testtube.2"
        case .contractsSchemas: return "curlybraces"
        case .appSource: return "shippingbox"
        }
    }
}

extension Artifact {
    var displayTitle: String {
        if let title, !title.isEmpty {
            return title
        }
        let lastComponent = URL(fileURLWithPath: path).lastPathComponent
        return lastComponent.isEmpty ? path : lastComponent
    }

    var summaryLine: String {
        let parts = [
            kind.displayLabel,
            updatedAt.map { ConsoleFormatters.relative($0) }
        ].compactMap { $0 }
        return parts.joined(separator: " - ")
    }
}

private extension ArtifactKind {
    var displayLabel: String {
        switch self {
        case .markdown: return "Markdown"
        case .json: return "JSON"
        case .jsonl: return "JSONL"
        case .source: return L10n.t("Source", "Zdroj")
        case .test: return "Test"
        case .log: return "Log"
        case .schema: return "Schema"
        case .app: return "App"
        case .external: return L10n.t("External", "Externí")
        case .unknown: return L10n.t("File", "Soubor")
        }
    }
}
