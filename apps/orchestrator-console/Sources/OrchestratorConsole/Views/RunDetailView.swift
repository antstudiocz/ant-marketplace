import OrchestratorConsoleCore
import SwiftUI

struct RunDetailView: View {
    let run: RunRecord
    @ObservedObject var store: RunStore
    @SceneStorage("orchestratorConsole.selectedDetailTab") private var selectedTab = OrchestrationDetailTab.agents.rawValue

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RunHeaderView(run: run)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)

            Divider()

            OrchestrationMapPage(run: run, store: store, selectedTab: $selectedTab)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(nsColor: .textBackgroundColor))
    }
}

private enum OrchestrationDetailTab: String, CaseIterable, Identifiable {
    case agents
    case markdown

    var id: String { rawValue }

    var title: String {
        switch self {
        case .agents: return L10n.t("Agent map", "Mapa agentů")
        case .markdown: return L10n.t("Markdown tree", "Markdown strom")
        }
    }
}

private struct RunHeaderView: View {
    let run: RunRecord

    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(run.displayTitle)
                        .font(.title3.weight(.semibold))
                        .lineLimit(1)
                    Text(run.directoryURL.path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }

                HStack(alignment: .center, spacing: 14) {
                    HeaderFact(label: L10n.t("Phase", "Fáze"), value: run.currentPhase?.localizedTitle ?? run.state?.currentPhaseId ?? L10n.t("None", "Žádná"))
                    if let state = run.state, let riskTier = state.flowContext.displayRiskTier {
                        HeaderFact(label: L10n.t("Risk", "Riziko"), value: riskTier)
                    }
                    if let state = run.state, let flowMode = state.flowContext.displayFlowMode {
                        HeaderFact(label: L10n.t("Flow", "Flow"), value: flowMode)
                    }
                    if let state = run.state, let cycle = state.flowContext.displayCycle {
                        HeaderFact(label: L10n.t("Cycle", "Cyklus"), value: cycle)
                    }
                    HeaderFact(label: L10n.t("Updated", "Aktualizace"), value: ConsoleFormatters.relative(run.updatedAt))
                }
            }

            Spacer()

            StatusBadge(label: run.status.label, tint: run.status.tint)
        }
    }
}

private struct OrchestrationMapPage: View {
    let run: RunRecord
    @ObservedObject var store: RunStore
    @Binding var selectedTab: String
    @State private var selectedAgent: AgentSheetSelection?
    @State private var agentBackStack: [AgentSheetSelection] = []
    @State private var selectedMarkdownId: String?

    private var markdownArtifacts: [Artifact] {
        MarkdownArtifactCatalog.artifacts(for: run)
    }

    private var selectedMarkdown: Artifact? {
        markdownArtifacts.first { $0.id == selectedMarkdownId } ?? defaultMarkdown
    }

    private var defaultMarkdown: Artifact? {
        markdownArtifacts.first { URL(fileURLWithPath: $0.path).lastPathComponent.lowercased() == "state.md" }
            ?? markdownArtifacts.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                OrchestrationTabControl(selectedTab: $selectedTab)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)

            Divider()

            ZStack {
                switch OrchestrationDetailTab(rawValue: selectedTab) ?? .agents {
                case .agents:
                    agentMapContent
                case .markdown:
                    MarkdownTreePage(
                        run: run,
                        artifacts: markdownArtifacts,
                        selectedArtifactId: selectedMarkdownId,
                        store: store,
                        onSelectAgent: selectAgent
                    ) { artifact in
                        selectedMarkdownId = artifact.id
                    }
                }
            }
        }
        .overlay {
            if let selectedAgent {
                ZStack {
                    Color.black.opacity(0.18)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            closeAgentDialog()
                        }

                    AgentBriefDialog(
                        selection: selectedAgent,
                        store: store,
                        canGoBack: !agentBackStack.isEmpty,
                        goBack: goBackInAgentDialog,
                        onSelectAgent: selectAgent,
                        close: closeAgentDialog
                    )
                }
            }
        }
        .onAppear {
            if selectedMarkdownId == nil {
                selectedMarkdownId = defaultMarkdown?.id
            }
        }
        .onChange(of: run.id) { _, _ in
            selectedMarkdownId = defaultMarkdown?.id
        }
    }

    private var agentMapContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let state = run.state {
                    AgentHierarchyBoard(
                        state: state,
                        events: run.events,
                        markdownArtifacts: markdownArtifacts
                    ) { selection in
                        openAgentFromMap(selection)
                    }
                } else {
                    NoAgentMapView()
                }
            }
            .padding(24)
        }
    }

    private func openAgentFromMap(_ selection: AgentSheetSelection) {
        agentBackStack.removeAll()
        selectedAgent = selection
    }

    private func selectAgent(_ agent: Agent) {
        guard let state = run.state else { return }
        let nextSelection = AgentSheetSelection(
            run: state,
            events: run.events,
            agent: agent,
            markdownArtifacts: markdownArtifacts
        )
        guard selectedAgent?.agent.id != nextSelection.agent.id else { return }
        if let selectedAgent {
            agentBackStack.append(selectedAgent)
        }
        selectedAgent = nextSelection
    }

    private func goBackInAgentDialog() {
        guard let previous = agentBackStack.popLast() else { return }
        selectedAgent = previous
    }

    private func closeAgentDialog() {
        selectedAgent = nil
        agentBackStack.removeAll()
    }
}

private struct OrchestrationTabControl: View {
    @Binding var selectedTab: String

    var body: some View {
        HStack(spacing: 0) {
            ForEach(OrchestrationDetailTab.allCases) { tab in
                Button {
                    selectedTab = tab.rawValue
                } label: {
                    Text(tab.title)
                        .font(.callout.weight(selectedTab == tab.rawValue ? .semibold : .regular))
                        .lineLimit(1)
                        .frame(width: 150, height: 28)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .foregroundStyle(selectedTab == tab.rawValue ? Color.white : Color.primary)
                .background {
                    if selectedTab == tab.rawValue {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.accentColor)
                    }
                }
            }
        }
        .padding(2)
        .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 7, style: .continuous))
        .frame(width: 304, alignment: .leading)
    }
}

private struct MarkdownTreePage: View {
    let run: RunRecord
    let artifacts: [Artifact]
    let selectedArtifactId: String?
    @ObservedObject var store: RunStore
    let onSelectAgent: (Agent) -> Void
    let onSelect: (Artifact) -> Void

    private var selectedArtifact: Artifact? {
        artifacts.first { $0.id == selectedArtifactId } ?? artifacts.first
    }

    private var tree: [MarkdownTreeNode] {
        MarkdownTreeBuilder.tree(run: run, artifacts: artifacts)
    }

    var body: some View {
        HSplitView {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Label(L10n.t("Evidence explorer", "Evidence explorer"), systemImage: "point.3.connected.trianglepath.dotted")
                        .font(.headline)
                        .padding(.horizontal, 14)
                        .padding(.top, 14)

                    if tree.isEmpty {
                        EmptyPanelLine(text: L10n.t("No markdown files", "Žádné markdown soubory"))
                            .padding(.horizontal, 14)
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(tree) { node in
                                MarkdownTreeNodeView(
                                    node: node,
                                    selectedArtifactId: selectedArtifact?.id,
                                    onSelect: onSelect
                                )
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 14)
                    }
                }
            }
            .frame(minWidth: 280, idealWidth: 360, maxWidth: 440)

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 10) {
                    Label(selectedArtifact?.displayTitle ?? L10n.t("Preview", "Náhled"), systemImage: "doc.richtext")
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    if let selectedArtifact {
                        Text(selectedArtifact.path)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)

                Divider()

                MarkdownInlinePreview(
                    artifact: selectedArtifact,
                    store: store,
                    interactionContext: run.state.map {
                        MarkdownInteractionContext(
                            run: $0,
                            artifact: selectedArtifact,
                            artifacts: artifacts,
                            onSelectAgent: onSelectAgent,
                            onSelectArtifact: onSelect
                        )
                    }
                )
            }
            .frame(minWidth: 640)
        }
    }
}

