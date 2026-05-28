import Foundation

public struct CurrentWorkSummary: Equatable, Sendable {
    public let phase: Phase?
    public let activeAgent: Agent?
    public let latestCheckpoint: Checkpoint?
    public let latestEvent: OrchestratorEvent?
    public let nextStep: String
    public let needsUserDecision: Bool
    public let openBlockers: [Blocker]

    public init(run: OrchestratorRun, events: [OrchestratorEvent]) {
        let agentsById = Dictionary(uniqueKeysWithValues: run.agents.map { ($0.id, $0) })
        let currentPhase = run.currentPhaseId.flatMap { phaseId in
            run.phases.first { $0.id == phaseId }
        } ?? run.phases.first { $0.status == .inProgress || $0.status == .needsReview || $0.status == .blocked }

        let runningAgents = run.agents
            .filter { $0.status == .running || $0.status == .blocked || $0.status == .pending }
            .sorted { lhs, rhs in
                let left = Self.agentSortKey(lhs)
                let right = Self.agentSortKey(rhs)
                if left.statusRank == right.statusRank {
                    return left.updatedAt > right.updatedAt
                }
                return left.statusRank < right.statusRank
            }
        let ownerAgent = currentPhase?.ownerAgentId.flatMap { agentsById[$0] }
        let selectedActiveAgent = ownerAgent.flatMap { agent in
            runningAgents.contains(where: { $0.id == agent.id }) ? agent : nil
        } ?? runningAgents.first

        let latestCheckpoint = run.checkpoints.max { $0.timestamp < $1.timestamp }
        let latestEvent = events.max { $0.timestamp < $1.timestamp }
        let openBlockers = run.blockers
            .filter { $0.status == .open }
            .sorted { lhs, rhs in
                if lhs.severity.importanceRank == rhs.severity.importanceRank {
                    return lhs.createdAt > rhs.createdAt
                }
                return lhs.severity.importanceRank > rhs.severity.importanceRank
            }

        self.phase = currentPhase
        self.activeAgent = selectedActiveAgent
        self.latestCheckpoint = latestCheckpoint
        self.latestEvent = latestEvent
        self.openBlockers = openBlockers
        self.needsUserDecision = Self.detectUserDecisionNeed(run: run, events: events, openBlockers: openBlockers)
        self.nextStep = Self.nextStep(
            run: run,
            phase: currentPhase,
            activeAgent: selectedActiveAgent,
            latestEvent: latestEvent,
            openBlockers: openBlockers,
            needsUserDecision: needsUserDecision
        )
    }

    private static func agentSortKey(_ agent: Agent) -> (statusRank: Int, updatedAt: Date) {
        let statusRank: Int
        switch agent.status {
        case .blocked: statusRank = 0
        case .running: statusRank = 1
        case .pending: statusRank = 2
        case .failed: statusRank = 3
        case .done: statusRank = 4
        case .cancelled, .unknown: statusRank = 5
        }
        return (statusRank, agent.updatedAt ?? agent.startedAt ?? .distantPast)
    }

    private static func detectUserDecisionNeed(
        run: OrchestratorRun,
        events: [OrchestratorEvent],
        openBlockers: [Blocker]
    ) -> Bool {
        if run.status == .paused,
           events.suffix(10).contains(where: { containsDecisionText($0.message) || $0.data.contains(where: { containsDecisionText($0.key) }) }) {
            return true
        }

        if openBlockers.contains(where: { blocker in
            containsDecisionText(blocker.title) || containsDecisionText(blocker.summary)
        }) {
            return true
        }

        return events.suffix(20).contains { event in
            if event.type == .decisionRecorded {
                return false
            }
            if containsDecisionText(event.message) {
                return true
            }
            return event.data.contains { key, value in
                containsDecisionText(key) || value.boolValue == true && containsDecisionText(key)
            }
        }
    }

    private static func containsDecisionText(_ value: String?) -> Bool {
        guard let value else { return false }
        let lowercased = value.lowercased()
        return lowercased.contains("decision")
            || lowercased.contains("approval")
            || lowercased.contains("needs user")
            || lowercased.contains("user input")
            || lowercased.contains("waiting on user")
            || lowercased.contains("rozhodnutí")
            || lowercased.contains("schválení")
    }

