import OrchestratorConsoleCore
import SwiftUI

struct TimelineView: View {
    let state: OrchestratorRun
    let events: [OrchestratorEvent]
    @State private var mode: LogMode = .important

    private var items: [LogItem] {
        let phasesById = Dictionary(uniqueKeysWithValues: state.phases.map { ($0.id, $0) })
        let agentsById = Dictionary(uniqueKeysWithValues: state.agents.map { ($0.id, $0) })
        let importantIds = Set(
            SignificantTimelineEvent.timeline(run: state, events: events)
                .filter { !$0.isTechnical }
                .map(\.id)
        )

        let eventItems = events.map { event in
            let id = "event-\(event.eventId)"
            return LogItem(
                id: id,
                timestamp: event.timestamp,
                severity: event.severity,
                kind: event.type.shortLabel,
                title: event.message,
                context: context(event: event, phasesById: phasesById, agentsById: agentsById),
                metadata: metadata(event: event, phasesById: phasesById, agentsById: agentsById),
                isImportant: importantIds.contains(id)
            )
        }

        let checkpointItems = state.checkpoints.map { checkpoint in
            let id = "checkpoint-\(checkpoint.id)"
            return LogItem(
                id: id,
                timestamp: checkpoint.timestamp,
                severity: checkpoint.severity,
                kind: L10n.t("Checkpoint", "Checkpoint"),
                title: checkpoint.summary?.isEmpty == false ? checkpoint.summary! : checkpoint.title,
                context: context(checkpoint: checkpoint, phasesById: phasesById, agentsById: agentsById),
                metadata: metadata(checkpoint: checkpoint, phasesById: phasesById, agentsById: agentsById),
                isImportant: importantIds.contains(id)
            )
        }

        return (eventItems + checkpointItems)
            .filter { mode == .all || $0.isImportant }
            .sorted { $0.timestamp > $1.timestamp }
    }

    var body: some View {
        Panel(title: L10n.t("Log", "Log"), systemImage: "clock") {
            VStack(alignment: .leading, spacing: 12) {
                Picker(L10n.t("Log mode", "Režim logu"), selection: $mode) {
                    ForEach(LogMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .frame(width: 260)

                if items.isEmpty {
                    EmptyPanelLine(text: L10n.t("No log items", "Žádné položky logu"))
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(items) { item in
                            LogItemRow(item: item)
                        }
                    }
                }
            }
        }
    }

    private func context(
        event: OrchestratorEvent,
        phasesById: [String: Phase],
        agentsById: [String: Agent]
    ) -> String {
        let phase = event.phaseId.flatMap { phasesById[$0]?.title ?? $0 }
        let actor = agentsById[event.actorAgentId]?.displayName ?? event.actorAgentId
        return [phase, actor].compactMap { $0 }.joined(separator: " / ")
    }

    private func context(
        checkpoint: Checkpoint,
        phasesById: [String: Phase],
        agentsById: [String: Agent]
    ) -> String {
        let phase = checkpoint.phaseId.flatMap { phasesById[$0]?.title ?? $0 }
        let agent = checkpoint.agentId.flatMap { agentsById[$0]?.displayName ?? $0 }
        return [phase, agent].compactMap { $0 }.joined(separator: " / ")
    }

    private func metadata(
        event: OrchestratorEvent,
        phasesById: [String: Phase],
        agentsById: [String: Agent]
    ) -> [(String, String)] {
        var rows = [
            (L10n.t("Event", "Událost"), event.eventId),
            (L10n.t("Type", "Typ"), event.type.rawValue),
            (L10n.t("Actor", "Aktér"), agentsById[event.actorAgentId]?.displayName ?? event.actorAgentId),
            (L10n.t("Time", "Čas"), ConsoleFormatters.local(event.timestamp))
        ]
        if let phaseId = event.phaseId {
            rows.append((L10n.t("Phase", "Fáze"), phasesById[phaseId]?.title ?? phaseId))
        }
        if let agentId = event.agentId {
            rows.append((L10n.t("Agent", "Agent"), agentsById[agentId]?.displayName ?? agentId))
        }
        if !event.artifactRefs.isEmpty {
            rows.append((L10n.t("Artifacts", "Artefakty"), event.artifactRefs.joined(separator: ", ")))
        }
        return rows
    }

    private func metadata(
        checkpoint: Checkpoint,
        phasesById: [String: Phase],
        agentsById: [String: Agent]
    ) -> [(String, String)] {
        var rows = [
            (L10n.t("Type", "Typ"), L10n.t("checkpoint", "checkpoint")),
            (L10n.t("Time", "Čas"), ConsoleFormatters.local(checkpoint.timestamp))
        ]
        if let phaseId = checkpoint.phaseId {
            rows.append((L10n.t("Phase", "Fáze"), phasesById[phaseId]?.title ?? phaseId))
        }
        if let agentId = checkpoint.agentId {
            rows.append((L10n.t("Agent", "Agent"), agentsById[agentId]?.displayName ?? agentId))
        }
        if let artifactRefs = checkpoint.artifactRefs, !artifactRefs.isEmpty {
            rows.append((L10n.t("Artifacts", "Artefakty"), artifactRefs.joined(separator: ", ")))
        }
        return rows
    }
}

private enum LogMode: String, CaseIterable, Identifiable {
    case important
    case all