private struct MarkdownTreeNodeView: View {
    let node: MarkdownTreeNode
    let selectedArtifactId: String?
    let onSelect: (Artifact) -> Void
    var depth: Int = 0
    @State private var isExpanded = false

    private var isSelected: Bool {
        node.artifact?.id == selectedArtifactId
    }

    private var isActiveBranch: Bool {
        guard let selectedArtifactId else { return false }
        return node.containsArtifact(id: selectedArtifactId)
    }

    var body: some View {
        if let artifact = node.artifact {
            Button {
                onSelect(artifact)
            } label: {
                MarkdownTreeRow(
                    node: node,
                    isSelected: isSelected,
                    isActiveBranch: isActiveBranch,
                    isExpanded: nil,
                    depth: depth
                )
            }
            .buttonStyle(.plain)
            .help(artifact.path)
        } else {
            VStack(alignment: .leading, spacing: 3) {
                Button {
                    withAnimation(.easeInOut(duration: 0.14)) {
                        isExpanded.toggle()
                    }
                } label: {
                    MarkdownTreeRow(
                        node: node,
                        isSelected: false,
                        isActiveBranch: isActiveBranch,
                        isExpanded: isExpanded,
                        depth: depth
                    )
                }
                .buttonStyle(.plain)

                if isExpanded {
                    ForEach(node.children) { child in
                        MarkdownTreeNodeView(
                            node: child,
                            selectedArtifactId: selectedArtifactId,
                            onSelect: onSelect,
                            depth: depth + 1
                        )
                    }
                }
            }
        }
    }
}

private struct MarkdownTreeRow: View {
    let node: MarkdownTreeNode
    let isSelected: Bool
    let isActiveBranch: Bool
    let isExpanded: Bool?
    let depth: Int

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if let isExpanded {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 10)
                    .padding(.top, 4)
            } else {
                Spacer()
                    .frame(width: 10)
            }

            Image(systemName: node.systemImage)
                .foregroundStyle(isSelected || isActiveBranch ? Color.accentColor : .secondary)
                .frame(width: 16)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(node.title)
                    .font(.callout.weight(node.artifact == nil ? .semibold : .medium))
                    .lineLimit(1)
                if let subtitle = node.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }

            Spacer(minLength: 8)

            if let badge = node.badge {
                Text(badge)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(isSelected ? Color.accentColor : .secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.09), in: Capsule())
                    .badgePointerCursor()
            }

            if node.artifact == nil {
                Text("\(node.artifactCount)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .padding(.leading, CGFloat(depth) * 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
        .contentShape(Rectangle())
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.accentColor.opacity(0.13)
        }
        if isActiveBranch {
            return Color.accentColor.opacity(0.055)
        }
        if node.artifact == nil {
            return Color.accentColor.opacity(depth == 0 ? 0.045 : 0.028)
        }
        return Color.clear
    }
}

private struct NoAgentMapView: View {
    var body: some View {
        Panel(title: L10n.t("Agent map", "Mapa agentů"), systemImage: "point.3.connected.trianglepath.dotted") {
            EmptyPanelLine(text: L10n.t("This run has no structured agent state. Markdown files are still available on the right.", "Tenhle běh nemá strukturovaný stav agentů. Markdown soubory jsou pořád dostupné vpravo."))
        }
    }
}

private struct AgentHierarchyBoard: View {
    let state: OrchestratorRun
    let events: [OrchestratorEvent]
    let markdownArtifacts: [Artifact]
    let onSelect: (AgentSheetSelection) -> Void
    @State private var hoveredAgentId: String?

    private var layout: AgentHierarchyLayout {
        AgentHierarchyLayout(run: state)
    }

    private var highlightedAgentIds: Set<String> {
        guard let hoveredAgentId else { return [] }
        var ids: Set<String> = [hoveredAgentId]
        for edge in highlightedEdges(for: hoveredAgentId) {
            ids.insert(edge.fromAgentId)
            ids.insert(edge.toAgentId)
        }
        return ids
    }

    var body: some View {
        Panel(title: L10n.t("Agent map", "Mapa agentů"), systemImage: "point.3.connected.trianglepath.dotted") {
            if state.agents.isEmpty {
                EmptyPanelLine(text: L10n.t("No agents", "Žádní agenti"))
            } else {
                GeometryReader { geometry in
                    let metrics = AgentBoardMetrics(layout: layout, size: geometry.size)
                    let highlightedAgentIds = highlightedAgentIds

                    ZStack(alignment: .topLeading) {
                        Canvas { context, _ in
                            for edge in layout.visibleEdges {
                                guard let path = metrics.path(for: edge) else { continue }
                                let visual = edgeVisual(edge)
                                let isHighlighted = hoveredAgentId == nil || highlightedEdges(for: hoveredAgentId!).contains(edge)
                                context.stroke(
                                    path,
                                    with: .color(isHighlighted && hoveredAgentId != nil ? visual.color.opacity(visual.highlightOpacity) : Color.secondary.opacity(0.16)),
                                    style: StrokeStyle(lineWidth: isHighlighted && hoveredAgentId != nil ? visual.highlightWidth : 1, lineCap: .round, lineJoin: .round, dash: [])
                                )
                            }
                        }
                        .allowsHitTesting(false)

                        ForEach(layout.nodes) { node in
                            let isHovered = hoveredAgentId == node.agent.id
                            let isConnected = highlightedAgentIds.contains(node.agent.id)
                            AgentNodeButton(
                                node: node,
                                isHovered: isHovered,
                                isConnected: hoveredAgentId == nil || isConnected,
                                isDimmed: hoveredAgentId != nil && !isConnected
                            ) {
                                onSelect(
                                    AgentSheetSelection(
                                        run: state,
                                        events: events,
                                        agent: node.agent,
                                        markdownArtifacts: markdownArtifacts
                                    )
                                )
                            }
                            .frame(width: metrics.nodeSize.width, height: metrics.nodeSize.height)
                            .position(metrics.center(for: node))
                        }
                    }
                    .frame(width: geometry.size.width, height: metrics.boardHeight, alignment: .topLeading)
                    .onContinuousHover(coordinateSpace: .local) { phase in
                        switch phase {
                        case .active(let point):
                            hoveredAgentId = metrics.nodeId(at: point)
                        case .ended:
                            hoveredAgentId = nil
                        }
                    }
                    .animation(.easeOut(duration: 0.14), value: hoveredAgentId)
                }
                .frame(minHeight: AgentBoardMetrics(layout: layout, size: CGSize(width: 900, height: 1)).boardHeight)
            }
        }
    }

    private func highlightedEdges(for agentId: String) -> [AgentEdge] {
        layout.visibleEdges.filter { edge in
            edge.fromAgentId == agentId || edge.toAgentId == agentId
        }
    }

    private func edgeVisual(_ edge: AgentEdge) -> AgentEdgeVisual {
        switch edge.relation {
        case .delegates, .reportsTo:
            return .child
        case .reviews:
            return .review
        case .blocks:
            return .block
        case .unknown:
            return .unknown
        }
    }
}

private enum AgentEdgeVisual {
    case child
    case review
    case block
    case unknown

    var color: Color {
        switch self {
        case .child: return .accentColor
        case .review: return .orange
        case .block: return .red
        case .unknown: return .secondary
        }
    }

    var dash: [CGFloat] {
        switch self {
        case .review: return [8, 4]
        case .child, .block, .unknown: return []
        }
    }

    var highlightOpacity: Double {
        switch self {
        case .unknown: return 0.4
        case .child, .review, .block: return 0.78
        }
    }

    var highlightWidth: CGFloat {
        switch self {
        case .unknown: return 1.6
        case .child, .review, .block: return 2.4
        }
    }
}