    private static func nextStep(
        run: OrchestratorRun,
        phase: Phase?,
        activeAgent: Agent?,
        latestEvent: OrchestratorEvent?,
        openBlockers: [Blocker],
        needsUserDecision: Bool
    ) -> String {
        if needsUserDecision {
            return "User decision is needed before the run can proceed."
        }
        if let blocker = openBlockers.first {
            return "Resolve blocker: \(blocker.title)"
        }
        if let activeAgent {
            return "\(activeAgent.displayName ?? activeAgent.id) is expected to report the next checkpoint."
        }
        if let phase, phase.status == .needsReview {
            return "Review the current phase evidence."
        }
        if let latestEvent, latestEvent.type == .validationPassed {
            return "Validation passed; review readiness and delivery evidence."
        }
        if run.status == .completed {
            return "Run is completed; review final evidence or artifacts."
        }
        return "Waiting for the next structured event or checkpoint."
    }
}

public struct RunHealthSummary: Equatable, Sendable {
    public let runningAgents: Int
    public let blockedAgents: Int
    public let completedAgents: Int
    public let openBlockers: Int
    public let failedValidations: Int
    public let passedValidations: Int
    public let openReviewFindings: Int
    public let resolvedReviewFindings: Int
    public let missingEvidence: [String]
    public let readinessLabel: String

    public init(run: OrchestratorRun, events: [OrchestratorEvent]) {
        runningAgents = run.agents.filter { $0.status == .running || $0.status == .pending }.count
        blockedAgents = run.agents.filter { $0.status == .blocked || $0.status == .failed }.count
        completedAgents = run.agents.filter { $0.status == .done }.count
        openBlockers = run.blockers.filter { $0.status == .open }.count
        failedValidations = events.filter { $0.type == .validationFailed }.count
        passedValidations = events.filter { $0.type == .validationPassed }.count
        openReviewFindings = max(
            0,
            events.filter { $0.type == .reviewFindingOpened }.count
                - events.filter { $0.type == .reviewFindingResolved }.count
        )
        resolvedReviewFindings = events.filter { $0.type == .reviewFindingResolved }.count

        var missing: [String] = []
        if run.checkpoints.isEmpty {
            missing.append("No checkpoints recorded")
        }
        if passedValidations == 0 {
            missing.append("No passing validation event")
        }
        if !run.artifacts.contains(where: { $0.kind == .markdown || $0.kind == .json || $0.kind == .jsonl }) {
            missing.append("No readable evidence artifact")
        }
        if run.status != .completed && runningAgents == 0 && openBlockers == 0 {
            missing.append("No active owner")
        }
        missingEvidence = missing

        if openBlockers > 0 || blockedAgents > 0 || failedValidations > 0 {
            readinessLabel = "Blocked"
        } else if openReviewFindings > 0 {
            readinessLabel = "Review needed"
        } else if missingEvidence.isEmpty && (run.status == .completed || passedValidations > 0) {
            readinessLabel = "Ready"
        } else {
            readinessLabel = "Needs evidence"
        }
    }
}

public struct ProgressFact: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let detail: String?
    public let severity: Severity
    public let timestamp: Date?

    public init(id: String, title: String, detail: String?, severity: Severity, timestamp: Date?) {
        self.id = id
        self.title = title
        self.detail = detail
        self.severity = severity
        self.timestamp = timestamp
    }
}

public struct RunProgressFacts: Equatable, Sendable {
    public let currentWork: CurrentWorkSummary
    public let latestValidation: ProgressFact?
    public let latestReviewFinding: ProgressFact?
    public let decisionFacts: [ProgressFact]
    public let blockerFacts: [ProgressFact]
    public let validationFacts: [ProgressFact]
    public let reviewFacts: [ProgressFact]
    public let relevantArtifacts: [Artifact]

