import AppKit
import SwiftUI

@main
struct OrchestratorConsoleApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup("Orchestrator Console") {
            ContentView()
                .frame(minWidth: 1120, minHeight: 720)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button(L10n.t("Open Project...", "Otevřít projekt...")) {
                    NotificationCenter.default.post(name: AppCommandNotifications.openProject, object: nil)
                }
                .keyboardShortcut("o", modifiers: [.command])
            }

            CommandMenu("Orchestrator") {
                Button(L10n.t("Reload Runs", "Obnovit běhy")) {
                    NotificationCenter.default.post(name: AppCommandNotifications.reload, object: nil)
                }
                .keyboardShortcut("r", modifiers: [.command])

                Button(L10n.t("Reveal Workspace", "Ukázat workspace")) {
                    NotificationCenter.default.post(name: AppCommandNotifications.revealWorkspace, object: nil)
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])
            }
        }

        Settings {
            SettingsView()
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}