private struct AgentNodeButton: View {
    let node: AgentHierarchyNode
    let isHovered: Bool
    let isConnected: Bool
    let isDimmed: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 8) {
                    Image(systemName: node.agent.role.systemImage)
                        .foregroundStyle(node.agent.role.tint)
                        .frame(width: 16)
                    Text(node.agent.displayName ?? node.agent.id)
                        .font(.callout.weight(.semibold))
                        .lineLimit(1)
                    Spacer(minLength: 4)
                }

                Text(node.agent.role.label)
                    .font(.caption)
                    .foregroundStyle(node.agent.role.tint.opacity(0.82))
                    .lineLimit(1)

                if let intent = node.agent.intentLine {
                    Text(OrchestratorCopy.text(intent))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                AgentNodeStatusBadge(status: node.agent.status)
            }
            .padding(11)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(nsColor: .textBackgroundColor))
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(node.agent.role.tint.opacity(isConnected ? 0.12 : 0.04))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isHovered ? node.agent.role.tint.opacity(0.85) : node.agent.role.tint.opacity(isConnected ? 0.40 : 0.15), lineWidth: isHovered ? 2 : 1)
            }
            .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
        .opacity(isDimmed ? 0.36 : 1)
        .help(L10n.t("Open agent summary", "Otevřít souhrn agenta"))
    }
}

private struct AgentNodeStatusBadge: View {
    let status: AgentStatus

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: status.systemImage)
                .font(.caption2.weight(.semibold))
            Text(status.label)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(status.tint.opacity(0.13), in: Capsule())
        .foregroundStyle(status.tint)
        .badgePointerCursor()
    }
}

private struct MarkdownEvidencePane: View {
    let artifacts: [Artifact]
    let selectedArtifactId: String?
    @ObservedObject var store: RunStore
    let onSelect: (Artifact) -> Void

    private var selectedArtifact: Artifact? {
        artifacts.first { $0.id == selectedArtifactId } ?? artifacts.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Label(L10n.t("Markdown", "Markdown"), systemImage: "doc.richtext")
                    .font(.headline)
                Spacer()
                Text("\(artifacts.count)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider()

            if artifacts.isEmpty {
                EmptyPanelLine(text: L10n.t("No markdown files", "Žádné markdown soubory"))
                    .padding(16)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(artifacts) { artifact in
                            MarkdownArtifactRow(
                                artifact: artifact,
                                isSelected: artifact.id == selectedArtifact?.id
                            ) {
                                onSelect(artifact)
                            }
                        }
                    }
                }
                .frame(height: 190)

                Divider()

                MarkdownInlinePreview(artifact: selectedArtifact, store: store)
            }
        }
        .background(Color(nsColor: .textBackgroundColor))
        .overlay(alignment: .leading) {
            Divider()
        }
    }
}