    public init(run: OrchestratorRun, events: [OrchestratorEvent]) {
        let currentWork = CurrentWorkSummary(run: run, events: events)
        let sortedEvents = events.sorted { $0.timestamp > $1.timestamp }
        let validationEvents = sortedEvents.filter { $0.type.isValidationEvent }
        let reviewEvents = sortedEvents.filter { $0.type.isReviewEvent }
        let decisionEvents = sortedEvents.filter { event in
            event.type == .decisionRecorded
                || event.type != .decisionRecorded && Self.containsDecisionText(event.message)
                || event.data.contains { key, value in
                    Self.containsDecisionText(key) || value.boolValue == true && Self.containsDecisionText(key)
                }
        }

        var decisionFacts = decisionEvents.prefix(3).map(Self.fact(for:))
        if currentWork.needsUserDecision,
           !decisionFacts.contains(where: { $0.title.localizedCaseInsensitiveContains("decision") }) {
            decisionFacts.insert(
                ProgressFact(
                    id: "decision-needed",
                    title: "User decision needed",
                    detail: currentWork.nextStep,
                    severity: .warning,
                    timestamp: sortedEvents.first?.timestamp
                ),
                at: 0
            )
        }

        let phaseArtifactRefs = currentWork.phase?.artifactRefs ?? []
        let checkpointArtifactRefs = currentWork.latestCheckpoint?.artifactRefs ?? []
        let currentPhaseArtifactIds = Set(phaseArtifactRefs + checkpointArtifactRefs)
        let relevantArtifacts = run.artifacts
            .filter { artifact in
                artifact.phaseId == currentWork.phase?.id
                    || artifact.agentId == currentWork.activeAgent?.id
                    || currentPhaseArtifactIds.contains(artifact.id)
            }
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

        self.currentWork = currentWork
        self.latestValidation = validationEvents.first.map(Self.fact(for:))
        self.latestReviewFinding = reviewEvents.first.map(Self.fact(for:))
        self.decisionFacts = Array(decisionFacts.prefix(3))
        self.blockerFacts = currentWork.openBlockers.prefix(3).map(Self.fact(for:))
        self.validationFacts = validationEvents.prefix(3).map(Self.fact(for:))
        self.reviewFacts = reviewEvents.prefix(3).map(Self.fact(for:))
        self.relevantArtifacts = Array(relevantArtifacts.prefix(4))
    }

    private static func fact(for event: OrchestratorEvent) -> ProgressFact {
        ProgressFact(
            id: event.eventId,
            title: event.message,
            detail: nil,
            severity: event.severity,
            timestamp: event.timestamp
        )
    }

    private static func fact(for blocker: Blocker) -> ProgressFact {
        ProgressFact(
            id: blocker.id,
            title: blocker.title,
            detail: blocker.summary,
            severity: blocker.severity,
            timestamp: blocker.createdAt
        )
    }

    private static func containsDecisionText(_ value: String?) -> Bool {
        guard let value else { return false }
        let lowercased = value.lowercased()
        return lowercased.contains("decision")
            || lowercased.contains("approval")
            || lowercased.contains("needs user")
            || lowercased.contains("user input")
            || lowercased.contains("waiting on user")
            || lowercased.contains("rozhodnutí")
            || lowercased.contains("schválení")
    }
}

public struct CommandCenterSummary: Equatable, Sendable {
    public let verdict: String
    public let outcome: String
    public let nextAction: String
    public let riskSummary: String
    public let decisionSummary: String
    public let severity: Severity
    public let currentMilestone: MilestoneFact?
    public let keyFacts: [ProgressFact]

    public init(run: OrchestratorRun, events: [OrchestratorEvent]) {
        let currentWork = CurrentWorkSummary(run: run, events: events)
        let health = RunHealthSummary(run: run, events: events)
        let progress = RunProgressFacts(run: run, events: events)
        let milestones = MilestoneFact.milestones(run: run, events: events)
        let currentMilestone = milestones.first { $0.isCurrent }
            ?? milestones.first { $0.status == .blocked || $0.status == .needsReview || $0.status == .inProgress }
            ?? milestones.last { $0.status == .completed }

        self.currentMilestone = currentMilestone
        self.severity = Self.severity(run: run, health: health, currentWork: currentWork)
        self.verdict = Self.verdict(run: run, health: health, currentWork: currentWork)
        self.outcome = Self.outcome(run: run, health: health, currentMilestone: currentMilestone)
        self.nextAction = Self.nextAction(run: run, currentWork: currentWork, health: health)
        self.riskSummary = Self.riskSummary(run: run, health: health, currentWork: currentWork)
        self.decisionSummary = Self.decisionSummary(currentWork: currentWork, progress: progress)
        self.keyFacts = Self.keyFacts(run: run, health: health, progress: progress, milestones: milestones)
    }

