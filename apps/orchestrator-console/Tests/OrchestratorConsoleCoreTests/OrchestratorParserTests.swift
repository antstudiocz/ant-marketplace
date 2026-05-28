import XCTest
@testable import OrchestratorConsoleCore

final class OrchestratorParserTests: XCTestCase {
    func testLoadsStructuredRunAndNormalizesStatuses() throws {
        let workspace = try makeWorkspace()
        let runDirectory = workspace
            .appendingPathComponent(".ant/orchestrator/2026-05-26-test", isDirectory: true)
        try FileManager.default.createDirectory(at: runDirectory, withIntermediateDirectories: true)

        try """
        {
          "schemaVersion": "1.0.0",
          "runId": "2026-05-26-test",
          "workspaceRoot": "\(workspace.path)",
          "host": "codex",
          "createdAt": "2026-05-26T10:00:00Z",
          "updatedAt": "2026-05-26T10:15:00Z",
          "status": "active",
          "currentPhaseId": "06-implementation",
          "preferredLanguage": "cs",
          "agents": [
            {
              "id": "lead",
              "role": "implementation-lead",
              "status": "completed",
              "displayName": "Lead",
              "summary": null,
              "startedAt": "2026-05-26T10:01:00Z",
              "updatedAt": "2026-05-26T10:15:00Z"
            }
          ],
          "edges": [],
          "phases": [
            {
              "id": "06-implementation",
              "title": "Implementation",
              "status": "active",
              "ownerAgentId": "lead",
              "startedAt": "2026-05-26T10:01:00Z",
              "completedAt": null,
              "summary": "Working",
              "artifactRefs": []
            }
          ],
          "blockers": [],
          "artifacts": [],
          "checkpoints": []
        }
        """.write(to: runDirectory.appendingPathComponent("state.json"), atomically: true, encoding: .utf8)

        try """
        {"schemaVersion":"1.0.0","eventId":"event-1","runId":"2026-05-26-test","timestamp":"2026-05-26T10:01:00Z","type":"phase.started","actorAgentId":"lead","phaseId":"06-implementation","agentId":"lead","severity":"info","message":"Started","data":{},"artifactRefs":[]}
        """.write(to: runDirectory.appendingPathComponent("events.jsonl"), atomically: true, encoding: .utf8)

        let runs = try OrchestratorParser().loadRuns(workspaceURL: workspace)

        XCTAssertEqual(runs.count, 1)
        XCTAssertEqual(runs[0].status, .implementing)
        XCTAssertEqual(runs[0].state?.agents.first?.status, .done)
        XCTAssertEqual(runs[0].state?.phases.first?.status, .inProgress)
        XCTAssertEqual(runs[0].events.first?.type, .phaseStarted)
        XCTAssertEqual(runs[0].state?.preferredLanguage, "cs")
    }

