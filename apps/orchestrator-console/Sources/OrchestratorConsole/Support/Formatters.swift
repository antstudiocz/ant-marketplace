import Foundation
import OrchestratorConsoleCore
import SwiftUI

enum ConsoleFormatters {
    static func relativeDate() -> RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = AppLanguage.current.locale
        return formatter
    }

    static func localDateTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = AppLanguage.current.locale
        return formatter
    }

    static func relative(_ date: Date?) -> String {
        guard let date else { return L10n.t("No timestamp", "Bez času") }
        return relativeDate().localizedString(for: date, relativeTo: Date())
    }

    static func local(_ date: Date?) -> String {
        guard let date else { return L10n.t("No timestamp", "Bez času") }
        return localDateTime().string(from: date)
    }
}

enum L10n {
    static func t(_ en: String, _ cs: String) -> String {
        AppLanguage.current == .czech ? cs : en
    }
}

enum PhaseTitleLocalizer {
    static func title(for phase: Phase) -> String {
        let key = phase.id.lowercased()
        let title = phase.title.lowercased()

        if key.contains("intake") || title == "intake" {
            return L10n.t("Intake", "Zadání")
        }
        if key.contains("discovery") || title == "discovery" {
            return L10n.t("Discovery", "Průzkum")
        }
        if key.contains("direction") || title == "direction" {
            return L10n.t("Direction", "Směr")
        }
        if key.contains("planning") || title == "planning" {
            return L10n.t("Planning", "Plánování")
        }
        if key.contains("implementation") || title == "implementation" {
            return L10n.t("Implementation", "Implementace")
        }
        if key.contains("review") || title == "review" {
            return L10n.t("Review", "Kontrola")
        }
        if key.contains("verification") || title == "verification" || title == "validation" {
            return L10n.t("Verification", "Ověření")
        }
        if key.contains("delivery") || title == "delivery" {
            return L10n.t("Delivery", "Předání")
        }

        return phase.title
    }
}

extension Phase {
    var localizedTitle: String {
        PhaseTitleLocalizer.title(for: self)
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case czech = "cs-CZ"
    case english = "en"

    var id: String { rawValue }

    static let storageKey = "preferredLanguage"

    static var current: AppLanguage {
        let saved = UserDefaults.standard.string(forKey: storageKey) ?? ""
        return AppLanguage(rawValue: saved) ?? .czech
    }

    var locale: Locale {
        switch self {
        case .czech: return Locale(identifier: "cs_CZ")
        case .english: return Locale(identifier: "en")
        }
    }

    var label: String {
        switch self {
        case .czech: return "CZ"
        case .english: return "EN"
        }
    }
}

extension RunStatus {
    var label: String {
        switch self {
        case .notStarted: return L10n.t("Not started", "Nespuštěno")
        case .planning: return L10n.t("Planning", "Plánování")
        case .implementing: return L10n.t("Implementing", "Implementace")
        case .reviewing: return L10n.t("Reviewing", "Kontrola")
        case .verifying: return L10n.t("Verifying", "Ověřování")
        case .blocked: return L10n.t("Blocked", "Blokováno")
        case .paused: return L10n.t("Paused", "Pozastaveno")
        case .completed: return L10n.t("Completed", "Dokončeno")
        case .failed: return L10n.t("Failed", "Selhalo")
        case .cancelled: return L10n.t("Cancelled", "Zrušeno")
        case .unknown: return L10n.t("Unknown", "Neznámé")
        }
    }

    var tint: Color {
        switch self {
        case .completed: return .green
        case .blocked, .failed: return .red
        case .reviewing, .verifying: return .orange
        case .implementing: return .blue
        case .planning: return .purple
        case .paused, .cancelled, .notStarted, .unknown: return .secondary
        }
    }
}

extension PhaseStatus {
    var label: String {
        switch self {
        case .notStarted: return L10n.t("Not started", "Nespuštěno")
        case .inProgress: return L10n.t("In progress", "Probíhá")
        case .blocked: return L10n.t("Blocked", "Blokováno")
        case .needsReview: return L10n.t("Needs review", "Čeká na kontrolu")
        case .completed: return L10n.t("Completed", "Dokončeno")
        case .skipped: return L10n.t("Skipped", "Přeskočeno")
        case .failed: return L10n.t("Failed", "Selhalo")
        case .unknown: return L10n.t("Unknown", "Neznámé")
        }
    }

    var tint: Color {
        switch self {
        case .completed: return .green
        case .blocked, .failed: return .red
        case .needsReview: return .orange
        case .inProgress: return .blue
        case .notStarted, .skipped, .unknown: return .secondary
        }
    }
}

extension AgentStatus {
    var label: String {
        switch self {
        case .pending: return L10n.t("Pending", "Čeká")
        case .running: return L10n.t("Running", "Běží")
        case .blocked: return L10n.t("Blocked", "Blokováno")
        case .done: return L10n.t("Done", "Hotovo")
        case .failed: return L10n.t("Failed", "Selhalo")
        case .cancelled: return L10n.t("Cancelled", "Zrušeno")
        case .unknown: return L10n.t("Unknown", "Neznámé")
        }
    }

    var tint: Color {
        switch self {
        case .done: return .green
        case .running: return .blue
        case .blocked, .failed: return .red
        case .pending: return .orange
        case .cancelled, .unknown: return .secondary
        }
    }

    var systemImage: String {
        switch self {
        case .pending: return "clock.fill"
        case .running: return "play.circle.fill"
        case .blocked: return "exclamationmark.octagon.fill"
        case .done: return "checkmark.circle.fill"
        case .failed: return "xmark.octagon.fill"
        case .cancelled: return "slash.circle.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
}

extension Severity {
    var tint: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .error, .critical: return .red
        case .unknown: return .secondary
        }
    }
}

extension AgentRole {
    var label: String {
        switch self {
        case .rootOrchestrator: return L10n.t("Root orchestrator", "Root orchestrátor")
        case .planner: return L10n.t("Planner", "Plánovač")
        case .scout: return L10n.t("Scout", "Průzkum")
        case .planWriter: return L10n.t("Plan writer", "Autor plánu")
        case .implementationLead: return L10n.t("Implementation lead", "Vedoucí implementace")
        case .sliceWorker: return L10n.t("Slice worker", "Worker")
        case .reviewer: return L10n.t("Reviewer", "Kontrolor")
        case .unknown: return L10n.t("Unknown", "Neznámé")
        }
    }

    var tint: Color {
        switch self {
        case .rootOrchestrator: return .purple
        case .implementationLead: return .blue
        case .sliceWorker: return .teal
        case .scout: return .mint
        case .planner, .planWriter: return .orange
        case .reviewer: return .indigo
        case .unknown: return .secondary
        }
    }
}

enum LanguagePreference {
    static let storageKey = AppLanguage.storageKey

    static func normalized(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "_", with: "-")
    }

    static func displayName(for tag: String?) -> String {
        guard let tag, let language = AppLanguage(rawValue: tag) else { return AppLanguage.czech.label }
        return language.label
    }
}