    private static func severity(run: OrchestratorRun, health: RunHealthSummary, currentWork: CurrentWorkSummary) -> Severity {
        if run.status == .failed || health.failedValidations > 0 {
            return .error
        }
        if run.status == .blocked || health.openBlockers > 0 || currentWork.needsUserDecision {
            return .warning
        }
        if health.openReviewFindings > 0 || !health.missingEvidence.isEmpty {
            return .warning
        }
        return .info
    }

    private static func verdict(run: OrchestratorRun, health: RunHealthSummary, currentWork: CurrentWorkSummary) -> String {
        if currentWork.needsUserDecision {
            return "Decision needed"
        }
        if let blocker = currentWork.openBlockers.first {
            return "Blocked: \(blocker.title)"
        }
        if run.status == .completed {
            return health.openReviewFindings > 0 || health.failedValidations > 0 ? "Completed with follow-up" : "Completed"
        }
        if run.status == .failed {
            return "Failed"
        }
        if run.status == .reviewing || health.openReviewFindings > 0 {
            return "Review in progress"
        }
        if run.status == .verifying {
            return "Validation in progress"
        }
        if run.status == .implementing {
            return "Implementation in progress"
        }
        return run.status == .paused ? "Paused" : run.status.rawValue.replacingOccurrences(of: "_", with: " ").capitalized
    }

    private static func outcome(run: OrchestratorRun, health: RunHealthSummary, currentMilestone: MilestoneFact?) -> String {
        if run.status == .completed {
            if health.missingEvidence.isEmpty {
                return "Run finished and required evidence is present."
            }
            return "Run finished; review the remaining evidence gaps."
        }
        if let currentMilestone {
            return "\(currentMilestone.title) is \(currentMilestone.statusLabel.lowercased())."
        }
        return "No structured milestone is active."
    }

    private static func nextAction(run: OrchestratorRun, currentWork: CurrentWorkSummary, health: RunHealthSummary) -> String {
        if currentWork.needsUserDecision {
            return "Resolve the pending decision so implementation can continue."
        }
        if let blocker = currentWork.openBlockers.first {
            return "Resolve blocker: \(blocker.title)"
        }
        if health.failedValidations > 0 {
            return "Fix the latest validation failure and rerun verification."
        }
        if health.openReviewFindings > 0 {
            return "Resolve review findings and re-check the evidence."
        }
        if run.status == .completed {
            return "Review final evidence, decisions, and delivery handoff."
        }
        return currentWork.nextStep
    }

    private static func riskSummary(run: OrchestratorRun, health: RunHealthSummary, currentWork: CurrentWorkSummary) -> String {
        if let blocker = currentWork.openBlockers.first {
            return "\(currentWork.openBlockers.count) open blocker\(currentWork.openBlockers.count == 1 ? "" : "s"); highest: \(blocker.title)."
        }
        if health.failedValidations > 0 {
            return "\(health.failedValidations) validation failure\(health.failedValidations == 1 ? "" : "s") recorded."
        }
        if health.openReviewFindings > 0 {
            return "\(health.openReviewFindings) open review finding\(health.openReviewFindings == 1 ? "" : "s")."
        }
        if !health.missingEvidence.isEmpty, run.status != .notStarted {
            return "Evidence gaps: \(health.missingEvidence.prefix(2).joined(separator: ", "))."
        }
        return "No open blocker, failed validation, or unresolved review signal."
    }

    private static func decisionSummary(currentWork: CurrentWorkSummary, progress: RunProgressFacts) -> String {
        if currentWork.needsUserDecision {
            return "User decision is blocking progress."
        }
        if let latestDecision = progress.decisionFacts.first {
            return latestDecision.title
        }
        return "No open decision signal."
    }