    func testBuildsAgentDetailFromStructuredStateAndEvents() throws {
        let workspace = try makeWorkspace()
        let runDirectory = workspace
            .appendingPathComponent(".ant/orchestrator/2026-05-26-agent-detail", isDirectory: true)
        try FileManager.default.createDirectory(at: runDirectory, withIntermediateDirectories: true)

        try """
        {
          "schemaVersion": "1.0.0",
          "runId": "2026-05-26-agent-detail",
          "workspaceRoot": "\(workspace.path)",
          "host": "codex",
          "createdAt": "2026-05-26T10:00:00Z",
          "updatedAt": "2026-05-26T10:15:00Z",
          "status": "implementing",
          "currentPhaseId": "06-implementation",
          "preferredLanguage": "en",
          "agents": [
            {
              "id": "root",
              "role": "root-orchestrator",
              "status": "running",
              "displayName": "Root",
              "summary": "Coordinates",
              "startedAt": "2026-05-26T10:00:00Z",
              "updatedAt": "2026-05-26T10:15:00Z"
            },
            {
              "id": "lead",
              "role": "implementation-lead",
              "status": "running",
              "displayName": "Lead",
              "summary": "Implements",
              "startedAt": "2026-05-26T10:01:00Z",
              "updatedAt": "2026-05-26T10:15:00Z"
            },
            {
              "id": "worker",
              "role": "slice-worker",
              "status": "done",
              "displayName": "Worker",
              "summary": "Slice done",
              "startedAt": "2026-05-26T10:02:00Z",
              "updatedAt": "2026-05-26T10:12:00Z"
            }
          ],
          "edges": [
            {
              "fromAgentId": "root",
              "toAgentId": "lead",
              "relation": "delegates",
              "label": "implementation"
            },
            {
              "fromAgentId": "lead",
              "toAgentId": "worker",
              "relation": "delegates",
              "label": "slice"
            },
            {
              "fromAgentId": "lead",
              "toAgentId": "root",
              "relation": "reports_to",
              "label": "reports"
            }
          ],
          "phases": [],
          "blockers": [
            {
              "id": "blocker-1",
              "title": "Waiting on review",
              "severity": "warning",
              "status": "open",
              "phaseId": "06-implementation",
              "ownerAgentId": "lead",
              "createdAt": "2026-05-26T10:10:00Z",
              "resolvedAt": null,
              "summary": "Review is pending."
            }
          ],
          "artifacts": [
            {
              "id": "phase",
              "kind": "markdown",
              "path": ".ant/orchestrator/2026-05-26-agent-detail/phases/06-implementation/phase.md",
              "title": "Implementation Phase",
              "phaseId": "06-implementation",
              "agentId": "lead",
              "updatedAt": "2026-05-26T10:15:00Z"
            },
            {
              "id": "worker-log",
              "kind": "log",
              "path": ".ant/orchestrator/2026-05-26-agent-detail/worker.log",
              "title": "Worker Log",
              "phaseId": "06-implementation",
              "agentId": "worker",
              "updatedAt": "2026-05-26T10:12:00Z"
            }
          ],
          "checkpoints": [
            {
              "id": "checkpoint-lead",
              "timestamp": "2026-05-26T10:14:00Z",
              "title": "Lead checkpoint",
              "severity": "info",
              "phaseId": "06-implementation",
              "agentId": "lead",
              "summary": "Lead made progress.",
              "artifactRefs": ["phase"]
            }
          ]
        }
        """.write(to: runDirectory.appendingPathComponent("state.json"), atomically: true, encoding: .utf8)

        try """
        {"schemaVersion":"1.0.0","eventId":"event-lead","runId":"2026-05-26-agent-detail","timestamp":"2026-05-26T10:13:00Z","type":"agent.reported","actorAgentId":"lead","phaseId":"06-implementation","agentId":"lead","severity":"info","message":"Lead reported progress","data":{},"artifactRefs":["phase"]}
        {"schemaVersion":"1.0.0","eventId":"event-review","runId":"2026-05-26-agent-detail","timestamp":"2026-05-26T10:14:00Z","type":"review.finding_opened","actorAgentId":"lead","phaseId":"06-implementation","agentId":"lead","severity":"warning","message":"Review finding opened","data":{},"artifactRefs":[]}
        {"schemaVersion":"1.0.0","eventId":"event-worker","runId":"2026-05-26-agent-detail","timestamp":"2026-05-26T10:12:00Z","type":"agent.reported","actorAgentId":"worker","phaseId":"06-implementation","agentId":"worker","severity":"info","message":"Worker reported done","data":{},"artifactRefs":["worker-log"]}
        """.write(to: runDirectory.appendingPathComponent("events.jsonl"), atomically: true, encoding: .utf8)

        let run = try XCTUnwrap(try OrchestratorParser().loadRuns(workspaceURL: workspace).first)
        let state = try XCTUnwrap(run.state)
        let detail = try XCTUnwrap(AgentDetail(run: state, events: run.events, agentId: "lead"))

        XCTAssertEqual(detail.agent.displayName, "Lead")
        XCTAssertEqual(detail.parents.map(\.agent.id), ["root"])
        XCTAssertEqual(detail.children.map(\.agent.id), ["worker"])
        XCTAssertEqual(detail.relatedEvents.map(\.eventId), ["event-review", "event-lead"])
        XCTAssertEqual(detail.relatedCheckpoints.map(\.id), ["checkpoint-lead"])
        XCTAssertEqual(detail.relatedArtifacts.map(\.id), ["phase"])
        XCTAssertEqual(detail.relatedBlockers.map(\.id), ["blocker-1"])
        XCTAssertEqual(detail.reviewEvents.map(\.eventId), ["event-review"])
    }

    func testMarkdownOnlyRunDegradesToArtifactList() throws {
        let workspace = try makeWorkspace()
        let runDirectory = workspace
            .appendingPathComponent(".ant/orchestrator/2026-05-26-markdown", isDirectory: true)
        try FileManager.default.createDirectory(at: runDirectory, withIntermediateDirectories: true)
        try "# Phase\n".write(to: runDirectory.appendingPathComponent("phase.md"), atomically: true, encoding: .utf8)

        let runs = try OrchestratorParser().loadRuns(workspaceURL: workspace)

        XCTAssertEqual(runs.count, 1)
        XCTAssertFalse(runs[0].hasStructuredState)
        XCTAssertEqual(runs[0].artifacts.count, 1)
        XCTAssertEqual(runs[0].artifacts[0].path, ".ant/orchestrator/2026-05-26-markdown/phase.md")
        XCTAssertTrue(runs[0].warnings.contains { $0.contains("Structured state is missing") })
    }