private struct MarkdownArtifactRow: View {
    let artifact: Artifact
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 9) {
                Image(systemName: "doc.text")
                    .foregroundStyle(isSelected ? Color.accentColor : .secondary)
                    .frame(width: 16)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 2) {
                    Text(artifact.displayTitle)
                        .font(.callout.weight(.medium))
                        .lineLimit(1)
                    Text(artifact.path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }

                Spacer(minLength: 8)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.accentColor.opacity(0.12) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct MarkdownInlinePreview: View {
    let artifact: Artifact?
    @ObservedObject var store: RunStore
    var interactionContext: MarkdownInteractionContext? = nil

    var body: some View {
        Group {
            if let artifact {
                switch store.previewArtifact(artifact) {
                case .success(let preview):
                    ScrollView {
                        if preview.displayMode == .markdown {
                            MarkdownArtifactPreview(content: preview.content, searchText: "", interactionContext: interactionContext)
                                .padding(18)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        } else {
                            Text(preview.content)
                                .font(.system(.body, design: .monospaced))
                                .textSelection(.enabled)
                                .padding(18)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                    }
                case .failure(let error):
                    VStack(alignment: .leading, spacing: 8) {
                        Label(L10n.t("Preview unavailable", "Náhled není dostupný"), systemImage: "exclamationmark.triangle")
                            .font(.headline)
                            .foregroundStyle(.orange)
                        Text(error.localizedDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

private struct AgentBriefDialog: View {
    let selection: AgentSheetSelection
    @ObservedObject var store: RunStore
    let canGoBack: Bool
    let goBack: () -> Void
    let onSelectAgent: (Agent) -> Void
    let close: () -> Void
    @State private var selectedArtifactId: String?

    private var brief: AgentBrief {
        AgentBrief(selection: selection)
    }

    private var selectedArtifact: Artifact? {
        guard let selectedArtifactId else { return nil }
        return brief.markdownArtifacts.first { $0.id == selectedArtifactId }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            Divider()

            if selectedArtifact == nil {
                summaryScroll
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HSplitView {
                    summaryScroll
                        .frame(minWidth: 300, idealWidth: 360)

                    markdownPane
                        .frame(minWidth: 420)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(width: 980, height: 620)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.secondary.opacity(0.18), lineWidth: 1)
        }
        .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .onTapGesture {}
        .shadow(color: .black.opacity(0.22), radius: 34, y: 18)
        .onChange(of: selection.agent.id) { _, _ in
            selectedArtifactId = nil
        }
    }

    private var header: some View {
        ZStack(alignment: .leading) {
            if canGoBack {
                Button {
                    goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(.borderless)
                .help(L10n.t("Back", "Zpět"))
            }

            HStack(alignment: .center, spacing: 12) {
                Image(systemName: selection.agent.role.systemImage)
                    .font(.body)
                    .foregroundStyle(selection.agent.role.tint)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 1) {
                    Text(selection.agent.displayName ?? selection.agent.id)
                        .font(.headline.weight(.semibold))
                        .lineLimit(1)
                    Text(selection.agent.role.label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                StatusBadge(label: selection.agent.status.label, tint: selection.agent.status.tint)

                Button {
                    close()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(.borderless)
                .help(L10n.t("Close", "Zavřít"))
                .keyboardShortcut(.cancelAction)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 18)
        .frame(height: 58, alignment: .center)
    }

    private var summaryScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                BriefSection(title: L10n.t("Assignment", "Zadání agenta"), items: brief.assignment)
                BriefSection(title: L10n.t("Did", "Dělal"), items: brief.did)
                BriefSection(title: L10n.t("Next", "Bude dělat"), items: brief.next)
                BriefSection(title: L10n.t("Output", "Výstup"), items: brief.outputs)
                AgentRelationshipsSection(title: L10n.t("Parent", "Nadřízený"), relationships: brief.parents, emptyText: L10n.t("No parent agent", "Žádný nadřízený agent"), limit: 1, select: onSelectAgent)
                AgentRelationshipsSection(title: L10n.t("Children", "Podřízení"), relationships: brief.children, emptyText: L10n.t("No child agents", "Žádní podřízení agenti"), select: onSelectAgent)
                AgentDialogMarkdownList(
                    artifacts: brief.markdownArtifacts,
                    selectedArtifact: selectedArtifact,
                    select: { selectedArtifactId = $0.id }
                )
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }

    private var markdownPane: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Label(selectedArtifact?.displayTitle ?? L10n.t("No markdown", "Žádný markdown"), systemImage: "doc.richtext")
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            if let selectedArtifact {
                MarkdownInlinePreview(
                    artifact: selectedArtifact,
                    store: store,
                    interactionContext: MarkdownInteractionContext(
                        run: selection.run,
                        artifact: selectedArtifact,
                        artifacts: brief.markdownArtifacts,
                        onSelectAgent: onSelectAgent,
                        onSelectArtifact: { artifact in
                            selectedArtifactId = artifact.id
                        }
                    )
                )
            } else {
                EmptyPanelLine(text: L10n.t("Select a markdown file to preview it here.", "Vyber markdown soubor a tady se zobrazí náhled."))
                    .padding(18)
                Spacer()
            }
        }
    }
}

private struct BriefSection: View {
    let title: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            if items.isEmpty {
                Text(L10n.t("No signal yet", "Zatím bez signálu"))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .fill(Color.secondary.opacity(0.65))
                                .frame(width: 5, height: 5)
                                .padding(.top, 7)
                            Text(OrchestratorCopy.text(item))
                                .font(.callout)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }
}

private struct AgentRelationshipsSection: View {
    let title: String
    let relationships: [AgentRelationship]
    let emptyText: String
    var limit: Int? = nil
    let select: (Agent) -> Void

    private var visibleRelationships: [AgentRelationship] {
        if let limit {
            return Array(relationships.prefix(limit))
        }
        return relationships
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            if visibleRelationships.isEmpty {
                Text(emptyText)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(visibleRelationships) { relationship in
                        AgentBadgeButton(agent: relationship.agent) {
                            select(relationship.agent)
                        }
                    }
                }
            }
        }
    }
}

private struct AgentDialogMarkdownList: View {
    let artifacts: [Artifact]
    let selectedArtifact: Artifact?
    let select: (Artifact) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.t("Markdown", "Markdown"))
                .font(.headline)

            if artifacts.isEmpty {
                Text(L10n.t("No markdown linked to this agent.", "K tomuhle agentovi není připojený markdown."))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(artifacts.prefix(8)) { artifact in
                        let isSelected = artifact.id == selectedArtifact?.id
                        Button {
                            select(artifact)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.richtext")
                                    .foregroundStyle(isSelected ? Color.accentColor : .secondary)
                                    .frame(width: 16)
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(artifact.displayTitle)
                                        .font(.callout.weight(.medium))
                                        .lineLimit(1)
                                    Text(artifact.path)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                }
                                Spacer(minLength: 8)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(isSelected ? Color.accentColor.opacity(0.12) : Color.clear, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .help(L10n.t("Preview in app", "Zobrazit v aplikaci"))
                    }
                }
            }
        }
    }
}

private struct AgentSheetSelection: Identifiable {
    let run: OrchestratorRun
    let events: [OrchestratorEvent]
    let agent: Agent
    let markdownArtifacts: [Artifact]

    var id: String { agent.id }
}

private struct AgentBrief {
    let assignment: [String]
    let did: [String]
    let next: [String]
    let outputs: [String]
    let parents: [AgentRelationship]
    let children: [AgentRelationship]
    let markdownArtifacts: [Artifact]

    init(selection: AgentSheetSelection) {
        let detail = AgentDetail(run: selection.run, events: selection.events, agentId: selection.agent.id)
        let relatedMarkdown = MarkdownArtifactCatalog.relatedArtifacts(
            for: selection.agent,
            detail: detail,
            markdownArtifacts: selection.markdownArtifacts
        )

        let checkpoints = detail?.relatedCheckpoints.prefix(4).map {
            $0.summary?.isEmpty == false ? $0.summary! : $0.title
        } ?? []
        let events = detail?.relatedEvents.prefix(4).map(\.message) ?? []
        let summary = selection.agent.summary.map { [$0] } ?? []
        let assignmentItems = Self.assignmentItems(for: selection.agent)

        var didItems = Array((checkpoints + events + summary).uniqued().prefix(6))
        if didItems.isEmpty, selection.agent.status == .done {
            didItems = [L10n.t("Finished assigned work.", "Dokončil přiřazenou práci.")]
        }

        let blockers = detail?.relatedBlockers.filter { $0.status == .open }.prefix(3).map { "Blocked: \($0.title)" } ?? []
        let pendingChildren = detail?.children
            .filter { $0.agent.status == .pending || $0.agent.status == .running }
            .prefix(3)
            .map { L10n.t("Wait for \($0.agent.displayName ?? $0.agent.id).", "Počkat na \($0.agent.displayName ?? $0.agent.id).") } ?? []
        let nextItems: [String]
        if selection.agent.status == .done {
            nextItems = [L10n.t("No next action. Agent is done.", "Žádná další akce. Agent je hotový.")]
        } else if !blockers.isEmpty {
            nextItems = Array(blockers)
        } else if !pendingChildren.isEmpty {
            nextItems = Array(pendingChildren)
        } else {
            nextItems = [AgentSummaryRow(agent: selection.agent, detail: detail).currentTask]
        }

        let outputItems = relatedMarkdown.prefix(5).map { artifact in
            artifact.title?.isEmpty == false ? artifact.title! : artifact.displayTitle
        }

        self.assignment = assignmentItems
        self.did = didItems
        self.next = nextItems.uniqued()
        self.outputs = outputItems.isEmpty && selection.agent.status == .done
            ? [L10n.t("No explicit markdown output linked to this agent.", "K tomuhle agentovi není připojený explicitní markdown výstup.")]
            : Array(outputItems)
        self.parents = detail?.parents ?? []
        self.children = detail?.children ?? []
        self.markdownArtifacts = relatedMarkdown
    }

    private static func assignmentItems(for agent: Agent) -> [String] {
        var items: [String] = []

        if let intent = agent.intentLine {
            items.append(intent)
        }

        items.append(contentsOf: agent.plannedWork?.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        } ?? [])

        if let doneDefinition = agent.doneDefinition?.trimmingCharacters(in: .whitespacesAndNewlines),
           !doneDefinition.isEmpty {
            items.append(L10n.t("Done when: \(doneDefinition)", "Hotovo, když: \(doneDefinition)"))
        }

        return items.uniqued()
    }
}

private extension Agent {
    var intentLine: String? {
        if let intent = intent?.trimmingCharacters(in: .whitespacesAndNewlines), !intent.isEmpty {
            return intent
        }
        if let summary = summary?.trimmingCharacters(in: .whitespacesAndNewlines), !summary.isEmpty {
            return summary
        }
        return nil
    }
}

private enum MarkdownArtifactCatalog {
    static func artifacts(for run: RunRecord) -> [Artifact] {
        let structuredMarkdown = run.artifacts.filter(isMarkdown)
        let all = structuredMarkdown + run.markdownArtifacts
        var seen = Set<String>()
        return all
            .filter { seen.insert($0.path).inserted }
            .sorted { lhs, rhs in
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

    static func relatedArtifacts(for agent: Agent, detail: AgentDetail?, markdownArtifacts: [Artifact]) -> [Artifact] {
        let explicitIds = Set(detail?.relatedArtifacts.map(\.id) ?? [])
        let agentNeedles = [
            agent.id.lowercased(),
            agent.displayName?.lowercased()
        ].compactMap { $0 }

        return markdownArtifacts.filter { artifact in
            if artifact.agentId == agent.id || explicitIds.contains(artifact.id) {
                return true
            }
            let text = "\(artifact.path) \(artifact.title ?? "")".lowercased()
            return agentNeedles.contains { text.contains($0) }
        }
    }

    private static func isMarkdown(_ artifact: Artifact) -> Bool {
        artifact.kind == .markdown || ["md", "markdown"].contains(URL(fileURLWithPath: artifact.path).pathExtension.lowercased())
    }
}

private struct MarkdownTreeNode: Identifiable {
    let id: String
    let title: String
    let subtitle: String?
    let systemImage: String
    let badge: String?
    let artifact: Artifact?
    let children: [MarkdownTreeNode]

    var artifactCount: Int {
        if artifact != nil { return 1 }
        return children.reduce(0) { $0 + $1.artifactCount }
    }

    func containsArtifact(id: String) -> Bool {
        if artifact?.id == id {
            return true
        }
        return children.contains { $0.containsArtifact(id: id) }
    }
}

private struct MarkdownPathEntry {
    let artifact: Artifact
    let components: [String]
}

private enum MarkdownArtifactType {
    case state
    case handoff
    case decision
    case finding
    case review
    case verify
    case phase
    case plan
    case markdown
}

private enum MarkdownTreeBuilder {
    static func tree(run: RunRecord, artifacts: [Artifact]) -> [MarkdownTreeNode] {
        guard !artifacts.isEmpty else { return [] }

        let overviewArtifacts = artifacts.filter { isRunOverview($0, runId: run.runId) }
        let primaryArtifacts = artifacts.filter { artifact in
            !overviewArtifacts.contains(where: { $0.id == artifact.id })
                && isPrimaryArtifact(artifact, run: run)
        }
        let archivalArtifacts = artifacts.filter { artifact in
            !overviewArtifacts.contains(where: { $0.id == artifact.id })
                && !primaryArtifacts.contains(where: { $0.id == artifact.id })
        }

        let overviewNodes: [MarkdownTreeNode] = overviewArtifacts.isEmpty
            ? []
            : [
                MarkdownTreeNode(
                    id: "run-overview",
                    title: L10n.t("Run overview", "Přehled běhu"),
                    subtitle: nil,
                    systemImage: "doc.plaintext",
                    badge: nil,
                    artifact: nil,
                    children: overviewArtifacts
                        .sorted { localizedSort($0.displayTitle, $1.displayTitle) }
                        .map(leafNode)
                )
            ]

        let primaryNodes: [MarkdownTreeNode] = primaryArtifacts.isEmpty
            ? []
            : [
                MarkdownTreeNode(
                    id: "current-evidence",
                    title: L10n.t("Current evidence", "Aktuální evidence"),
                    subtitle: L10n.t("Canonical", "Kanonické"),
                    systemImage: "checkmark.seal",
                    badge: nil,
                    artifact: nil,
                    children: primaryArtifacts
                        .sorted { localizedSort($0.displayTitle, $1.displayTitle) }
                        .map(leafNode)
                )
            ]

        let archiveNodes: [MarkdownTreeNode]
        if let state = run.state, !state.phases.isEmpty {
            var assignedArtifactIds = Set<String>()
            var phaseNodes: [MarkdownTreeNode] = []

            for phase in state.phases {
                let phaseArtifacts = archivalArtifacts.filter { matches($0, phase: phase) }
                guard !phaseArtifacts.isEmpty else { continue }
                assignedArtifactIds.formUnion(phaseArtifacts.map(\.id))

                phaseNodes.append(
                    MarkdownTreeNode(
                        id: "phase-\(phase.id)",
                        title: phase.localizedTitle,
                        subtitle: phase.status.label,
                        systemImage: "flag",
                        badge: nil,
                        artifact: nil,
                        children: pathTree(
                            entries: phaseArtifacts.map {
                                MarkdownPathEntry(
                                    artifact: $0,
                                    components: relativeComponents(for: $0, runId: run.runId, phase: phase)
                                )
                            }
                        )
                    )
                )
            }

            let unassigned = archivalArtifacts.filter { !assignedArtifactIds.contains($0.id) }
            if !unassigned.isEmpty {
                phaseNodes.append(
                    MarkdownTreeNode(
                        id: "unassigned-markdown",
                        title: L10n.t("Other", "Ostatní"),
                        subtitle: nil,
                        systemImage: "folder",
                        badge: nil,
                        artifact: nil,
                        children: pathTree(entries: unassigned.map {
                            MarkdownPathEntry(artifact: $0, components: relativeComponents(for: $0, runId: run.runId, phase: nil))
                        })
                    )
                )
            }

            archiveNodes = phaseNodes.isEmpty
                ? []
                : [
                    MarkdownTreeNode(
                        id: "markdown-archive",
                        title: L10n.t("Archive", "Archiv"),
                        subtitle: L10n.t("Closed phases and subphases", "Uzavřené fáze a subfáze"),
                        systemImage: "archivebox",
                        badge: nil,
                        artifact: nil,
                        children: phaseNodes
                    )
                ]
        } else {
            let archiveChildren = pathTree(entries: archivalArtifacts.map {
                MarkdownPathEntry(artifact: $0, components: relativeComponents(for: $0, runId: run.runId, phase: nil))
            })
            archiveNodes = archiveChildren.isEmpty
                ? []
                : [
                    MarkdownTreeNode(
                        id: "markdown-archive",
                        title: L10n.t("Archive", "Archiv"),
                        subtitle: nil,
                        systemImage: "archivebox",
                        badge: nil,
                        artifact: nil,
                        children: archiveChildren
                    )
                ]
        }

        return overviewNodes + primaryNodes + archiveNodes
    }

    private static func pathTree(entries: [MarkdownPathEntry]) -> [MarkdownTreeNode] {
        let leaves = entries
            .filter { $0.components.count <= 1 }
            .map { leafNode(for: $0.artifact) }

        let folderEntries = entries.filter { $0.components.count > 1 }
        let grouped = Dictionary(grouping: folderEntries) { $0.components[0] }
        let folders = grouped.keys.sorted(by: localizedSort).map { component in
            MarkdownTreeNode(
                id: "folder-\(component)-\(grouped[component]?.map(\.artifact.id).joined(separator: "|") ?? component)",
                title: displayName(for: component),
                subtitle: nil,
                systemImage: "folder",
                badge: nil,
                artifact: nil,
                children: pathTree(entries: (grouped[component] ?? []).map {
                    MarkdownPathEntry(artifact: $0.artifact, components: Array($0.components.dropFirst()))
                })
            )
        }

        return folders + leaves.sorted { localizedSort($0.title, $1.title) }
    }

    private static func matches(_ artifact: Artifact, phase: Phase) -> Bool {
        if artifact.phaseId == phase.id {
            return true
        }

        let text = artifact.path.lowercased()
        let id = phase.id.lowercased()
        let titleSlug = slug(phase.title)
        return text.contains("/\(id)/")
            || text.contains("/\(id)-")
            || (!titleSlug.isEmpty && text.contains(titleSlug))
    }

    private static func relativeComponents(for artifact: Artifact, runId: String, phase: Phase?) -> [String] {
        let components = artifact.path.split(separator: "/").map(String.init)

        if let phase,
           let phasesIndex = components.firstIndex(of: "phases") {
            let phaseSlug = slug(phase.title)
            let start = components[(phasesIndex + 1)...].firstIndex { component in
                let lower = component.lowercased()
                return lower.contains(phase.id.lowercased()) || (!phaseSlug.isEmpty && lower.contains(phaseSlug))
            }
            if let start {
                let tail = Array(components.dropFirst(start + 1))
                return tail.isEmpty ? [artifact.displayTitle] : tail
            }
        }

        if phase != nil {
            return [L10n.t("External references", "Externí reference"), artifact.displayTitle]
        }

        if let runIndex = components.firstIndex(of: runId) {
            let tail = Array(components.dropFirst(runIndex + 1))
            return tail.isEmpty ? [artifact.displayTitle] : tail
        }

        return components.isEmpty ? [artifact.displayTitle] : Array(components.suffix(min(components.count, 5)))
    }

    private static func displayName(for component: String) -> String {
        if component == "subphases" {
            return L10n.t("Subphases", "Subfáze")
        }
        return component
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: ".md", with: "")
            .capitalized
    }

    private static func leafNode(for artifact: Artifact) -> MarkdownTreeNode {
        MarkdownTreeNode(
            id: "artifact-\(artifact.id)",
            title: artifact.displayTitle,
            subtitle: nil,
            systemImage: systemImage(for: artifact),
            badge: typeLabel(for: artifact),
            artifact: artifact,
            children: []
        )
    }

    private static func isRunOverview(_ artifact: Artifact, runId: String) -> Bool {
        let fileName = URL(fileURLWithPath: artifact.path).lastPathComponent.lowercased()
        guard ["state.md", "index.md", "decisions.md", "handoff.md"].contains(fileName) else {
            return false
        }

        let components = artifact.path.split(separator: "/").map(String.init)
        guard let runIndex = components.firstIndex(of: runId) else {
            return fileName == "state.md"
        }

        return Array(components.dropFirst(runIndex + 1)).count == 1
    }

    private static func isPrimaryArtifact(_ artifact: Artifact, run: RunRecord) -> Bool {
        let fileName = URL(fileURLWithPath: artifact.path).lastPathComponent.lowercased()

        if fileName == "implementation-plan.md" {
            return true
        }

        if let state = run.state {
            let stateArtifactPaths = Set(state.artifacts.map { normalizedPath($0.path) })
            if stateArtifactPaths.contains(normalizedPath(artifact.path)) {
                return true
            }

            if let currentPhaseId = state.currentPhaseId, artifact.phaseId == currentPhaseId {
                return true
            }

            if let currentPhaseId = state.currentPhaseId,
               normalizedPath(artifact.path).contains("/\(currentPhaseId.lowercased())/"),
               ["phase.md", "handoff.md", "review.md", "verification.md", "decisions.md"].contains(fileName) {
                return true
            }
        }

        return false
    }

    private static func typeLabel(for artifact: Artifact) -> String {
        switch artifactType(for: artifact) {
        case .state: return L10n.t("state", "stav")
        case .handoff: return L10n.t("handoff", "předání")
        case .decision: return L10n.t("decision", "rozhodnutí")
        case .finding: return L10n.t("finding", "nález")
        case .review: return L10n.t("review", "kontrola")
        case .verify: return L10n.t("verify", "ověření")
        case .phase: return L10n.t("phase", "fáze")
        case .plan: return L10n.t("plan", "plán")
        case .markdown: return L10n.t("md", "md")
        }
    }

    private static func artifactType(for artifact: Artifact) -> MarkdownArtifactType {
        let text = "\(artifact.path) \(artifact.title ?? "")".lowercased()
        if text.hasSuffix("state.md") { return .state }
        if text.contains("handoff") { return .handoff }
        if text.contains("decision") { return .decision }
        if text.contains("finding") { return .finding }
        if text.contains("review") { return .review }
        if text.contains("verification") || text.contains("validation") { return .verify }
        if text.contains("phase") { return .phase }
        if text.contains("plan") { return .plan }
        return .markdown
    }

    private static func systemImage(for artifact: Artifact) -> String {
        switch artifactType(for: artifact) {
        case .decision: return "checkmark.bubble"
        case .handoff: return "arrowshape.turn.up.right"
        case .review: return "checkmark.seal"
        case .verify: return "testtube.2"
        case .phase: return "flag"
        case .plan: return "list.bullet.clipboard"
        case .state: return "doc.plaintext"
        case .finding, .markdown: return "doc.richtext"
        }
    }

    private static func slug(_ value: String) -> String {
        value
            .lowercased()
            .replacingOccurrences(of: "_", with: "-")
            .replacingOccurrences(of: " ", with: "-")
    }

    private static func normalizedPath(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "/")
            .lowercased()
    }

    private static func localizedSort(_ lhs: String, _ rhs: String) -> Bool {
        lhs.localizedStandardCompare(rhs) == .orderedAscending
    }
}

private struct AgentHierarchyLayout {
    let nodes: [AgentHierarchyNode]
    let visibleEdges: [AgentEdge]
    let columnCount: Int
    let maxRows: Int

    init(run: OrchestratorRun) {
        let agentsById = Dictionary(uniqueKeysWithValues: run.agents.map { ($0.id, $0) })
        let edges = Self.displayEdges(
            run.edges.filter { agentsById[$0.fromAgentId] != nil && agentsById[$0.toAgentId] != nil }
        )
        let parentIds = Set(edges.map(\.toAgentId))
        let rootIds = run.agents
            .filter { $0.role == .rootOrchestrator || !parentIds.contains($0.id) }
            .sorted(by: Self.agentSort)
            .map(\.id)

        var levels: [String: Int] = [:]
        var queue = rootIds.map { ($0, 0) }
        while !queue.isEmpty {
            let current = queue.removeFirst()
            if let existing = levels[current.0], existing <= current.1 {
                continue
            }
            levels[current.0] = current.1
            for child in edges.filter({ $0.fromAgentId == current.0 }).map(\.toAgentId) {
                queue.append((child, current.1 + 1))
            }
        }

        for agent in run.agents where levels[agent.id] == nil {
            levels[agent.id] = Self.fallbackLevel(for: agent.role)
        }

        let grouped = Dictionary(grouping: run.agents, by: { levels[$0.id] ?? 0 })
        var nodes: [AgentHierarchyNode] = []
        for column in grouped.keys.sorted() {
            let agents = (grouped[column] ?? []).sorted(by: Self.agentSort)
            for (row, agent) in agents.enumerated() {
                nodes.append(AgentHierarchyNode(agent: agent, column: column, row: row))
            }
        }

        self.nodes = nodes
        self.visibleEdges = edges
        self.columnCount = max((levels.values.max() ?? 0) + 1, 1)
        self.maxRows = max(grouped.values.map(\.count).max() ?? 1, 1)
    }

    private static func displayEdges(_ edges: [AgentEdge]) -> [AgentEdge] {
        let delegatePairs = Set(edges.filter { $0.relation == .delegates }.map {
            "\($0.fromAgentId)->\($0.toAgentId)"
        })
        var seen = Set<String>()

        return edges.filter { edge in
            if edge.relation == .reportsTo,
               delegatePairs.contains("\(edge.toAgentId)->\(edge.fromAgentId)") {
                return false
            }

            let key = "\(edge.fromAgentId)->\(edge.toAgentId):\(edge.relation.rawValue)"
            return seen.insert(key).inserted
        }
    }

    private static func agentSort(lhs: Agent, rhs: Agent) -> Bool {
        let leftRank = roleRank(lhs.role)
        let rightRank = roleRank(rhs.role)
        if leftRank == rightRank {
            return (lhs.displayName ?? lhs.id).localizedStandardCompare(rhs.displayName ?? rhs.id) == .orderedAscending
        }
        return leftRank < rightRank
    }

    private static func fallbackLevel(for role: AgentRole) -> Int {
        switch role {
        case .rootOrchestrator: return 0
        case .planner, .scout, .planWriter: return 1
        case .implementationLead: return 2
        case .sliceWorker, .reviewer: return 3
        case .unknown: return 4
        }
    }

    private static func roleRank(_ role: AgentRole) -> Int {
        switch role {
        case .rootOrchestrator: return 0
        case .planner: return 1
        case .scout: return 2
        case .planWriter: return 3
        case .implementationLead: return 4
        case .sliceWorker: return 5
        case .reviewer: return 6
        case .unknown: return 7
        }
    }
}

private struct AgentHierarchyNode: Identifiable {
    let agent: Agent
    let column: Int
    let row: Int

    var id: String { agent.id }
}

private struct AgentBoardMetrics {
    let layout: AgentHierarchyLayout
    let size: CGSize
    let nodeSize = CGSize(width: 190, height: 118)
    let rowGap: CGFloat = 28
    let topPadding: CGFloat = 30

    var boardHeight: CGFloat {
        CGFloat(layout.maxRows) * nodeSize.height + CGFloat(max(layout.maxRows - 1, 0)) * rowGap + topPadding * 2
    }

    func center(for node: AgentHierarchyNode) -> CGPoint {
        let availableWidth = max(size.width, CGFloat(layout.columnCount) * (nodeSize.width + 58))
        let columnWidth = availableWidth / CGFloat(max(layout.columnCount, 1))
        let x = columnWidth * CGFloat(node.column) + columnWidth / 2
        let y = topPadding + nodeSize.height / 2 + CGFloat(node.row) * (nodeSize.height + rowGap)
        return CGPoint(x: x, y: y)
    }

    func inputPoint(for agentId: String) -> CGPoint? {
        guard let node = layout.nodes.first(where: { $0.agent.id == agentId }) else { return nil }
        let center = center(for: node)
        return CGPoint(x: center.x - nodeSize.width / 2, y: center.y)
    }

    func outputPoint(for agentId: String) -> CGPoint? {
        guard let node = layout.nodes.first(where: { $0.agent.id == agentId }) else { return nil }
        let center = center(for: node)
        return CGPoint(x: center.x + nodeSize.width / 2, y: center.y)
    }

    func path(for edge: AgentEdge) -> Path? {
        guard let start = outputPoint(for: edge.fromAgentId),
              let end = inputPoint(for: edge.toAgentId) else {
            return nil
        }

        let direction: CGFloat = end.x >= start.x ? 1 : -1
        let lead = max(28, min(64, abs(end.x - start.x) * 0.18))
        let startLead = CGPoint(x: start.x + lead * direction, y: start.y)
        let endLead = CGPoint(x: end.x - lead * direction, y: end.y)
        let midX = (startLead.x + endLead.x) / 2

        var path = Path()
        path.move(to: start)
        path.addLine(to: startLead)
        path.addCurve(
            to: CGPoint(x: midX, y: (start.y + end.y) / 2),
            control1: CGPoint(x: midX, y: start.y),
            control2: CGPoint(x: midX, y: start.y)
        )
        path.addCurve(
            to: endLead,
            control1: CGPoint(x: midX, y: end.y),
            control2: CGPoint(x: midX, y: end.y)
        )
        path.addLine(to: end)
        return path
    }

    func nodeId(at point: CGPoint) -> String? {
        layout.nodes.first { node in
            let center = center(for: node)
            let rect = CGRect(
                x: center.x - nodeSize.width / 2,
                y: center.y - nodeSize.height / 2,
                width: nodeSize.width,
                height: nodeSize.height
            )
            return rect.contains(point)
        }?.agent.id
    }
}

private extension Array where Element == String {
    func uniqued() -> [String] {
        var seen = Set<String>()
        return filter { value in
            let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !normalized.isEmpty else { return false }
            return seen.insert(normalized).inserted
        }
    }
}

private struct RunCockpitView: View {
    let run: RunRecord
    let state: OrchestratorRun

    private var summary: CommandCenterSummary {
        CommandCenterSummary(run: state, events: run.events)
    }

    private var currentWork: CurrentWorkSummary {
        CurrentWorkSummary(run: state, events: run.events)
    }

    private var health: RunHealthSummary {
        RunHealthSummary(run: state, events: run.events)
    }

    private var signals: [SignificantTimelineEvent] {
        SignificantTimelineEvent.timeline(run: state, events: run.events)
            .filter { !$0.isTechnical }
    }

    private var agents: [AgentSummaryRow] {
        AgentSummaryRow.rows(run: state, events: run.events)
    }

    private var attentionItems: [AttentionItem] {
        AttentionItem.items(run: state, events: run.events, currentWork: currentWork, health: health, agents: agents)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            CockpitHeadline(run: run, summary: summary, currentWork: currentWork)
            NeedsAttentionView(items: attentionItems)
            ActiveAgentsView(agents: agents)
            CompactPhaseRail(state: state)
            SignalFeedView(signals: signals)

            if !run.warnings.isEmpty {
                WarningListView(warnings: run.warnings)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

private struct CockpitHeadline: View {
    let run: RunRecord
    let summary: CommandCenterSummary
    let currentWork: CurrentWorkSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 14) {
                Circle()
                    .fill(summary.severity.tint)
                    .frame(width: 10, height: 10)

                VStack(alignment: .leading, spacing: 5) {
                    Text(OrchestratorCopy.text(summary.verdict))
                        .font(.system(size: 28, weight: .semibold))
                        .lineLimit(2)
                    Text(statusLine)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 16)
            }

            Divider()

            FactRow(label: L10n.t("Next", "Další"), value: OrchestratorCopy.text(summary.nextAction), tint: summary.severity.tint, prominent: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(summary.severity.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(summary.severity.tint.opacity(0.22), lineWidth: 1)
        }
    }

    private var statusLine: String {
        let owner = currentWork.activeAgent.map { $0.displayName ?? $0.id } ?? L10n.t("no active owner", "bez aktivního vlastníka")
        let phase = currentWork.phase?.title ?? L10n.t("no active phase", "bez aktivní fáze")
        return L10n.t(
            "\(run.status.label) / \(phase) / \(owner) / updated \(ConsoleFormatters.relative(run.updatedAt))",
            "\(run.status.label) / \(phase) / \(owner) / aktualizováno \(ConsoleFormatters.relative(run.updatedAt))"
        )
    }
}

private struct NeedsAttentionView: View {
    let items: [AttentionItem]

    var body: some View {
        Panel(title: L10n.t("Needs attention", "Vyžaduje pozornost"), systemImage: "exclamationmark.triangle") {
            if items.isEmpty {
                InlineStateLine(
                    title: L10n.t("Clear", "Čisté"),
                    detail: L10n.t("No blockers, failed validation, pending decision, or stale active agent.", "Žádné blokery, selhaná validace, čekající rozhodnutí ani zatuhlý aktivní agent."),
                    tint: .green
                )
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(items.prefix(5)) { item in
                        FactRow(label: item.label, value: OrchestratorCopy.text(item.detail), tint: item.tint)
                    }
                }
            }
        }
    }
}

private struct ActiveAgentsView: View {
    let agents: [AgentSummaryRow]

    private var visibleAgents: [AgentSummaryRow] {
        let visible = agents.filter { $0.isAttention || $0.isActive || $0.agent.status == .pending }
        return visible.isEmpty ? Array(agents.filter { $0.agent.status == .done }.prefix(3)) : visible
    }

    private var doneCount: Int {
        agents.filter { $0.agent.status == .done }.count
    }

    var body: some View {
        Panel(title: L10n.t("Sub-agents", "Sub-agenti"), systemImage: "person.3.sequence") {
            if agents.isEmpty {
                EmptyPanelLine(text: L10n.t("No agents", "Žádní agenti"))
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(visibleAgents.prefix(8)) { row in
                        AgentCompactLine(row: row)
                    }

                    if doneCount > 0 {
                        InlineStateLine(
                            title: L10n.t("Done", "Hotovo"),
                            detail: L10n.t("\(doneCount) completed agent\(doneCount == 1 ? "" : "s") hidden from live view.", "\(doneCount) dokončených agentů skryto z živého pohledu."),
                            tint: .green
                        )
                    }
                }
            }
        }
    }
}

private struct CompactPhaseRail: View {
    let state: OrchestratorRun

    var body: some View {
        if !state.phases.isEmpty {
            Panel(title: L10n.t("Flow", "Průběh"), systemImage: "arrow.right") {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) {
                        ForEach(state.phases) { phase in
                            PhaseChip(phase: phase, isCurrent: phase.id == state.currentPhaseId)
                        }
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(state.phases) { phase in
                            PhaseLine(phase: phase, isCurrent: phase.id == state.currentPhaseId)
                        }
                    }
                }
            }
        }
    }
}

private struct SignalFeedView: View {
    let signals: [SignificantTimelineEvent]

    var body: some View {
        Panel(title: L10n.t("Signals", "Signály"), systemImage: "clock") {
            if signals.isEmpty {
                EmptyPanelLine(text: L10n.t("No important signals yet", "Zatím žádné důležité signály"))
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(signals.prefix(5)) { signal in
                        FactRow(label: ConsoleFormatters.relative(signal.timestamp), value: OrchestratorCopy.text(signal.title), tint: signal.severity.tint)
                    }
                }
            }
        }
    }
}

private struct AgentCompactLine: View {
    let row: AgentSummaryRow

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 14) {
            Text(row.name)
                .font(.callout.weight(.medium))
                .frame(width: 120, alignment: .leading)
                .lineLimit(1)

            Text(OrchestratorCopy.text(row.currentTask))
                .font(.callout)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(row.agent.status.label)
                .font(.caption.weight(.medium))
                .foregroundStyle(row.agent.status.tint)
                .frame(width: 80, alignment: .leading)

            Text(ConsoleFormatters.relative(row.updatedAt))
                .font(.caption)
                .foregroundStyle(row.isStale ? .orange : .secondary)
                .frame(width: 84, alignment: .trailing)
        }
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Divider().opacity(0.45)
        }
    }
}