    private static func keyFacts(
        run: OrchestratorRun,
        health: RunHealthSummary,
        progress: RunProgressFacts,
        milestones: [MilestoneFact]
    ) -> [ProgressFact] {
        [
            ProgressFact(
                id: "status",
                title: "Status: \(run.status.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)",
                detail: run.currentPhaseId,
                severity: .info,
                timestamp: run.updatedAt
            ),
            ProgressFact(
                id: "milestones",
                title: "\(milestones.filter { $0.status == .completed }.count)/\(milestones.count) milestones complete",
                detail: milestones.first(where: { $0.isCurrent })?.title,
                severity: .info,
                timestamp: nil
            ),
            ProgressFact(
                id: "validation",
                title: progress.latestValidation?.title ?? "No validation result yet",
                detail: nil,
                severity: progress.latestValidation?.severity ?? (health.failedValidations > 0 ? .error : .info),
                timestamp: progress.latestValidation?.timestamp
            ),
            ProgressFact(
                id: "review",
                title: health.openReviewFindings == 0 ? "No open review finding" : "\(health.openReviewFindings) open review finding\(health.openReviewFindings == 1 ? "" : "s")",
                detail: progress.latestReviewFinding?.title,
                severity: health.openReviewFindings == 0 ? .info : .warning,
                timestamp: progress.latestReviewFinding?.timestamp
            )
        ]
    }
}

public struct DecisionFact: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let rationale: String?
    public let impact: String?
    public let status: String
    public let severity: Severity
    public let timestamp: Date?

    public static func decisions(run: OrchestratorRun, events: [OrchestratorEvent]) -> [DecisionFact] {
        let currentWork = CurrentWorkSummary(run: run, events: events)
        var decisions = events
            .filter { event in
                event.type == .decisionRecorded
                    || containsDecisionText(event.message)
                    || event.data.contains { key, _ in containsDecisionText(key) }
            }
            .sorted { $0.timestamp > $1.timestamp }
            .map { event in
                DecisionFact(
                    id: event.eventId,
                    title: event.message,
                    rationale: event.data["rationale"]?.displayString ?? event.data["why"]?.displayString,
                    impact: event.data["impact"]?.displayString ?? event.data["scope"]?.displayString,
                    status: event.type == .decisionRecorded ? "Recorded" : "Signal",
                    severity: event.severity,
                    timestamp: event.timestamp
                )
            }

        if currentWork.needsUserDecision,
           !decisions.contains(where: { $0.id == "decision-needed" }) {
            decisions.insert(
                DecisionFact(
                    id: "decision-needed",
                    title: "User decision needed",
                    rationale: currentWork.nextStep,
                    impact: "Run cannot proceed until this is resolved.",
                    status: "Open",
                    severity: .warning,
                    timestamp: events.map(\.timestamp).max()
                ),
                at: 0
            )
        }

        return Array(decisions.prefix(8))
    }

    private static func containsDecisionText(_ value: String?) -> Bool {
        guard let value else { return false }
        let lowercased = value.lowercased()
        return lowercased.contains("decision")
            || lowercased.contains("approval")
            || lowercased.contains("approved")
            || lowercased.contains("user input")
            || lowercased.contains("waiting on user")
            || lowercased.contains("rozhodnutí")
            || lowercased.contains("schválení")
    }
}

