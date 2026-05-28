import OrchestratorConsoleCore
import SwiftUI

struct SidebarView: View {
    @ObservedObject var store: RunStore
    let addProject: () -> Void
    @State private var pendingDeletion: PendingRunDeletion?
    @State private var deletionError: RunDeletionErrorAlert?

    var body: some View {
        List(selection: $store.selectedRunId) {
            Section(L10n.t("Workspace", "Workspace")) {
                ProjectSwitcher(store: store, addProject: addProject)
                    .listRowInsets(EdgeInsets(top: 4, leading: 10, bottom: 6, trailing: 10))
            }

            Section {
                if store.filteredRuns.isEmpty {
                    Text(L10n.t("No runs", "Žádné běhy"))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 4)
                } else {
                    ForEach(store.filteredRuns) { run in
                        RunRow(run: run)
                            .tag(run.id)
                            .contextMenu {
                                Button(role: .destructive) {
                                    pendingDeletion = PendingRunDeletion(run: run)
                                } label: {
                                    Label(L10n.t("Delete Run...", "Smazat běh..."), systemImage: "trash")
                                }
                            }
                    }
                }
            } header: {
                HStack {
                    Text(L10n.t("Runs", "Běhy"))
                    Spacer()
                    if !store.filteredRuns.isEmpty {
                        Text("\(store.filteredRuns.count)")
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $store.searchText, placement: .sidebar, prompt: L10n.t("Search runs", "Hledat běhy"))
        .alert(item: $pendingDeletion) { pendingDeletion in
            Alert(
                title: Text(L10n.t("Delete Orchestration?", "Smazat orchestraci?")),
                message: Text(L10n.t("Delete \"\(pendingDeletion.run.displayTitle)\" and remove its files from disk. This cannot be undone.", "Smazat \"\(pendingDeletion.run.displayTitle)\" a odstranit soubory z disku. Tuto akci nelze vrátit.")),
                primaryButton: .destructive(Text(L10n.t("Delete Permanently", "Smazat trvale"))) {
                    deleteRun(pendingDeletion.run)
                },
                secondaryButton: .cancel()
            )
        }
        .alert(item: $deletionError) { deletionError in
            Alert(
                title: Text(L10n.t("Could Not Delete Orchestration", "Orchestraci se nepodařilo smazat")),
                message: Text(deletionError.message),
                dismissButton: .default(Text(L10n.t("OK", "OK")))
            )
        }
    }

    private func deleteRun(_ run: RunRecord) {
        do {
            try store.deleteRun(run)
        } catch {
            deletionError = RunDeletionErrorAlert(message: error.localizedDescription)
        }
    }
}

private struct SidebarBrandHeader: View {
    var body: some View {
        HStack(spacing: 10) {
            AppLogoView()
                .frame(width: 58, height: 39)

            VStack(alignment: .leading, spacing: 2) {
                Text("Orchestrator Console")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(L10n.t("Orchestration visualizer", "Vizualizace orchestrace"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

private struct PendingRunDeletion: Identifiable {
    let run: RunRecord

    var id: String {
        run.directoryURL.path
    }
}

private struct RunDeletionErrorAlert: Identifiable {
    let id = UUID()
    let message: String
}

private struct ProjectSwitcher: View {
    @ObservedObject var store: RunStore
    let addProject: () -> Void

    var body: some View {
        if store.workspaceProjects.isEmpty {
            EmptyProjectButton(addProject: addProject)
        } else {
            let projectDisplays = ProjectDisplayCatalog(projects: store.workspaceProjects)

            Menu {
                Section(L10n.t("Switch Project", "Přepnout projekt")) {
                    ForEach(store.workspaceProjects) { project in
                        let display = projectDisplays.display(for: project)
                        Button {
                            store.selectProject(project.id)
                        } label: {
                            Label(
                                display.menuTitle,
                                systemImage: project.id == store.selectedProjectId ? "checkmark.circle.fill" : "folder"
                            )
                        }
                    }
                }

                Divider()

                Button {
                    addProject()
                } label: {
                    Label(L10n.t("Add Project", "Přidat projekt"), systemImage: "folder.badge.plus")
                }

                Divider()

                if let selectedProject = store.selectedProject {
                    Button(
                        L10n.t("Forget Selected Project: \(projectDisplays.display(for: selectedProject).menuTitle)", "Zapomenout vybraný projekt: \(projectDisplays.display(for: selectedProject).menuTitle)"),
                        role: .destructive
                    ) {
                        store.forgetProject(selectedProject.id)
                    }
                }

                Menu(L10n.t("Forget Project", "Zapomenout projekt")) {
                    ForEach(store.workspaceProjects) { project in
                        Button(L10n.t("Forget \(projectDisplays.display(for: project).menuTitle)", "Zapomenout \(projectDisplays.display(for: project).menuTitle)"), role: .destructive) {
                            store.forgetProject(project.id)
                        }
                    }
                }
            } label: {
                if let selectedProject = store.selectedProject {
                    ProjectSwitcherLabel(project: selectedProject, display: projectDisplays.display(for: selectedProject))
                } else {
                    ProjectSwitcherPlaceholderLabel()
                }
            }
            .buttonStyle(.plain)
            .menuStyle(.button)
            .frame(maxWidth: .infinity, alignment: .leading)
            .help(L10n.t("Switch Project", "Přepnout projekt"))
        }
    }
}

private struct EmptyProjectButton: View {
    let addProject: () -> Void

    var body: some View {
        Button(action: addProject) {
            ProjectSwitcherChrome {
                Image(systemName: "folder.badge.plus")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.t("Add Project", "Přidat projekt"))
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(L10n.t("Choose a workspace", "Vyber workspace"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 8)
            }
        }
        .buttonStyle(.plain)
        .help(L10n.t("Add Project", "Přidat projekt"))
    }
}

private struct ProjectSwitcherLabel: View {
    let project: WorkspaceProject
    let display: ProjectDisplay

    var body: some View {
        ProjectSwitcherChrome {
            Image(systemName: "folder")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 2) {
                Text(project.name)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(display.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.up.chevron.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.tertiary)
                .frame(width: 12)
        }
    }
}

private struct ProjectSwitcherPlaceholderLabel: View {
    var body: some View {
        ProjectSwitcherChrome {
            Image(systemName: "folder")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 2) {
                Text(L10n.t("Select Project", "Vyber projekt"))
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(L10n.t("No project selected", "Není vybraný projekt"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.up.chevron.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.tertiary)
                .frame(width: 12)
        }
    }
}

private struct ProjectSwitcherChrome<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        HStack(spacing: 8) {
            content
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, minHeight: 34, alignment: .leading)
        .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .background {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color.secondary.opacity(0.07))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        }
    }
}

private struct ProjectDisplayCatalog {
    private let displaysById: [String: ProjectDisplay]

    init(projects: [WorkspaceProject]) {
        let projectsByName = Dictionary(grouping: projects, by: \.name)
        var displaysById: [String: ProjectDisplay] = [:]

        for project in projects {
            let matchingNameProjects = projectsByName[project.name] ?? []
            let parentContext = matchingNameProjects.count > 1
                ? Self.uniqueParentContext(for: project, among: matchingNameProjects)
                : nil

            displaysById[project.id] = ProjectDisplay(
                name: project.name,
                parentContext: parentContext,
                subtitle: Self.abbreviatedPath(project.path)
            )
        }

        self.displaysById = displaysById
    }

    func display(for project: WorkspaceProject) -> ProjectDisplay {
        displaysById[project.id] ?? ProjectDisplay(
            name: project.name,
            parentContext: nil,
            subtitle: Self.abbreviatedPath(project.path)
        )
    }

    private static func uniqueParentContext(for project: WorkspaceProject, among projects: [WorkspaceProject]) -> String {
        let parentComponents = displayParentComponents(for: project)
        let allParentComponents = projects.map(displayParentComponents)

        for componentCount in 1...max(parentComponents.count, 1) {
            let context = suffix(parentComponents, componentCount: componentCount)
            let matchingContextCount = allParentComponents.filter {
                suffix($0, componentCount: componentCount) == context
            }.count

            if matchingContextCount == 1 {
                return context
            }
        }

        return abbreviatedPath(project.url.deletingLastPathComponent().path)
    }

    private static func displayParentComponents(for project: WorkspaceProject) -> [String] {
        let parentURL = project.url.deletingLastPathComponent().standardizedFileURL
        let parentPath = parentURL.path
        let homePath = FileManager.default.homeDirectoryForCurrentUser.standardizedFileURL.path

        if parentPath == homePath {
            return ["~"]
        }

        let homePrefix = homePath.hasSuffix("/") ? homePath : "\(homePath)/"
        if parentPath.hasPrefix(homePrefix) {
            let relativePath = String(parentPath.dropFirst(homePrefix.count))
            let relativeComponents = relativePath.split(separator: "/").map(String.init)
            return ["~"] + relativeComponents
        }

        let absoluteComponents = parentURL.pathComponents.filter { $0 != "/" }
        return absoluteComponents.isEmpty ? [parentPath] : absoluteComponents
    }

    private static func suffix(_ components: [String], componentCount: Int) -> String {
        Array(components.suffix(componentCount)).joined(separator: "/")
    }

    private static func abbreviatedPath(_ path: String) -> String {
        let homePath = FileManager.default.homeDirectoryForCurrentUser.standardizedFileURL.path
        let homePrefix = homePath.hasSuffix("/") ? homePath : "\(homePath)/"

        if path == homePath {
            return "~"
        }

        if path.hasPrefix(homePrefix) {
            return "~/" + path.dropFirst(homePrefix.count)
        }

        return path
    }
}

private struct ProjectDisplay {
    let name: String
    let parentContext: String?
    let subtitle: String

    var menuTitle: String {
        guard let parentContext else { return name }
        return "\(name) - \(parentContext)"
    }
}

private struct RunRow: View {
    let run: RunRecord

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(run.status.tint)
                .frame(width: 7, height: 7)

            VStack(alignment: .leading, spacing: 1) {
                Text(run.displayTitle)
                    .font(.callout)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(run.status.label)
                    if let phase = run.currentPhase {
                        Text(phase.localizedTitle)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
        }
        .padding(.vertical, 2)
    }
}