private struct InlineStateLine: View {
    let title: String
    let detail: String
    let tint: Color

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Circle()
                .fill(tint)
                .frame(width: 6, height: 6)
            Text(title)
                .font(.callout.weight(.medium))
            Text(detail)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            Spacer()
        }
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Divider().opacity(0.45)
        }
    }
}

private struct PhaseChip: View {
    let phase: Phase
    let isCurrent: Bool

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(phase.status.tint)
                .frame(width: 6, height: 6)
            Text(phase.localizedTitle)
                .font(.caption.weight(isCurrent ? .semibold : .regular))
                .lineLimit(1)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(isCurrent ? phase.status.tint.opacity(0.12) : Color.secondary.opacity(0.06), in: Capsule())
        .foregroundStyle(isCurrent ? phase.status.tint : .secondary)
        .badgePointerCursor()
    }
}

private struct PhaseLine: View {
    let phase: Phase
    let isCurrent: Bool

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Circle()
                .fill(phase.status.tint)
                .frame(width: isCurrent ? 8 : 6, height: isCurrent ? 8 : 6)

            Text(phase.localizedTitle)
                .font(.callout.weight(isCurrent ? .semibold : .regular))
                .lineLimit(1)

            Spacer()

            Text(phase.status.label)
                .font(.caption)
                .foregroundStyle(phase.status.tint)
        }
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Divider().opacity(0.45)
        }
    }
}