public struct MilestoneFact: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let status: PhaseStatus
    public let statusLabel: String
    public let summary: String?
    public let ownerName: String?
    public let latestSignal: String?
    public let evidenceCount: Int
    public let riskCount: Int
    public let isCurrent: Bool
    public let isTechnical: Bool

    public static func milestones(run: OrchestratorRun, events: [OrchestratorEvent]) -> [MilestoneFact] {
        let agentsById = Dictionary(uniqueKeysWithValues: run.agents.map { ($0.id, $0) })
        let checkpointsByPhase = Dictionary(grouping: run.checkpoints) { $0.phaseId ?? "__run__" }
        let eventsByPhase = Dictionary(grouping: events) { $0.phaseId ?? "__run__" }

        return run.phases.map { phase in
            let latestCheckpoint = checkpointsByPhase[phase.id]?.max { $0.timestamp < $1.timestamp }
            let latestEvent = eventsByPhase[phase.id]?.max { $0.timestamp < $1.timestamp }
            let artifactIds = Set(
                (phase.artifactRefs ?? [])
                    + (checkpointsByPhase[phase.id] ?? []).flatMap { $0.artifactRefs ?? [] }
                    + (eventsByPhase[phase.id] ?? []).flatMap(\.artifactRefs)
            )
            let evidenceCount = run.artifacts.filter { $0.phaseId == phase.id || artifactIds.contains($0.id) }.count
            let riskCount = run.blockers.filter { $0.phaseId == phase.id && $0.status == .open }.count
                + (eventsByPhase[phase.id] ?? []).filter { $0.type == .validationFailed || $0.type == .reviewFindingOpened }.count

            return MilestoneFact(
                id: phase.id,
                title: phase.title,
                status: phase.status,
                statusLabel: Self.statusLabel(for: phase.status),
                summary: phase.summary,
                ownerName: phase.ownerAgentId.flatMap { agentsById[$0]?.displayName ?? $0 },
                latestSignal: latestCheckpoint?.summary ?? latestCheckpoint?.title ?? latestEvent?.message,
                evidenceCount: evidenceCount,
                riskCount: riskCount,
                isCurrent: phase.id == run.currentPhaseId,
                isTechnical: Self.isTechnicalPhase(phase)
            )
        }
    }

    private static func statusLabel(for status: PhaseStatus) -> String {
        switch status {
        case .notStarted: return "Not started"
        case .inProgress: return "In progress"
        case .blocked: return "Blocked"
        case .needsReview: return "Needs review"
        case .completed: return "Completed"
        case .skipped: return "Skipped"
        case .failed: return "Failed"
        case .unknown: return "Unknown"
        }
    }

    private static func isTechnicalPhase(_ phase: Phase) -> Bool {
        if phase.status == .blocked || phase.status == .failed || phase.status == .needsReview {
            return false
        }
        let text = "\(phase.id) \(phase.title) \(phase.summary ?? "")".lowercased()
        let technicalMarkers = [
            "checkpoint",
            "polish",
            "graph",
            "status ui",
            "raw viewer",
            "internal event",
            "metadata",
            "debug"
        ]
        return technicalMarkers.contains { text.contains($0) }
    }
}

public enum EvidenceCategory: String, CaseIterable, Identifiable, Sendable {
    case decisionsPlan = "Decisions / Plan"
    case review = "Review"
    case verification = "Verification"
    case contractsSchemas = "Contracts / Schemas"
    case appSource = "App / Source"

    public var id: String { rawValue }
}

public struct EvidenceGroup: Identifiable, Equatable, Sendable {
    public var id: EvidenceCategory { category }
    public let category: EvidenceCategory
    public let artifacts: [Artifact]

    public static func groups(for artifacts: [Artifact]) -> [EvidenceGroup] {
        let grouped = Dictionary(grouping: artifacts) { artifact in
            category(for: artifact)
        }
        return EvidenceCategory.allCases.map { category in
            EvidenceGroup(
                category: category,
                artifacts: (grouped[category] ?? []).sorted(by: artifactSort)
            )
        }
        .filter { !$0.artifacts.isEmpty }
    }

    private static func category(for artifact: Artifact) -> EvidenceCategory {
        let text = "\(artifact.path) \(artifact.title ?? "")".lowercased()
        if text.contains("decision") || text.contains("decisions") || text.contains("plan") || text.contains("planning") || text.contains("handoff") {
            return .decisionsPlan
        }
        if text.contains("review") || text.contains("finding") {
            return .review
        }
        if text.contains("validation") || text.contains("verification") || text.contains("verify") || text.contains("test") || text.contains("evidence") {
            return .verification
        }
        if artifact.kind == .schema || text.contains("schema") || text.contains("contract") || text.contains("openapi") || text.contains("graphql") {
            return .contractsSchemas
        }
        return .appSource
    }