    func testInvalidJSONLLineProducesWarningWithoutDroppingValidEvents() throws {
        let workspace = try makeWorkspace()
        let runDirectory = workspace
            .appendingPathComponent(".ant/orchestrator/2026-05-26-events", isDirectory: true)
        try FileManager.default.createDirectory(at: runDirectory, withIntermediateDirectories: true)
        try """
        {"schemaVersion":"1.0.0","eventId":"event-1","runId":"2026-05-26-events","timestamp":"2026-05-26T10:01:00Z","type":"phase.started","actorAgentId":"lead","phaseId":"06-implementation","agentId":"lead","severity":"info","message":"Started","data":{},"artifactRefs":[]}
        not-json
        """.write(to: runDirectory.appendingPathComponent("events.jsonl"), atomically: true, encoding: .utf8)

        let runs = try OrchestratorParser().loadRuns(workspaceURL: workspace)

        XCTAssertEqual(runs.count, 1)
        XCTAssertEqual(runs[0].events.count, 1)
        XCTAssertTrue(runs[0].warnings.contains { $0.contains("line 2") })
    }

    func testArtifactResolverRejectsTraversalAndNonExternalAbsolutePaths() throws {
        let workspace = try makeWorkspace()
        let resolver = ArtifactResolver(workspaceURL: workspace)
        let outside = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent("outside.md")
        try FileManager.default.createDirectory(at: outside.deletingLastPathComponent(), withIntermediateDirectories: true)
        try "outside".write(to: outside, atomically: true, encoding: .utf8)

        XCTAssertNil(resolver.resolve(artifact(path: "../outside.md", kind: .markdown)))
        XCTAssertNil(resolver.resolve(artifact(path: outside.path, kind: .markdown)))
        XCTAssertEqual(resolver.resolve(artifact(path: outside.path, kind: .external)), outside.standardizedFileURL.resolvingSymlinksInPath())
    }

    func testArtifactResolverRejectsSymlinkEscapingWorkspace() throws {
        let workspace = try makeWorkspace()
        let outsideDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: outsideDirectory, withIntermediateDirectories: true)
        let outsideFile = outsideDirectory.appendingPathComponent("secret.md")
        try "secret".write(to: outsideFile, atomically: true, encoding: .utf8)

        let linkURL = workspace.appendingPathComponent("linked", isDirectory: true)
        try FileManager.default.createSymbolicLink(at: linkURL, withDestinationURL: outsideDirectory)