    var id: String { rawValue }

    var title: String {
        switch self {
        case .important: return L10n.t("Important", "Důležité")
        case .all: return L10n.t("All", "Vše")
        }
    }
}

private struct LogItem: Identifiable {
    let id: String
    let timestamp: Date
    let severity: Severity
    let kind: String
    let title: String
    let context: String
    let metadata: [(String, String)]
    let isImportant: Bool
}

private struct LogItemRow: View {
    let item: LogItem
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.default) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(item.severity.tint)
                        .frame(width: 7, height: 7)
                        .padding(.top, 6)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text(OrchestratorCopy.text(item.title))
                                .font(.callout.weight(.medium))
                                .lineLimit(2)
                            Spacer()
                            Text(ConsoleFormatters.relative(item.timestamp))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        HStack(spacing: 8) {
                            Text(item.kind)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(item.severity.tint)
                            if !item.context.isEmpty {
                                Text(item.context)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(item.metadata, id: \.0) { row in
                        HStack(alignment: .top, spacing: 10) {
                            Text(row.0)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 72, alignment: .leading)
                            Text(row.1)
                                .font(.caption)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.leading, 19)
            }
        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Divider().opacity(0.45)
        }
    }
}

private extension EventType {
    var shortLabel: String {
        switch self {
        case .runCreated: return L10n.t("Run", "Běh")
        case .runStatusChanged: return L10n.t("Status", "Stav")
        case .runCompleted: return L10n.t("Done", "Hotovo")
        case .runFailed: return L10n.t("Failed", "Selhalo")
        case .phaseStarted: return L10n.t("Phase", "Fáze")
        case .phaseStatusChanged: return L10n.t("Phase", "Fáze")
        case .phaseCompleted: return L10n.t("Phase done", "Fáze hotová")
        case .agentSpawned: return L10n.t("Agent", "Agent")
        case .agentStatusChanged: return L10n.t("Agent", "Agent")
        case .agentReported: return L10n.t("Agent update", "Update agenta")
        case .decisionRecorded: return L10n.t("Decision", "Rozhodnutí")
        case .blockerOpened: return L10n.t("Blocker", "Bloker")
        case .blockerResolved: return L10n.t("Resolved", "Vyřešeno")
        case .artifactCreated: return L10n.t("Artifact", "Artefakt")
        case .artifactUpdated: return L10n.t("Artifact", "Artefakt")
        case .checkpointCreated: return L10n.t("Checkpoint", "Checkpoint")
        case .reviewFindingOpened: return L10n.t("Review", "Review")
        case .reviewFindingResolved: return L10n.t("Review", "Review")
        case .validationStarted: return L10n.t("Validation", "Validace")
        case .validationPassed: return L10n.t("Validation", "Validace")
        case .validationFailed: return L10n.t("Validation", "Validace")
        case .noteAdded: return L10n.t("Note", "Poznámka")
        case .unknown: return L10n.t("Event", "Událost")
        }
    }
}