    private static func artifactSort(lhs: Artifact, rhs: Artifact) -> Bool {
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

public struct SignificantTimelineEvent: Identifiable, Equatable, Sendable {
    public let id: String
    public let timestamp: Date
    public let severity: Severity
    public let category: TimelineCategory
    public let badge: String
    public let title: String
    public let phaseId: String?
    public let artifactRefs: [String]
    public let isTechnical: Bool

    public static func timeline(run: OrchestratorRun, events: [OrchestratorEvent]) -> [SignificantTimelineEvent] {
        let eventItems = events.map { event in
            SignificantTimelineEvent(
                id: "event-\(event.eventId)",
                timestamp: event.timestamp,
                severity: event.severity,
                category: event.type.timelineCategory,
                badge: event.type.rawValue,
                title: event.message,
                phaseId: event.phaseId,
                artifactRefs: event.artifactRefs,
                isTechnical: !Self.isBusinessSignificant(event)
            )
        }

        let checkpointItems = run.checkpoints.map { checkpoint in
            SignificantTimelineEvent(
                id: "checkpoint-\(checkpoint.id)",
                timestamp: checkpoint.timestamp,
                severity: checkpoint.severity,
                category: .checkpoints,
                badge: "checkpoint",
                title: checkpoint.summary?.isEmpty == false ? checkpoint.summary! : checkpoint.title,
                phaseId: checkpoint.phaseId,
                artifactRefs: checkpoint.artifactRefs ?? [],
                isTechnical: !Self.isBusinessSignificant(checkpoint)
            )
        }

        return (eventItems + checkpointItems).sorted { $0.timestamp > $1.timestamp }
    }

    private static func isBusinessSignificant(_ event: OrchestratorEvent) -> Bool {
        if event.severity.importanceRank >= Severity.warning.importanceRank {
            return true
        }
        switch event.type {
        case .decisionRecorded, .blockerOpened, .blockerResolved, .reviewFindingOpened, .reviewFindingResolved, .validationPassed, .validationFailed, .runCompleted, .runFailed:
            return true
        case .phaseStarted, .phaseCompleted:
            return containsMilestoneText(event.message)
        case .runStatusChanged:
            return containsMilestoneText(event.message)
        case .validationStarted, .runCreated, .phaseStatusChanged, .agentSpawned, .agentStatusChanged, .agentReported, .artifactCreated, .artifactUpdated, .checkpointCreated, .noteAdded, .unknown:
            return false
        }
    }

    private static func isBusinessSignificant(_ checkpoint: Checkpoint) -> Bool {
        if checkpoint.severity.importanceRank >= Severity.warning.importanceRank {
            return true
        }
        return containsMilestoneText("\(checkpoint.title) \(checkpoint.summary ?? "")")
    }

    private static func containsMilestoneText(_ value: String) -> Bool {
        let text = value.lowercased()
        let markers = [
            "plan approved",
            "approved",
            "implementation started",
            "blocker",
            "validation passed",
            "validation failed",
            "review finding",
            "resolved",
            "completed",
            "run completed",
            "delivery"
        ]
        return markers.contains { text.contains($0) }
    }
}

public enum TimelineCategory: String, CaseIterable, Identifiable, Sendable {
    case decisions = "Decisions"
    case checkpoints = "Checkpoints"
    case reviews = "Reviews"
    case blockers = "Blockers"
    case artifacts = "Artifacts"
    case validation = "Validation"
    case agents = "Agents"
    case phases = "Phases"
    case run = "Run"
    case notes = "Notes"

    public var id: String { rawValue }
}

public extension EventType {
    var isValidationEvent: Bool {
        self == .validationStarted || self == .validationPassed || self == .validationFailed
    }

    var isReviewEvent: Bool {
        self == .reviewFindingOpened || self == .reviewFindingResolved
    }
}

public extension EventType {
    var timelineCategory: TimelineCategory {
        switch self {
        case .decisionRecorded:
            return .decisions
        case .checkpointCreated:
            return .checkpoints
        case .reviewFindingOpened, .reviewFindingResolved:
            return .reviews
        case .blockerOpened, .blockerResolved:
            return .blockers
        case .artifactCreated, .artifactUpdated:
            return .artifacts
        case .validationStarted, .validationPassed, .validationFailed:
            return .validation
        case .agentSpawned, .agentStatusChanged, .agentReported:
            return .agents
        case .phaseStarted, .phaseStatusChanged, .phaseCompleted:
            return .phases
        case .runCreated, .runStatusChanged, .runCompleted, .runFailed:
            return .run
        case .noteAdded, .unknown:
            return .notes
        }
    }
}

public extension Severity {
    var importanceRank: Int {
        switch self {
        case .critical: return 4
        case .error: return 3
        case .warning: return 2
        case .info: return 1
        case .unknown: return 0
        }
    }
}

extension JSONValue {
    var boolValue: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }

    var displayString: String? {
        switch self {
        case .string(let value):
            return value
        case .number(let value):
            return String(value)
        case .bool(let value):
            return value ? "true" : "false"
        case .object, .array, .null:
            return nil
        }
    }
}
