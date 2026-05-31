import Foundation

public enum Host: String, Codable, CaseIterable, Sendable {
    case codex
    case claudeCode = "claude-code"
    case unknown
}

public enum RunStatus: String, Codable, CaseIterable, Sendable {
    case notStarted = "not_started"
    case planning
    case implementing
    case reviewing
    case verifying
    case blocked
    case paused
    case completed
    case failed
    case cancelled
    case unknown

    public init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = StatusNormalizer.runStatus(raw)
    }
}

public enum PhaseStatus: String, Codable, CaseIterable, Sendable {
    case notStarted = "not_started"
    case inProgress = "in_progress"
    case blocked
    case needsReview = "needs_review"
    case completed
    case skipped
    case failed
    case unknown

    public init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = StatusNormalizer.phaseStatus(raw)
    }
}

public enum AgentRole: String, Codable, CaseIterable, Sendable {
    case rootOrchestrator = "root-orchestrator"
    case planner
    case scout
    case planWriter = "plan-writer"
    case implementationLead = "implementation-lead"
    case sliceWorker = "slice-worker"
    case reviewer
    case unknown
}

public enum AgentStatus: String, Codable, CaseIterable, Sendable {
    case pending
    case running
    case blocked
    case done
    case failed
    case cancelled
    case unknown

    public init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = StatusNormalizer.agentStatus(raw)
    }
}

public enum Severity: String, Codable, CaseIterable, Sendable {
    case info
    case warning
    case error
    case critical
    case unknown

    public init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = Severity(rawValue: StatusNormalizer.key(raw)) ?? .unknown
    }
}

public enum ArtifactKind: String, Codable, CaseIterable, Sendable {
    case markdown
    case json
    case jsonl
    case source
    case test
    case log
    case schema
    case app
    case external
    case unknown
}

public enum EdgeRelation: String, Codable, CaseIterable, Sendable {
    case delegates
    case reviews
    case reportsTo = "reports_to"
    case blocks
    case unknown
}

public enum EventType: String, Codable, CaseIterable, Sendable {
    case runCreated = "run.created"
    case runStatusChanged = "run.status_changed"
    case runCompleted = "run.completed"
    case runFailed = "run.failed"
    case phaseStarted = "phase.started"
    case phaseStatusChanged = "phase.status_changed"
    case phaseCompleted = "phase.completed"
    case agentSpawned = "agent.spawned"
    case agentStatusChanged = "agent.status_changed"
    case agentReported = "agent.reported"
    case decisionRecorded = "decision.recorded"
    case blockerOpened = "blocker.opened"
    case blockerResolved = "blocker.resolved"
    case artifactCreated = "artifact.created"
    case artifactUpdated = "artifact.updated"
    case checkpointCreated = "checkpoint.created"
    case reviewFindingOpened = "review.finding_opened"
    case reviewFindingResolved = "review.finding_resolved"
    case validationStarted = "validation.started"
    case validationPassed = "validation.passed"
    case validationFailed = "validation.failed"
    case noteAdded = "note.added"
    case unknown
}

public struct OrchestratorRun: Codable, Identifiable, Equatable, Sendable {
    public var id: String { runId }
    public let schemaVersion: String
    public let runId: String
    public let workspaceRoot: String?
    public let host: Host
    public let createdAt: Date
    public let updatedAt: Date
    public let status: RunStatus
    public let currentPhaseId: String?
    public let preferredLanguage: String?
    public let agents: [Agent]
    public let edges: [AgentEdge]
    public let phases: [Phase]
    public let blockers: [Blocker]
    public let artifacts: [Artifact]
    public let checkpoints: [Checkpoint]
    public let metadata: [String: JSONValue]?

    public var flowContext: OrchestrationFlowContext {
        OrchestrationFlowContext(metadata: metadata)
    }
}

public struct OrchestrationFlowContext: Equatable, Sendable {
    public let originalRiskTier: String?
    public let activeRiskTier: String?
    public let flowMode: String?
    public let cycle: String?
    public let followUpOf: String?
    public let rootMode: String?

    public init(metadata: [String: JSONValue]?) {
        originalRiskTier = Self.string("originalRiskTier", in: metadata)
        activeRiskTier = Self.string("activeRiskTier", in: metadata)
        flowMode = Self.string("flowMode", in: metadata)
        cycle = Self.string("cycle", in: metadata)
        followUpOf = Self.string("followUpOf", in: metadata)
        rootMode = Self.string("rootMode", in: metadata)
    }

    public var hasDisplayableValue: Bool {
        activeRiskTier != nil || flowMode != nil || cycle != nil
    }

    public var displayRiskTier: String? {
        activeRiskTier.map(Self.displayLabel)
    }

    public var displayOriginalRiskTier: String? {
        originalRiskTier.map(Self.displayLabel)
    }

    public var displayFlowMode: String? {
        flowMode.map(Self.displayLabel)
    }

    public var displayCycle: String? {
        cycle.map(Self.displayLabel)
    }