private struct FactRow: View {
    let label: String
    let value: String
    var tint: Color = .secondary
    var prominent = false

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 14) {
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
                .frame(width: 96, alignment: .leading)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Circle()
                    .fill(tint)
                    .frame(width: 6, height: 6)
                Text(value)
                    .font(prominent ? .callout.weight(.semibold) : .callout)
                    .lineLimit(prominent ? 3 : 2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Divider().opacity(0.45)
        }
    }
}

private struct HeaderFact: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.callout.weight(.medium))
                .lineLimit(1)
        }
    }
}

enum OrchestratorCopy {
    static func text(_ value: String) -> String {
        if AppLanguage.current == .english {
            return value
        }

        switch value {
        case "Decision needed": return "Čeká na rozhodnutí"
        case "Completed": return "Dokončeno"
        case "Completed with follow-up": return "Dokončeno s navazující prací"
        case "Failed": return "Selhalo"
        case "Review in progress": return "Probíhá review"
        case "Validation in progress": return "Probíhá validace"
        case "Implementation in progress": return "Probíhá implementace"
        case "Paused": return "Pozastaveno"
        case "Run finished and required evidence is present.": return "Běh skončil a požadovaná evidence je dostupná."
        case "Run finished; review the remaining evidence gaps.": return "Běh skončil; zkontroluj chybějící evidenci."
        case "No structured milestone is active.": return "Není aktivní žádný strukturovaný milník."
        case "Resolve the pending decision so implementation can continue.": return "Vyřeš čekající rozhodnutí, aby implementace mohla pokračovat."
        case "Fix the latest validation failure and rerun verification.": return "Oprav poslední selhání validace a spusť ověření znovu."
        case "Resolve review findings and re-check the evidence.": return "Vyřeš nálezy z review a znovu zkontroluj evidenci."
        case "Review final evidence, decisions, and delivery handoff.": return "Zkontroluj finální evidenci, rozhodnutí a předání."
        case "User decision is blocking progress.": return "Postup blokuje rozhodnutí uživatele."
        case "No open decision signal.": return "Žádný otevřený signál k rozhodnutí."
        case "No open blocker, failed validation, or unresolved review signal.": return "Žádný otevřený bloker, selhaná validace ani nevyřešený review signál."
        case "User decision is needed before the run can proceed.": return "Než běh může pokračovat, je potřeba rozhodnutí uživatele."
        case "Review the current phase evidence.": return "Zkontroluj evidenci aktuální fáze."
        case "Validation passed; review readiness and delivery evidence.": return "Validace prošla; zkontroluj připravenost a delivery evidenci."
        case "Run is completed; review final evidence or artifacts.": return "Běh je dokončený; zkontroluj finální evidenci nebo artefakty."
        case "Waiting for the next structured event or checkpoint.": return "Čeká se na další strukturovanou událost nebo checkpoint."
        default:
            if value.hasPrefix("Blocked: ") {
                return "Blokováno: " + String(value.dropFirst("Blocked: ".count))
            }
            if value.hasPrefix("Resolve blocker: ") {
                return "Vyřeš bloker: " + String(value.dropFirst("Resolve blocker: ".count))
            }
            if value.hasPrefix("Evidence gaps: ") {
                return "Mezery v evidenci: " + String(value.dropFirst("Evidence gaps: ".count))
            }
            if value.hasSuffix(" is in progress.") {
                return value.replacingOccurrences(of: " is in progress.", with: " probíhá.")
            }
            return value
        }
    }
}

