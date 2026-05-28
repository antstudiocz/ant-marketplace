import Foundation

public enum StatusNormalizer {
    public static func key(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: " ", with: "_")
    }

    public static func runStatus(_ value: String) -> RunStatus {
        switch key(value) {
        case "not_started", "pending":
            return .notStarted
        case "planning":
            return .planning
        case "implementing", "implementation", "active":
            return .implementing
        case "reviewing", "needs_review", "review":
            return .reviewing
        case "verifying", "verification":
            return .verifying
        case "blocked":
            return .blocked
        case "paused":
            return .paused
        case "completed", "complete", "done", "closed":
            return .completed
        case "failed", "error":
            return .failed
        case "cancelled", "canceled":
            return .cancelled
        default:
            return .unknown
        }
    }

    public static func phaseStatus(_ value: String) -> PhaseStatus {
        switch key(value) {
        case "not_started", "pending":
            return .notStarted
        case "in_progress", "active", "running":
            return .inProgress
        case "blocked":
            return .blocked
        case "needs_review", "reviewing", "ready_for_review":
            return .needsReview
        case "completed", "complete", "done", "closed", "ready_for_next_phase":
            return .completed
        case "skipped":
            return .skipped
        case "failed", "error":
            return .failed
        default:
            return .unknown
        }
    }

    public static func agentStatus(_ value: String) -> AgentStatus {
        switch key(value) {
        case "pending", "not_started":
            return .pending
        case "running", "active", "in_progress":
            return .running
        case "blocked":
            return .blocked
        case "done", "completed", "complete", "closed", "final":
            return .done
        case "failed", "error":
            return .failed
        case "cancelled", "canceled":
            return .cancelled
        default:
            return .unknown
        }
    }
}