    private static func string(_ key: String, in metadata: [String: JSONValue]?) -> String? {
        guard let value = metadata?[key]?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else {
            return nil
        }
        return value
    }

    private static func displayLabel(_ value: String) -> String {
        value
            .replacingOccurrences(of: "_", with: "-")
            .split(separator: "-")
            .map { part in
                guard let first = part.first else { return "" }
                return String(first).uppercased() + String(part.dropFirst())
            }
            .joined(separator: " ")
    }
}

public struct Agent: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let role: AgentRole
    public let status: AgentStatus
    public let displayName: String?
    public let summary: String?
    public let intent: String?
    public let plannedWork: [String]?
    public let doneDefinition: String?
    public let startedAt: Date?
    public let updatedAt: Date?
    public let metadata: [String: JSONValue]?

    public var workerKind: String? {
        metadata?["workerKind"]?.stringValue
    }
}

public struct AgentEdge: Codable, Identifiable, Equatable, Sendable {
    public var id: String { "\(fromAgentId)->\(toAgentId):\(relation.rawValue)" }
    public let fromAgentId: String
    public let toAgentId: String
    public let relation: EdgeRelation
    public let label: String?
}

public struct Phase: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let status: PhaseStatus
    public let ownerAgentId: String?
    public let startedAt: Date?
    public let completedAt: Date?
    public let summary: String?
    public let artifactRefs: [String]?
}

public struct Blocker: Codable, Identifiable, Equatable, Sendable {
    public enum Status: String, Codable, Sendable {
        case open
        case resolved
        case unknown
    }

    public let id: String
    public let title: String
    public let severity: Severity
    public let status: Status
    public let phaseId: String?
    public let ownerAgentId: String?
    public let createdAt: Date
    public let resolvedAt: Date?
    public let summary: String?
}

public struct Artifact: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let kind: ArtifactKind
    public let path: String
    public let title: String?
    public let phaseId: String?
    public let agentId: String?
    public let updatedAt: Date?

    public init(id: String, kind: ArtifactKind, path: String, title: String?, phaseId: String?, agentId: String?, updatedAt: Date?) {
        self.id = id
        self.kind = kind
        self.path = path
        self.title = title
        self.phaseId = phaseId
        self.agentId = agentId
        self.updatedAt = updatedAt
    }
}

public struct Checkpoint: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let timestamp: Date
    public let title: String
    public let severity: Severity
    public let phaseId: String?
    public let agentId: String?
    public let summary: String?
    public let artifactRefs: [String]?
}

public struct OrchestratorEvent: Codable, Identifiable, Equatable, Sendable {
    public var id: String { eventId }
    public let schemaVersion: String
    public let eventId: String
    public let runId: String
    public let timestamp: Date
    public let type: EventType
    public let actorAgentId: String
    public let phaseId: String?
    public let agentId: String?
    public let severity: Severity
    public let message: String
    public let data: [String: JSONValue]
    public let artifactRefs: [String]
}

public struct RunRecord: Identifiable, Equatable, Sendable {
    public var id: String { runId }
    public let runId: String
    public let directoryURL: URL
    public let state: OrchestratorRun?
    public let events: [OrchestratorEvent]
    public let markdownArtifacts: [Artifact]
    public let warnings: [String]

    public var hasStructuredState: Bool { state != nil }
    public var displayTitle: String { state?.runId ?? runId }
    public var host: Host { state?.host ?? .unknown }
    public var status: RunStatus { state?.status ?? .notStarted }
    public var updatedAt: Date? {
        state?.updatedAt ?? markdownArtifacts.compactMap(\.updatedAt).max()
    }
    public var currentPhase: Phase? {
        guard let state, let currentPhaseId = state.currentPhaseId else { return nil }
        return state.phases.first { $0.id == currentPhaseId }
    }
    public var artifacts: [Artifact] {
        if let state {
            return state.artifacts
        }
        return markdownArtifacts
    }
}

public struct AgentRelationship: Identifiable, Equatable, Sendable {
    public var id: String { "\(relation.rawValue):\(agent.id)" }
    public let agent: Agent
    public let relation: EdgeRelation
    public let label: String?
}

public struct AgentDetail: Equatable, Sendable {
    public let agent: Agent
    public let parents: [AgentRelationship]
    public let children: [AgentRelationship]
    public let relatedEvents: [OrchestratorEvent]
    public let relatedCheckpoints: [Checkpoint]
    public let relatedArtifacts: [Artifact]
    public let relatedBlockers: [Blocker]
    public let reviewEvents: [OrchestratorEvent]
    public let validationEvents: [OrchestratorEvent]
    public let lastUpdate: OrchestratorEvent?