struct AgentSummaryRow: Identifiable {
    let agent: Agent
    let detail: AgentDetail?

    static func rows(run: OrchestratorRun, events: [OrchestratorEvent]) -> [AgentSummaryRow] {
        run.agents
            .map { AgentSummaryRow(agent: $0, detail: AgentDetail(run: run, events: events, agentId: $0.id)) }
            .sorted { lhs, rhs in
                if lhs.rank == rhs.rank {
                    return lhs.updatedAt > rhs.updatedAt
                }
                return lhs.rank < rhs.rank
            }
    }

    var id: String { agent.id }
    var name: String { agent.displayName ?? agent.id }
    var updatedAt: Date { detail?.lastUpdate?.timestamp ?? agent.updatedAt ?? agent.startedAt ?? .distantPast }

    var isActive: Bool {
        agent.status == .running || agent.status == .pending
    }

    var isStale: Bool {
        isActive && Date().timeIntervalSince(updatedAt) > 15 * 60
    }

    var isAttention: Bool {
        agent.status == .blocked || agent.status == .failed || isStale
    }

    var rank: Int {
        if isAttention { return 0 }
        switch agent.status {
        case .running: return 1
        case .pending: return 2
        case .done: return 3
        case .blocked, .failed: return 0
        case .cancelled, .unknown: return 4
        }
    }

