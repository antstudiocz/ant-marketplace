import AppKit
import Foundation
import OrchestratorConsoleCore

@MainActor
final class RunStore: ObservableObject {
    @Published private(set) var workspaceProjects: [WorkspaceProject] = []
    @Published private(set) var selectedProjectId: String?
    @Published private(set) var workspaceURL: URL?
    @Published private(set) var runs: [RunRecord] = []
    @Published private(set) var projectSummaries: [ProjectDashboardSummary] = []
    @Published var selectedRunId: String?
    @Published var searchText = ""
    @Published private(set) var errorMessage: String?
    @Published private(set) var lastReloadedAt: Date?

    private let parser = OrchestratorParser()
    private var watcher: FileSystemWatcher?

    var filteredRuns: [RunRecord] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return runs
        }
        let query = searchText.lowercased()
        return runs.filter { run in
            run.displayTitle.lowercased().contains(query)
                || run.status.rawValue.lowercased().contains(query)
                || run.host.rawValue.lowercased().contains(query)
        }
    }

    var selectedRun: RunRecord? {
        guard let selectedRunId else { return filteredRuns.first ?? runs.first }
        return runs.first { $0.id == selectedRunId }
    }

    var selectedProject: WorkspaceProject? {
        guard let selectedProjectId else { return nil }
        return workspaceProjects.first { $0.id == selectedProjectId }
    }

    func configureWorkspaces(_ projects: [WorkspaceProject], selectedProjectId: String?) {
        let list = WorkspaceProjectList(projects: projects, selectedProjectId: selectedProjectId)
        workspaceProjects = list.projects
        self.selectedProjectId = list.selectedProjectId
        workspaceURL = selectedProject?.url
        selectedRunId = nil
        if workspaceURL == nil {
            clearLoadedRuns()
            refreshProjectSummaries()
            return
        }
        reload()
    }

    func addOrSelectWorkspace(_ url: URL) {
        let now = Date()
        let incoming = WorkspaceProject(url: url, addedAt: now, lastOpenedAt: now)
        let projects: [WorkspaceProject]
        if workspaceProjects.contains(where: { $0.id == incoming.id }) {
            projects = workspaceProjects.map { project in
                project.id == incoming.id ? project.opened(at: now) : project
            }
        } else {
            projects = workspaceProjects + [incoming]
        }
        selectProject(incoming.id, from: projects, openedAt: now)
    }

    func selectProject(_ projectId: String) {
        selectProject(projectId, from: workspaceProjects, openedAt: Date())
    }

    func forgetProject(_ projectId: String) {
        let projects = workspaceProjects.filter { $0.id != projectId }
        let nextSelectedId = projectId == selectedProjectId ? projects.first?.id : selectedProjectId
        configureWorkspaces(projects, selectedProjectId: nextSelectedId)
    }

    func reload() {
        guard let workspaceURL else { return }
        do {
            let loadedRuns = try parser.loadRuns(workspaceURL: workspaceURL)
            runs = loadedRuns
            if selectedRunId == nil || !loadedRuns.contains(where: { $0.id == selectedRunId }) {
                selectedRunId = loadedRuns.first?.id
            }
            errorMessage = nil
            lastReloadedAt = Date()
            configureWatcher()
            refreshProjectSummaries()
        } catch {
            runs = []
            selectedRunId = nil
            errorMessage = error.localizedDescription
            lastReloadedAt = Date()
            configureWatcher()
            refreshProjectSummaries()
        }
    }

    func revealWorkspace() {
        guard let workspaceURL else { return }
        NSWorkspace.shared.activateFileViewerSelecting([workspaceURL])
    }

    func revealArtifact(_ artifact: Artifact) {
        guard let workspaceURL else { return }
        guard let url = ArtifactResolver(workspaceURL: workspaceURL).resolve(artifact) else { return }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

    func openArtifact(_ artifact: Artifact) {
        guard let workspaceURL else { return }
        guard let url = ArtifactResolver(workspaceURL: workspaceURL).resolve(artifact) else { return }
        NSWorkspace.shared.open(url)
    }

    func deleteRun(_ run: RunRecord) throws {
        guard let workspaceURL else { return }

        let deletedRunIndex = runs.firstIndex {
            $0.id == run.id && $0.directoryURL == run.directoryURL
        }
        try parser.deleteRun(run, workspaceURL: workspaceURL)
        reload(selectingFallbackForDeletedRunAt: deletedRunIndex)
    }

    func previewArtifact(_ artifact: Artifact) -> Result<ArtifactPreview, ArtifactPreviewError> {
        guard let workspaceURL else { return .failure(.missingWorkspace) }

        do {
            return .success(try ArtifactPreviewReader(workspaceURL: workspaceURL).preview(artifact))
        } catch let error as ArtifactPreviewError {
            return .failure(error)
        } catch {
            return .failure(.readFailed(artifact.path))
        }
    }

    private func configureWatcher() {
        guard let workspaceURL else {
            watcher = nil
            return
        }

        let orchestratorURL = workspaceURL.appendingPathComponent(".ant/orchestrator", isDirectory: true)
        var urls = [orchestratorURL]
        urls.append(contentsOf: runs.flatMap { run in
            [
                run.directoryURL,
                run.directoryURL.appendingPathComponent("state.json"),
                run.directoryURL.appendingPathComponent("events.jsonl")
            ]
        })

        watcher = FileSystemWatcher(urls: urls) { [weak self] in
            Task { @MainActor in
                self?.reload()
            }
        }
    }

    private func reload(selectingFallbackForDeletedRunAt deletedRunIndex: Int?) {
        guard let workspaceURL else { return }
        do {
            let loadedRuns = try parser.loadRuns(workspaceURL: workspaceURL)
            runs = loadedRuns
            if loadedRuns.isEmpty {
                selectedRunId = nil
            } else if let deletedRunIndex {
                let fallbackIndex = min(deletedRunIndex, loadedRuns.count - 1)
                selectedRunId = loadedRuns[fallbackIndex].id
            } else if selectedRunId == nil || !loadedRuns.contains(where: { $0.id == selectedRunId }) {
                selectedRunId = loadedRuns.first?.id
            }
            errorMessage = nil
            lastReloadedAt = Date()
            configureWatcher()
            refreshProjectSummaries()
        } catch {
            runs = []
            selectedRunId = nil
            errorMessage = error.localizedDescription
            lastReloadedAt = Date()
            configureWatcher()
            refreshProjectSummaries()
        }
    }

    private func selectProject(_ projectId: String, from projects: [WorkspaceProject], openedAt: Date) {
        let updatedProjects = projects.map { project in
            project.id == projectId ? project.opened(at: openedAt) : project
        }
        configureWorkspaces(updatedProjects, selectedProjectId: projectId)
    }

    private func clearLoadedRuns() {
        workspaceURL = nil
        runs = []
        selectedRunId = nil
        errorMessage = nil
        watcher = nil
    }

    private func refreshProjectSummaries() {
        projectSummaries = workspaceProjects.map { project in
            let projectRuns: [RunRecord]
            let loadError: String?
            if project.id == selectedProjectId {
                projectRuns = runs
                loadError = errorMessage
            } else {
                do {
                    projectRuns = try parser.loadRuns(workspaceURL: project.url)
                    loadError = nil
                } catch {
                    projectRuns = []
                    loadError = error.localizedDescription
                }
            }
            return ProjectDashboardSummary(
                project: project,
                isSelected: project.id == selectedProjectId,
                runs: projectRuns,
                errorMessage: loadError
            )
        }
    }
}

struct ProjectDashboardSummary: Identifiable, Equatable {
    var id: String { project.id }
    let project: WorkspaceProject
    let isSelected: Bool
    let runCount: Int
    let activeCount: Int
    let blockedCount: Int
    let completedCount: Int
    let lastUpdatedAt: Date?
    let latestRunTitle: String?
    let errorMessage: String?

    init(project: WorkspaceProject, isSelected: Bool, runs: [RunRecord], errorMessage: String?) {
        self.project = project
        self.isSelected = isSelected
        self.runCount = runs.count
        self.activeCount = runs.filter { $0.status == .planning || $0.status == .implementing || $0.status == .reviewing || $0.status == .verifying || $0.status == .paused }.count
        self.blockedCount = runs.filter { $0.status == .blocked || $0.status == .failed }.count
        self.completedCount = runs.filter { $0.status == .completed }.count
        self.lastUpdatedAt = runs.compactMap(\.updatedAt).max() ?? project.lastOpenedAt
        self.latestRunTitle = runs.sorted {
            ($0.updatedAt ?? .distantPast) > ($1.updatedAt ?? .distantPast)
        }.first?.displayTitle
        self.errorMessage = errorMessage
    }
}
