import OrchestratorConsoleCore
import SwiftUI

struct AgentGraphView: View {
    let state: OrchestratorRun
    let events: [OrchestratorEvent]
    @ObservedObject var store: RunStore

    private var rows: [AgentSummaryRow] {
        AgentSummaryRow.rows(run: state, events: events)
    }

    private var attentionRows: [AgentSummaryRow] { rows.filter(\.isAttention) }
    private var activeRows: [AgentSummaryRow] { rows.filter { !$0.isAttention && $0.agent.status == .running } }
    private var waitingRows: [AgentSummaryRow] { rows.filter { $0.agent.status == .pending } }
    private var doneRows: [AgentSummaryRow] { rows.filter { $0.agent.status == .done } }

    var body: some View {
        Panel(title: L10n.t("Agents", "Agenti"), systemImage: "person.3.sequence") {
            if rows.isEmpty {
                EmptyPanelLine(text: L10n.t("No agents", "Žádní agenti"))
            } else {
                VStack(alignment: .leading, spacing: 14) {
                    if !attentionRows.isEmpty {
                        AgentGroupSection(title: L10n.t("Needs attention", "Vyžaduje pozornost"), rows: attentionRows, tint: .orange)
                    }

                    if !activeRows.isEmpty {
                        AgentGroupSection(title: L10n.t("Active", "Aktivní"), rows: activeRows, tint: .blue)
                    }

                    if !waitingRows.isEmpty {
                        AgentGroupSection(title: L10n.t("Waiting", "Čeká"), rows: waitingRows, tint: .secondary)
                    }

                    if doneRows.isEmpty == false {
                        AgentDoneSummary(rows: doneRows)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

private struct AgentGroupSection: View {
    let title: String
    let rows: [AgentSummaryRow]
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Circle()
                    .fill(tint)
                    .frame(width: 7, height: 7)
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("\(rows.count)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 6)

            ForEach(rows) { row in
                AgentTableRow(row: row)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

private struct AgentTableRow: View {
    let row: AgentSummaryRow

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: row.agent.role.systemImage)
                    .foregroundStyle(row.agent.status.tint)
                    .frame(width: 16)
                    .padding(.top, 2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.name)
                        .font(.callout.weight(.medium))
                        .lineLimit(1)
                    Text(row.agent.role.label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(width: 220, alignment: .leading)

            Text(OrchestratorCopy.text(row.currentTask))
                .font(.callout)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(row.agent.status.label)
                .font(.caption.weight(.medium))
                .foregroundStyle(row.agent.status.tint)
                .frame(width: 90, alignment: .leading)

            Text(ConsoleFormatters.relative(row.updatedAt))
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .trailing)
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 10)
        .overlay(alignment: .bottom) {
            Divider().opacity(0.45)
        }
    }
}

private struct AgentDoneSummary: View {
    let rows: [AgentSummaryRow]

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Circle()
                .fill(Color.green)
                .frame(width: 7, height: 7)
            Text(L10n.t("Done", "Hotovo"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(L10n.t("\(rows.count) completed agent\(rows.count == 1 ? "" : "s")", "\(rows.count) dokončených agentů"))
                .font(.callout)
            Spacer()
            if let latest = rows.map(\.updatedAt).max() {
                Text(L10n.t("latest \(ConsoleFormatters.relative(latest))", "poslední \(ConsoleFormatters.relative(latest))"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .background(Color.green.opacity(0.06), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}

private struct DetailEmptyLine: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

extension AgentRole {
    var systemImage: String {
        switch self {
        case .rootOrchestrator: return "command"
        case .planner, .planWriter: return "doc.text"
        case .scout: return "magnifyingglass"
        case .implementationLead: return "hammer"
        case .sliceWorker: return "square.stack.3d.up"
        case .reviewer: return "checkmark.seal"
        case .unknown: return "questionmark.circle"
        }
    }
}
