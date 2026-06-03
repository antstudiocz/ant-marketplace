import AppKit
import OrchestratorConsoleCore
import SwiftUI

struct ContentView: View {
    @StateObject private var store = RunStore()
    @AppStorage("workspaceProjectsJSON") private var workspaceProjectsJSON = ""
    @AppStorage("lastWorkspacePath") private var lastWorkspacePath = ""
    @AppStorage(LanguagePreference.storageKey) private var preferredLanguage = AppLanguage.czech.rawValue
    @State private var didRestoreWorkspaces = false

    var body: some View {
        NavigationSplitView {
            SidebarView(store: store, addProject: chooseWorkspace)
                .navigationSplitViewColumnWidth(min: 260, ideal: 320, max: 420)
        } detail: {
            DetailRootView(store: store, chooseWorkspace: chooseWorkspace)
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    chooseWorkspace()
                } label: {
                    Label(L10n.t("Add Project", "Přidat projekt"), systemImage: "folder.badge.plus")
                }
                .help(L10n.t("Add Project", "Přidat projekt"))
                .keyboardShortcut("o", modifiers: [.command])

                Button {
                    store.reload()
                } label: {
                    Label(L10n.t("Reload", "Obnovit"), systemImage: "arrow.clockwise")
                }
                .disabled(store.workspaceURL == nil)
                .help(L10n.t("Reload", "Obnovit"))
                .keyboardShortcut("r", modifiers: [.command])

                Button {
                    store.revealWorkspace()
                } label: {
                    Label(L10n.t("Reveal", "Ukázat"), systemImage: "arrow.up.forward.app")
                }
                .disabled(store.workspaceURL == nil)
                .help(L10n.t("Reveal Workspace", "Ukázat workspace"))
                .keyboardShortcut("r", modifiers: [.command, .shift])
            }
        }
        .id(preferredLanguage)
        .onAppear {
            restoreWorkspacesIfNeeded()
        }
        .onChange(of: store.workspaceProjects) { _, _ in
            persistWorkspaces()
        }
        .onChange(of: store.selectedProjectId) { _, _ in
            persistWorkspaces()
        }
        .onReceive(NotificationCenter.default.publisher(for: AppCommandNotifications.openProject)) { _ in
            chooseWorkspace()
        }
        .onReceive(NotificationCenter.default.publisher(for: AppCommandNotifications.reload)) { _ in
            store.reload()
        }
        .onReceive(NotificationCenter.default.publisher(for: AppCommandNotifications.revealWorkspace)) { _ in
            store.revealWorkspace()
        }
    }

    private func chooseWorkspace() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = L10n.t("Open", "Otevřít")
        panel.directoryURL = store.workspaceURL
        if panel.runModal() == .OK, let url = panel.url {
            store.addOrSelectWorkspace(url)
        }
    }

    private func restoreWorkspacesIfNeeded() {
        guard !didRestoreWorkspaces else { return }
        let list = WorkspaceProjectPersistence.load(
            savedJSON: workspaceProjectsJSON,
            legacyLastWorkspacePath: lastWorkspacePath
        )
        store.configureWorkspaces(list.projects, selectedProjectId: list.selectedProjectId)
        didRestoreWorkspaces = true
        persistWorkspaces()
    }

    private func persistWorkspaces() {
        guard didRestoreWorkspaces else { return }
        let list = WorkspaceProjectList(
            projects: store.workspaceProjects,
            selectedProjectId: store.selectedProjectId
        )
        if let encoded = try? WorkspaceProjectPersistence.encode(list) {
            workspaceProjectsJSON = encoded
        }
        lastWorkspacePath = store.workspaceURL?.path ?? ""
    }
}

private struct DetailRootView: View {
    @ObservedObject var store: RunStore
    let chooseWorkspace: () -> Void

    var body: some View {
        if store.workspaceURL == nil {
            EmptyWorkspaceView(chooseWorkspace: chooseWorkspace)
        } else if let run = store.selectedRun {
            RunDetailView(run: run, store: store)
        } else {
            NoRunsView(errorMessage: store.errorMessage)
        }
    }
}

private struct EmptyWorkspaceView: View {
    let chooseWorkspace: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            AppLogoView()
                .frame(width: 220, height: 146)
            Text("Orchestrator Console")
                .font(.title)
                .fontWeight(.semibold)
            Button {
                chooseWorkspace()
            } label: {
                Label(L10n.t("Add Project", "Přidat projekt"), systemImage: "folder.badge.plus")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct NoRunsView: View {
    let errorMessage: String?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text(errorMessage ?? L10n.t("No orchestration runs", "Žádné běhy orchestrátoru"))
                .font(.headline)
                .foregroundStyle(errorMessage == nil ? Color.primary : Color.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