    public init?(run: OrchestratorRun, events: [OrchestratorEvent], agentId: String) {
        guard let agent = run.agents.first(where: { $0.id == agentId }) else { return nil }

        let agentsById = Dictionary(uniqueKeysWithValues: run.agents.map { ($0.id, $0) })
        let parents = Self.relationships(
            edges: run.edges,
            agentsById: agentsById,
            agentId: agentId,
            direction: .parents
        )
        let children = Self.relationships(
            edges: run.edges,
            agentsById: agentsById,
            agentId: agentId,
            direction: .children
        )

        let relatedEvents = events
            .filter { $0.agentId == agentId || $0.actorAgentId == agentId }
            .sorted { $0.timestamp > $1.timestamp }
        let relatedCheckpoints = run.checkpoints
            .filter { $0.agentId == agentId }
            .sorted { $0.timestamp > $1.timestamp }
        let relatedBlockers = run.blockers
            .filter { $0.ownerAgentId == agentId }
            .sorted { $0.createdAt > $1.createdAt }

        let referencedArtifactIds = Set(
            relatedEvents.flatMap(\.artifactRefs) + relatedCheckpoints.flatMap { $0.artifactRefs ?? [] }
        )
        let relatedArtifacts = run.artifacts
            .filter { $0.agentId == agentId || referencedArtifactIds.contains($0.id) }
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
        let reviewEvents = relatedEvents.filter {
            $0.type == .reviewFindingOpened || $0.type == .reviewFindingResolved
        }
        let validationEvents = relatedEvents.filter {
            $0.type == .validationStarted || $0.type == .validationPassed || $0.type == .validationFailed
        }

        self.agent = agent
        self.parents = parents
        self.children = children
        self.relatedEvents = relatedEvents
        self.relatedCheckpoints = relatedCheckpoints
        self.relatedArtifacts = relatedArtifacts
        self.relatedBlockers = relatedBlockers
        self.reviewEvents = reviewEvents
        self.validationEvents = validationEvents
        self.lastUpdate = relatedEvents.first
    }

    private enum RelationshipDirection {
        case parents
        case children
    }

    private static func relationships(
        edges: [AgentEdge],
        agentsById: [String: Agent],
        agentId: String,
        direction: RelationshipDirection
    ) -> [AgentRelationship] {
        var seen = Set<String>()
        return edges.compactMap { edge -> AgentRelationship? in
            let relatedAgentId: String?
            switch (direction, edge.relation) {
            case (.parents, .delegates) where edge.toAgentId == agentId:
                relatedAgentId = edge.fromAgentId
            case (.parents, .reportsTo) where edge.fromAgentId == agentId:
                relatedAgentId = edge.toAgentId
            case (.children, .delegates) where edge.fromAgentId == agentId:
                relatedAgentId = edge.toAgentId
            case (.children, .reportsTo) where edge.toAgentId == agentId:
                relatedAgentId = edge.fromAgentId
            default:
                relatedAgentId = nil
            }

            guard let relatedAgentId,
                  let relatedAgent = agentsById[relatedAgentId],
                  seen.insert(relatedAgentId).inserted else {
                return nil
            }
            return AgentRelationship(agent: relatedAgent, relation: edge.relation, label: edge.label)
        }
        .sorted {
            ($0.agent.displayName ?? $0.agent.id)
                .localizedStandardCompare($1.agent.displayName ?? $1.agent.id) == .orderedAscending
        }
    }
}

public struct PhaseDetail: Equatable, Sendable {
    public let phase: Phase
    public let ownerAgent: Agent?
    public let relatedEvents: [OrchestratorEvent]
    public let relatedCheckpoints: [Checkpoint]
    public let relatedArtifacts: [Artifact]
    public let relatedBlockers: [Blocker]
    public let validationEvents: [OrchestratorEvent]

    public init?(run: OrchestratorRun, events: [OrchestratorEvent], phaseId: String) {
        guard let phase = run.phases.first(where: { $0.id == phaseId }) else { return nil }

        let relatedEvents = events
            .filter { $0.phaseId == phaseId }
            .sorted { $0.timestamp > $1.timestamp }
        let relatedCheckpoints = run.checkpoints
            .filter { $0.phaseId == phaseId }
            .sorted { $0.timestamp > $1.timestamp }
        let relatedBlockers = run.blockers
            .filter { $0.phaseId == phaseId }
            .sorted { $0.createdAt > $1.createdAt }

        let referencedArtifactIds = Set(
            (phase.artifactRefs ?? [])
                + relatedEvents.flatMap(\.artifactRefs)
                + relatedCheckpoints.flatMap { $0.artifactRefs ?? [] }
        )
        let relatedArtifacts = run.artifacts
            .filter { $0.phaseId == phaseId || referencedArtifactIds.contains($0.id) }
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
        let validationEvents = relatedEvents.filter {
            $0.type == .validationStarted || $0.type == .validationPassed || $0.type == .validationFailed
        }

        self.phase = phase
        self.ownerAgent = run.agents.first { $0.id == phase.ownerAgentId }
        self.relatedEvents = relatedEvents
        self.relatedCheckpoints = relatedCheckpoints
        self.relatedArtifacts = relatedArtifacts
        self.relatedBlockers = relatedBlockers
        self.validationEvents = validationEvents
    }
}