        XCTAssertNil(ArtifactResolver(workspaceURL: workspace).resolve(artifact(path: "linked/secret.md", kind: .markdown)))
    }

    func testWorkspaceProjectPersistenceMigratesLegacyLastWorkspacePath() throws {
        let workspace = try makeWorkspace()

        let list = WorkspaceProjectPersistence.load(
            savedJSON: "",
            legacyLastWorkspacePath: workspace.path
        )

        XCTAssertEqual(list.projects.count, 1)
        XCTAssertEqual(list.projects[0].path, workspace.standardizedFileURL.path)
        XCTAssertEqual(list.selectedProjectId, workspace.standardizedFileURL.path)
    }

    func testWorkspaceProjectPersistenceDeduplicatesAndPreservesSavedOrder() throws {
        let olderDate = try XCTUnwrap(ISO8601DateFormatter().date(from: "2026-05-26T10:00:00Z"))
        let newerDate = try XCTUnwrap(ISO8601DateFormatter().date(from: "2026-05-26T11:00:00Z"))
        let workspaceA = try makeWorkspace()
        let workspaceB = try makeWorkspace()
        let projectA = WorkspaceProject(url: workspaceA, addedAt: olderDate, lastOpenedAt: olderDate)
        let selectedProject = WorkspaceProject(url: workspaceB, addedAt: olderDate, lastOpenedAt: newerDate)

        let encoded = try WorkspaceProjectPersistence.encode(
            WorkspaceProjectList(
                projects: [projectA, selectedProject, projectA],
                selectedProjectId: selectedProject.id
            )
        )
        let decoded = WorkspaceProjectPersistence.load(savedJSON: encoded)

        XCTAssertEqual(decoded.projects.map(\.id), [projectA.id, selectedProject.id])
        XCTAssertEqual(decoded.selectedProjectId, selectedProject.id)
    }

    func testWorkspaceProjectListFallsBackToFirstSavedProjectWhenSelectionIsMissing() throws {
        let olderDate = try XCTUnwrap(ISO8601DateFormatter().date(from: "2026-05-26T10:00:00Z"))
        let newerDate = try XCTUnwrap(ISO8601DateFormatter().date(from: "2026-05-26T11:00:00Z"))
        let olderProject = WorkspaceProject(url: try makeWorkspace(), addedAt: olderDate, lastOpenedAt: olderDate)
        let newerProject = WorkspaceProject(url: try makeWorkspace(), addedAt: olderDate, lastOpenedAt: newerDate)

        let list = WorkspaceProjectList(
            projects: [olderProject, newerProject],
            selectedProjectId: nil
        )

        XCTAssertEqual(list.projects.map(\.id), [olderProject.id, newerProject.id])
        XCTAssertEqual(list.selectedProjectId, olderProject.id)
    }

    func testSelectingProjectDoesNotMoveItToTopOfSavedOrder() throws {
        let olderDate = try XCTUnwrap(ISO8601DateFormatter().date(from: "2026-05-26T10:00:00Z"))
        let newerDate = try XCTUnwrap(ISO8601DateFormatter().date(from: "2026-05-26T11:00:00Z"))
        let firstProject = WorkspaceProject(url: try makeWorkspace(), addedAt: olderDate, lastOpenedAt: olderDate)
        let selectedProject = WorkspaceProject(url: try makeWorkspace(), addedAt: olderDate, lastOpenedAt: newerDate)

        let list = WorkspaceProjectList(
            projects: [firstProject, selectedProject],
            selectedProjectId: selectedProject.id
        )

        XCTAssertEqual(list.projects.map(\.id), [firstProject.id, selectedProject.id])
        XCTAssertEqual(list.selectedProjectId, selectedProject.id)
    }

    func testArtifactPreviewReaderReadsSupportedTextAndPrettyPrintsJSON() throws {
        let workspace = try makeWorkspace()
        let artifactURL = workspace.appendingPathComponent(".ant/orchestrator/preview.json")
        try #"{"b":2,"a":1}"#.write(to: artifactURL, atomically: true, encoding: .utf8)

        let preview = try ArtifactPreviewReader(workspaceURL: workspace).preview(
            artifact(path: ".ant/orchestrator/preview.json", kind: .json)
        )

        XCTAssertEqual(preview.displayMode, .code)
        XCTAssertTrue(preview.content.contains(#""a" : 1"#))
        XCTAssertTrue(preview.content.contains(#""b" : 2"#))
    }

    func testArtifactPreviewReaderClassifiesMarkdownForRichPreview() throws {
        let workspace = try makeWorkspace()
        try "# Phase\n\n**Done**\n".write(
            to: workspace.appendingPathComponent("phase.md"),
            atomically: true,
            encoding: .utf8
        )
        try "# External\n".write(
            to: workspace.appendingPathComponent("external.md"),
            atomically: true,
            encoding: .utf8
        )

        let reader = ArtifactPreviewReader(workspaceURL: workspace)

        let markdownPreview = try reader.preview(artifact(path: "phase.md", kind: .markdown))
        let extensionPreview = try reader.preview(artifact(path: "external.md", kind: .unknown))

        XCTAssertEqual(markdownPreview.displayMode, .markdown)
        XCTAssertEqual(extensionPreview.displayMode, .markdown)
    }

    func testArtifactPreviewReaderRejectsUnsupportedBinaryKind() throws {
        let workspace = try makeWorkspace()
        let artifactURL = workspace.appendingPathComponent("app.bin")
        try Data([0, 1, 2, 3]).write(to: artifactURL)

        XCTAssertThrowsError(
            try ArtifactPreviewReader(workspaceURL: workspace).preview(
                artifact(path: "app.bin", kind: .app)
            )
        ) { error in
            XCTAssertEqual(error as? ArtifactPreviewError, .unreadableKind(.app, "app.bin"))
        }
    }

    func testPhaseDetailCollectsRelatedStructuredObjects() throws {
        let workspace = try makeWorkspace()
        let runDirectory = workspace
            .appendingPathComponent(".ant/orchestrator/2026-05-26-phase-detail", isDirectory: true)
        try FileManager.default.createDirectory(at: runDirectory, withIntermediateDirectories: true)

        try """
        {
          "schemaVersion": "1.0.0",
          "runId": "2026-05-26-phase-detail",
          "workspaceRoot": "\(workspace.path)",
          "host": "codex",
          "createdAt": "2026-05-26T10:00:00Z",
          "updatedAt": "2026-05-26T10:15:00Z",
          "status": "implementing",
          "currentPhaseId": "06-implementation",
          "preferredLanguage": "en",
          "agents": [
            {
              "id": "lead",
              "role": "implementation-lead",
              "status": "running",
              "displayName": "Lead",
              "summary": null,
              "startedAt": "2026-05-26T10:00:00Z",
              "updatedAt": "2026-05-26T10:15:00Z"
            }
          ],
          "edges": [],
          "phases": [
            {
              "id": "06-implementation",
              "title": "Implementation",
              "status": "in_progress",
              "ownerAgentId": "lead",
              "startedAt": "2026-05-26T10:00:00Z",
              "completedAt": null,
              "summary": "Working",
              "artifactRefs": ["phase-note"]
            }
          ],
          "blockers": [
            {
              "id": "blocker-1",
              "title": "Blocked",
              "severity": "warning",
              "status": "open",
              "phaseId": "06-implementation",
              "ownerAgentId": "lead",
              "createdAt": "2026-05-26T10:03:00Z",
              "resolvedAt": null,
              "summary": null
            }
          ],
          "artifacts": [
            {
              "id": "phase-note",
              "kind": "markdown",
              "path": ".ant/orchestrator/2026-05-26-phase-detail/phase.md",
              "title": "Phase Note",
              "phaseId": null,
              "agentId": "lead",
              "updatedAt": "2026-05-26T10:08:00Z"
            }
          ],
          "checkpoints": [
            {
              "id": "checkpoint-1",
              "timestamp": "2026-05-26T10:06:00Z",
              "title": "Checkpoint",
              "severity": "info",
              "phaseId": "06-implementation",
              "agentId": "lead",
              "summary": "Progress",
              "artifactRefs": ["phase-note"]
            }
          ]
        }
        """.write(to: runDirectory.appendingPathComponent("state.json"), atomically: true, encoding: .utf8)

        try """
        {"schemaVersion":"1.0.0","eventId":"event-1","runId":"2026-05-26-phase-detail","timestamp":"2026-05-26T10:04:00Z","type":"validation.passed","actorAgentId":"lead","phaseId":"06-implementation","agentId":"lead","severity":"info","message":"Tests passed","data":{},"artifactRefs":["phase-note"]}
        """.write(to: runDirectory.appendingPathComponent("events.jsonl"), atomically: true, encoding: .utf8)

        let run = try XCTUnwrap(try OrchestratorParser().loadRuns(workspaceURL: workspace).first)
        let state = try XCTUnwrap(run.state)
        let detail = try XCTUnwrap(PhaseDetail(run: state, events: run.events, phaseId: "06-implementation"))

        XCTAssertEqual(detail.phase.title, "Implementation")
        XCTAssertEqual(detail.ownerAgent?.id, "lead")
        XCTAssertEqual(detail.relatedEvents.map(\.eventId), ["event-1"])
        XCTAssertEqual(detail.relatedCheckpoints.map(\.id), ["checkpoint-1"])
        XCTAssertEqual(detail.relatedArtifacts.map(\.id), ["phase-note"])
        XCTAssertEqual(detail.relatedBlockers.map(\.id), ["blocker-1"])
        XCTAssertEqual(detail.validationEvents.map(\.eventId), ["event-1"])
    }

    func testCurrentWorkAndRunHealthSummariesUseStructuredState() throws {
        let workspace = try makeWorkspace()
        let runDirectory = workspace
            .appendingPathComponent(".ant/orchestrator/2026-05-26-health", isDirectory: true)
        try FileManager.default.createDirectory(at: runDirectory, withIntermediateDirectories: true)

        try """
        {
          "schemaVersion": "1.0.0",
          "runId": "2026-05-26-health",
          "workspaceRoot": "\(workspace.path)",
          "host": "codex",
          "createdAt": "2026-05-26T10:00:00Z",
          "updatedAt": "2026-05-26T10:20:00Z",
          "status": "blocked",
          "currentPhaseId": "06-implementation",
          "preferredLanguage": "en",
          "agents": [
            {
              "id": "lead",
              "role": "implementation-lead",
              "status": "blocked",
              "displayName": "Lead",
              "summary": "Waiting for decision",
              "startedAt": "2026-05-26T10:00:00Z",
              "updatedAt": "2026-05-26T10:20:00Z"
            },
            {
              "id": "worker",
              "role": "slice-worker",
              "status": "done",
              "displayName": "Worker",
              "summary": null,
              "startedAt": "2026-05-26T10:02:00Z",
              "updatedAt": "2026-05-26T10:12:00Z"
            }
          ],
          "edges": [],
          "phases": [
            {
              "id": "06-implementation",
              "title": "Implementation",
              "status": "blocked",
              "ownerAgentId": "lead",
              "startedAt": "2026-05-26T10:00:00Z",
              "completedAt": null,
              "summary": "Decision needed",
              "artifactRefs": ["evidence"]
            }
          ],
          "blockers": [
            {
              "id": "decision",
              "title": "Waiting on user decision",
              "severity": "warning",
              "status": "open",
              "phaseId": "06-implementation",
              "ownerAgentId": "lead",
              "createdAt": "2026-05-26T10:19:00Z",
              "resolvedAt": null,
              "summary": "Need approval."
            }
          ],
          "artifacts": [
            {
              "id": "evidence",
              "kind": "markdown",
              "path": ".ant/orchestrator/2026-05-26-health/phase.md",
              "title": "Evidence",
              "phaseId": "06-implementation",
              "agentId": "lead",
              "updatedAt": "2026-05-26T10:20:00Z"
            }
          ],
          "checkpoints": [
            {
              "id": "checkpoint-1",
              "timestamp": "2026-05-26T10:18:00Z",
              "title": "Checkpoint",
              "severity": "info",
              "phaseId": "06-implementation",
              "agentId": "lead",
              "summary": "Blocked on decision.",
              "artifactRefs": ["evidence"]
            }
          ]
        }
        """.write(to: runDirectory.appendingPathComponent("state.json"), atomically: true, encoding: .utf8)

        try """
        {"schemaVersion":"1.0.0","eventId":"event-validation","runId":"2026-05-26-health","timestamp":"2026-05-26T10:17:00Z","type":"validation.failed","actorAgentId":"lead","phaseId":"06-implementation","agentId":"lead","severity":"error","message":"Tests failed","data":{},"artifactRefs":["evidence"]}
        {"schemaVersion":"1.0.0","eventId":"event-blocker","runId":"2026-05-26-health","timestamp":"2026-05-26T10:19:00Z","type":"blocker.opened","actorAgentId":"lead","phaseId":"06-implementation","agentId":"lead","severity":"warning","message":"Waiting on user decision","data":{"needsUserDecision":true},"artifactRefs":["evidence"]}
        """.write(to: runDirectory.appendingPathComponent("events.jsonl"), atomically: true, encoding: .utf8)

        let run = try XCTUnwrap(try OrchestratorParser().loadRuns(workspaceURL: workspace).first)
        let state = try XCTUnwrap(run.state)
        let currentWork = CurrentWorkSummary(run: state, events: run.events)
        let health = RunHealthSummary(run: state, events: run.events)
        let progressFacts = RunProgressFacts(run: state, events: run.events)

        XCTAssertEqual(currentWork.phase?.id, "06-implementation")
        XCTAssertEqual(currentWork.activeAgent?.id, "lead")
        XCTAssertEqual(currentWork.latestCheckpoint?.id, "checkpoint-1")
        XCTAssertTrue(currentWork.needsUserDecision)
        XCTAssertTrue(currentWork.nextStep.contains("User decision"))
        XCTAssertEqual(health.readinessLabel, "Blocked")
        XCTAssertEqual(health.openBlockers, 1)
        XCTAssertEqual(health.failedValidations, 1)
        XCTAssertEqual(health.completedAgents, 1)
        XCTAssertEqual(progressFacts.blockerFacts.map(\.title), ["Waiting on user decision"])
        XCTAssertEqual(progressFacts.validationFacts.map(\.title), ["Tests failed"])
        XCTAssertEqual(progressFacts.relevantArtifacts.map(\.id), ["evidence"])
        XCTAssertTrue(progressFacts.decisionFacts.contains { $0.title.contains("decision") })

        let commandCenter = CommandCenterSummary(run: state, events: run.events)
        let decisions = DecisionFact.decisions(run: state, events: run.events)

        XCTAssertEqual(commandCenter.verdict, "Decision needed")
        XCTAssertTrue(commandCenter.nextAction.contains("pending decision"))
        XCTAssertTrue(commandCenter.riskSummary.contains("open blocker"))
        XCTAssertEqual(decisions.first?.status, "Open")
        XCTAssertEqual(decisions.first?.impact, "Run cannot proceed until this is resolved.")
    }

    func testTimelineCategoriesGroupImportantControlCenterEvents() {
        XCTAssertEqual(EventType.decisionRecorded.timelineCategory, .decisions)
        XCTAssertEqual(EventType.checkpointCreated.timelineCategory, .checkpoints)
        XCTAssertEqual(EventType.reviewFindingOpened.timelineCategory, .reviews)
        XCTAssertEqual(EventType.blockerOpened.timelineCategory, .blockers)
        XCTAssertEqual(EventType.artifactUpdated.timelineCategory, .artifacts)
        XCTAssertEqual(EventType.validationPassed.timelineCategory, .validation)
    }

    func testCommandCenterEvidenceAndTimelineSeparateSignalFromTechnicalNoise() throws {
        let workspace = try makeWorkspace()
        let runDirectory = workspace
            .appendingPathComponent(".ant/orchestrator/2026-05-26-command-center", isDirectory: true)
        try FileManager.default.createDirectory(at: runDirectory, withIntermediateDirectories: true)

        try """
        {
          "schemaVersion": "1.0.0",
          "runId": "2026-05-26-command-center",
          "workspaceRoot": "\(workspace.path)",
          "host": "codex",
          "createdAt": "2026-05-26T10:00:00Z",
          "updatedAt": "2026-05-26T10:30:00Z",
          "status": "completed",
          "currentPhaseId": null,
          "preferredLanguage": "cs",
          "agents": [],
          "edges": [],
          "phases": [
            {
              "id": "06-implementation",
              "title": "Implementation",
              "status": "completed",
              "ownerAgentId": null,
              "startedAt": "2026-05-26T10:05:00Z",
              "completedAt": "2026-05-26T10:25:00Z",
              "summary": "Implemented command center.",
              "artifactRefs": ["plan"]
            },
            {
              "id": "06-implementation/status-ui-polish-checkpoint",
              "title": "Status UI polish checkpoint",
              "status": "completed",
              "ownerAgentId": null,
              "startedAt": "2026-05-26T10:10:00Z",
              "completedAt": "2026-05-26T10:12:00Z",
              "summary": "Internal UI polish.",
              "artifactRefs": []
            }
          ],
          "blockers": [],
          "artifacts": [
            {"id":"plan","kind":"markdown","path":".ant/orchestrator/run/phases/05-planning/implementation-plan.md","title":"Implementation Plan","phaseId":"06-implementation","agentId":null,"updatedAt":"2026-05-26T10:01:00Z"},
            {"id":"review","kind":"markdown","path":".ant/orchestrator/run/review.md","title":"Review Findings","phaseId":"06-implementation","agentId":null,"updatedAt":"2026-05-26T10:20:00Z"},
            {"id":"verify","kind":"log","path":".ant/orchestrator/run/verification.log","title":"Verification Log","phaseId":"06-implementation","agentId":null,"updatedAt":"2026-05-26T10:28:00Z"},
            {"id":"schema","kind":"schema","path":"plugins/ant/contracts/state.schema.json","title":"State Schema","phaseId":null,"agentId":null,"updatedAt":"2026-05-26T10:03:00Z"},
            {"id":"source","kind":"source","path":"apps/orchestrator-console/Sources/View.swift","title":"Source","phaseId":null,"agentId":null,"updatedAt":"2026-05-26T10:15:00Z"}
          ],
          "checkpoints": [
            {"id":"technical-polish","timestamp":"2026-05-26T10:12:00Z","title":"Graph polish checkpoint","severity":"info","phaseId":"06-implementation/status-ui-polish-checkpoint","agentId":null,"summary":"Adjusted graph spacing.","artifactRefs":[]}
          ]
        }
        """.write(to: runDirectory.appendingPathComponent("state.json"), atomically: true, encoding: .utf8)

        try """
        {"schemaVersion":"1.0.0","eventId":"plan-approved","runId":"2026-05-26-command-center","timestamp":"2026-05-26T10:02:00Z","type":"decision.recorded","actorAgentId":"root","phaseId":null,"agentId":null,"severity":"info","message":"Plan approved","data":{"rationale":"User approved redesign","impact":"Proceed with implementation"},"artifactRefs":["plan"]}
        {"schemaVersion":"1.0.0","eventId":"graph-polish","runId":"2026-05-26-command-center","timestamp":"2026-05-26T10:12:00Z","type":"agent.reported","actorAgentId":"lead","phaseId":"06-implementation/status-ui-polish-checkpoint","agentId":"lead","severity":"info","message":"Graph/status polish checkpoint updated","data":{},"artifactRefs":[]}
        {"schemaVersion":"1.0.0","eventId":"validation","runId":"2026-05-26-command-center","timestamp":"2026-05-26T10:28:00Z","type":"validation.passed","actorAgentId":"lead","phaseId":"06-implementation","agentId":"lead","severity":"info","message":"swift test passed","data":{},"artifactRefs":["verify"]}
        {"schemaVersion":"1.0.0","eventId":"completed","runId":"2026-05-26-command-center","timestamp":"2026-05-26T10:30:00Z","type":"run.completed","actorAgentId":"root","phaseId":null,"agentId":null,"severity":"info","message":"Run completed","data":{},"artifactRefs":["review","verify"]}
        """.write(to: runDirectory.appendingPathComponent("events.jsonl"), atomically: true, encoding: .utf8)

        let run = try XCTUnwrap(try OrchestratorParser().loadRuns(workspaceURL: workspace).first)
        let state = try XCTUnwrap(run.state)
        let commandCenter = CommandCenterSummary(run: state, events: run.events)
        let milestones = MilestoneFact.milestones(run: state, events: run.events)
        let evidenceGroups = EvidenceGroup.groups(for: state.artifacts)
        let timeline = SignificantTimelineEvent.timeline(run: state, events: run.events)

        XCTAssertEqual(commandCenter.verdict, "Completed")
        XCTAssertEqual(commandCenter.nextAction, "Review final evidence, decisions, and delivery handoff.")
        XCTAssertTrue(milestones.first { $0.id.contains("status-ui-polish") }?.isTechnical == true)
        XCTAssertEqual(evidenceGroups.map(\.category), [.decisionsPlan, .review, .verification, .contractsSchemas, .appSource])
        XCTAssertTrue(timeline.first { $0.id == "event-plan-approved" }?.isTechnical == false)
        XCTAssertTrue(timeline.first { $0.id == "event-graph-polish" }?.isTechnical == true)
        XCTAssertTrue(timeline.first { $0.id == "event-validation" }?.isTechnical == false)
        XCTAssertTrue(timeline.first { $0.id == "event-completed" }?.isTechnical == false)
    }

    func testLoadsRunsFromSelectedWorkspaceOnly() throws {
        let workspaceA = try makeWorkspace()
        let workspaceB = try makeWorkspace()
        try FileManager.default.createDirectory(
            at: workspaceA.appendingPathComponent(".ant/orchestrator/2026-05-26-a", isDirectory: true),
            withIntermediateDirectories: true
        )
        try FileManager.default.createDirectory(
            at: workspaceB.appendingPathComponent(".ant/orchestrator/2026-05-26-b", isDirectory: true),
            withIntermediateDirectories: true
        )

        let runs = try OrchestratorParser().loadRuns(workspaceURL: workspaceB)

        XCTAssertEqual(runs.map(\.runId), ["2026-05-26-b"])
    }

    func testDeleteRunRemovesRunDirectoryFromFilesystem() throws {
        let workspace = try makeWorkspace()
        let runDirectory = workspace
            .appendingPathComponent(".ant/orchestrator/2026-05-26-delete", isDirectory: true)
        try FileManager.default.createDirectory(at: runDirectory, withIntermediateDirectories: true)
        try "evidence".write(
            to: runDirectory.appendingPathComponent("evidence.md"),
            atomically: true,
            encoding: .utf8
        )

        let parser = OrchestratorParser()
        let run = try XCTUnwrap(try parser.loadRuns(workspaceURL: workspace).first)

        try parser.deleteRun(run, workspaceURL: workspace)

        XCTAssertFalse(FileManager.default.fileExists(atPath: runDirectory.path))
        XCTAssertTrue(try parser.loadRuns(workspaceURL: workspace).isEmpty)
    }

    func testDeleteRunRejectsSymlinkedOrchestratorRoot() throws {
        let workspace = try makeWorkspace()
        let orchestratorURL = workspace.appendingPathComponent(".ant/orchestrator", isDirectory: true)
        try FileManager.default.removeItem(at: orchestratorURL)

        let externalOrchestrator = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let externalRun = externalOrchestrator.appendingPathComponent("2026-05-26-external", isDirectory: true)
        try FileManager.default.createDirectory(at: externalRun, withIntermediateDirectories: true)
        try "external".write(
            to: externalRun.appendingPathComponent("evidence.md"),
            atomically: true,
            encoding: .utf8
        )
        try FileManager.default.createSymbolicLink(
            atPath: orchestratorURL.path,
            withDestinationPath: externalOrchestrator.path
        )

        let parser = OrchestratorParser()
        let run = parser.loadRun(directoryURL: externalRun)

        XCTAssertThrowsError(
            try parser.deleteRun(run, workspaceURL: workspace)
        ) { error in
            XCTAssertEqual(error as? OrchestratorParserError, .invalidRunDirectory(run.directoryURL))
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: externalRun.path))
    }

    func testDeleteRunRejectsDirectoryOutsideWorkspaceOrchestratorFolder() throws {
        let workspace = try makeWorkspace()
        let outsideDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: outsideDirectory, withIntermediateDirectories: true)
        let outsideRun = OrchestratorParser().loadRun(directoryURL: outsideDirectory)

        XCTAssertThrowsError(
            try OrchestratorParser().deleteRun(outsideRun, workspaceURL: workspace)
        ) { error in
            XCTAssertEqual(error as? OrchestratorParserError, .invalidRunDirectory(outsideDirectory))
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: outsideDirectory.path))
    }

    private func makeWorkspace() throws -> URL {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(
            at: root.appendingPathComponent(".ant/orchestrator", isDirectory: true),
            withIntermediateDirectories: true
        )
        return root
    }

    private func artifact(path: String, kind: ArtifactKind) -> Artifact {
        Artifact(id: path, kind: kind, path: path, title: nil, phaseId: nil, agentId: nil, updatedAt: nil)
    }
}
