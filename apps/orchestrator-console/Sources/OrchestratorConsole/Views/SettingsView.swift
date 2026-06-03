import OrchestratorConsoleCore
import SwiftUI

struct SettingsView: View {
    @AppStorage("workspaceProjectsJSON") private var workspaceProjectsJSON = ""
    @AppStorage("lastWorkspacePath") private var lastWorkspacePath = ""
    @AppStorage(LanguagePreference.storageKey) private var preferredLanguage = AppLanguage.czech.rawValue

    private var projectList: WorkspaceProjectList {
        WorkspaceProjectPersistence.load(
            savedJSON: workspaceProjectsJSON,
            legacyLastWorkspacePath: lastWorkspacePath
        )
    }

    private var selectedProject: WorkspaceProject? {
        projectList.projects.first { $0.id == projectList.selectedProjectId }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            SettingsHeader()

            VStack(alignment: .leading, spacing: 12) {
                SettingsCard(
                    title: L10n.t("Language", "Jazyk"),
                    subtitle: L10n.t("UI language", "Jazyk rozhraní"),
                    systemImage: "globe"
                ) {
                    Picker(L10n.t("Language", "Jazyk"), selection: languageBinding) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.label).tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .frame(width: 112)
                }

                SettingsCard(
                    title: L10n.t("Projects", "Projekty"),
                    subtitle: L10n.t("Saved workspaces", "Uložené workspace"),
                    systemImage: "folder"
                ) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(projectList.projects.count)")
                            .font(.headline.weight(.semibold))
                        if let selectedProject {
                            Text(selectedProject.name)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        } else {
                            Text(L10n.t("No current project", "Žádný aktuální projekt"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: 180, alignment: .trailing)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(22)
        .frame(width: 480, height: 270, alignment: .topLeading)
        .onAppear {
            if AppLanguage(rawValue: preferredLanguage) == nil {
                preferredLanguage = AppLanguage.czech.rawValue
            }
        }
    }

    private var languageBinding: Binding<AppLanguage> {
        Binding(
            get: { AppLanguage(rawValue: preferredLanguage) ?? .czech },
            set: { preferredLanguage = $0.rawValue }
        )
    }
}

private struct SettingsHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Orchestrator Console")
                .font(.title3.weight(.semibold))
            Text(L10n.t("Preferences for local orchestration runs.", "Nastavení pro lokální orchestrace."))
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }
}

private struct SettingsCard<Trailing: View>: View {
    let title: String
    let subtitle: String
    let systemImage: String
    @ViewBuilder var trailing: Trailing

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.accentColor)
                .frame(width: 28, height: 28)
                .background(Color.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 7, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.callout.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            trailing
        }
        .padding(12)
        .background(Color.secondary.opacity(0.055), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        }
    }
}