    var currentTask: String {
        if let blocker = detail?.relatedBlockers.first(where: { $0.status == .open }) {
            return L10n.t("Blocked: \(blocker.title)", "Blokováno: \(blocker.title)")
        }
        if let checkpoint = detail?.relatedCheckpoints.first {
            return checkpoint.summary?.isEmpty == false ? checkpoint.summary! : checkpoint.title
        }
        if let planned = agent.plannedWork?.first?.trimmingCharacters(in: .whitespacesAndNewlines), !planned.isEmpty {
            return planned
        }
        if let intent = agent.intent?.trimmingCharacters(in: .whitespacesAndNewlines), !intent.isEmpty {
            return intent
        }
        if let summary = agent.summary, !summary.isEmpty {
            return summary
        }
        if let event = detail?.lastUpdate {
            return event.message
        }
        return agent.status.label
    }
}

private struct AttentionItem: Identifiable {
    let id: String
    let label: String
    let detail: String
    let tint: Color

    static func items(
        run: OrchestratorRun,
        events: [OrchestratorEvent],
        currentWork: CurrentWorkSummary,
        health: RunHealthSummary,
        agents: [AgentSummaryRow]
    ) -> [AttentionItem] {
        var items: [AttentionItem] = []

        if currentWork.needsUserDecision {
            items.append(.init(id: "decision", label: L10n.t("Decision", "Rozhodnutí"), detail: currentWork.nextStep, tint: .orange))
        }

        for blocker in currentWork.openBlockers.prefix(2) {
            items.append(.init(id: "blocker-\(blocker.id)", label: L10n.t("Blocker", "Bloker"), detail: blocker.title, tint: blocker.severity.tint))
        }

        if health.failedValidations > 0 {
            items.append(.init(
                id: "validation",
                label: L10n.t("Validation", "Validace"),
                detail: L10n.t("\(health.failedValidations) failed validation event\(health.failedValidations == 1 ? "" : "s").", "\(health.failedValidations) selhaných validačních událostí."),
                tint: .red
            ))
        }

        for row in agents.filter(\.isStale).prefix(2) {
            items.append(.init(
                id: "stale-\(row.id)",
                label: L10n.t("Stale", "Zatuhlý"),
                detail: L10n.t("\(row.name) last reported \(ConsoleFormatters.relative(row.updatedAt)).", "\(row.name) naposledy reportoval \(ConsoleFormatters.relative(row.updatedAt))."),
                tint: .orange
            ))
        }

        if run.status != .completed && currentWork.activeAgent == nil {
            items.append(.init(id: "owner", label: L10n.t("Owner", "Vlastník"), detail: L10n.t("No active owner is currently assigned.", "Není přiřazený žádný aktivní vlastník."), tint: .orange))
        }

        return items
    }
}

private struct EvidenceOnlyView: View {
    let run: RunRecord
    @ObservedObject var store: RunStore

    var body: some View {
        ArtifactListView(artifacts: run.artifacts, store: store)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

private struct WarningListView: View {
    let warnings: [String]

    var body: some View {
        Panel(title: L10n.t("Warnings", "Varování"), systemImage: "exclamationmark.triangle") {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(warnings, id: \.self) { warning in
                    Label(warning, systemImage: "exclamationmark.circle")
                        .foregroundStyle(.orange)
                }
            }
        }
    }
}

struct EmptyPanelLine: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.callout)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
    }
}

struct Panel<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(.primary)
            content
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.secondary.opacity(0.035))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct StatusBadge: View {
    let label: String
    let tint: Color

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(tint)
                .frame(width: 7, height: 7)
            Text(label)
                .font(.caption.weight(.medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(tint.opacity(0.12), in: Capsule())
        .foregroundStyle(tint)
        .badgePointerCursor()
    }
}
