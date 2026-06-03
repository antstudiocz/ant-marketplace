import OrchestratorConsoleCore
import SwiftUI

struct CodePreviewView: View {
    let preview: ArtifactPreview
    var searchText: String = ""

    private var lines: [String] {
        preview.content.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.tertiary)
                            .frame(width: lineNumberWidth, alignment: .trailing)
                            .textSelection(.disabled)

                        Text(CodeSyntaxHighlighter.highlighted(line, artifact: preview.artifact, searchText: searchText))
                            .font(.system(.body, design: .monospaced))
                            .textSelection(.enabled)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .padding(.vertical, 1)
                    .padding(.horizontal, 14)
                    .background(index.isMultiple(of: 2) ? Color.secondary.opacity(0.025) : Color.clear)
                }
            }
            .padding(.vertical, 12)
            .frame(minWidth: 520, alignment: .topLeading)
        }
        .background(Color(nsColor: .textBackgroundColor))
    }

    private var lineNumberWidth: CGFloat {
        CGFloat(max(2, String(lines.count).count)) * 8 + 10
    }
}

private enum CodeSyntaxHighlighter {
    static func highlighted(_ line: String, artifact: Artifact, searchText: String) -> AttributedString {
        var result = AttributedString(line.isEmpty ? " " : line)
        result.foregroundColor = .primary

        applyStringRanges(in: line, to: &result)
        applyKeywordRanges(in: line, artifact: artifact, to: &result)
        applyCommentRange(in: line, artifact: artifact, to: &result)
        applySearchRanges(in: line, searchText: searchText, to: &result)

        return result
    }

    private static func applyStringRanges(in line: String, to result: inout AttributedString) {
        var index = line.startIndex
        while index < line.endIndex {
            guard line[index] == "\"" else {
                index = line.index(after: index)
                continue
            }

            let start = index
            index = line.index(after: index)
            var escaped = false
            while index < line.endIndex {
                let character = line[index]
                if character == "\"" && !escaped {
                    index = line.index(after: index)
                    break
                }
                escaped = character == "\\" && !escaped
                if character != "\\" {
                    escaped = false
                }
                index = line.index(after: index)
            }
            apply(.purple, to: start..<index, in: line, result: &result)
        }
    }

    private static func applyKeywordRanges(in line: String, artifact: Artifact, to result: inout AttributedString) {
        let keywords = keywords(for: artifact)
        guard !keywords.isEmpty else { return }

        var tokenStart: String.Index?
        var index = line.startIndex
        while index <= line.endIndex {
            let isTokenCharacter = index < line.endIndex && (line[index].isLetter || line[index].isNumber || line[index] == "_")
            if isTokenCharacter {
                if tokenStart == nil {
                    tokenStart = index
                }
            } else if let start = tokenStart {
                let token = String(line[start..<index])
                if keywords.contains(token) {
                    apply(.blue, to: start..<index, in: line, result: &result, weight: .semibold)
                }
                tokenStart = nil
            }

            if index == line.endIndex { break }
            index = line.index(after: index)
        }
    }

    private static func applyCommentRange(in line: String, artifact: Artifact, to result: inout AttributedString) {
        let marker: String?
        switch language(for: artifact) {
        case .shell, .yaml, .toml:
            marker = "#"
        case .swift, .javascript, .css:
            marker = "//"
        case .json, .plain:
            marker = nil
        }

        guard let marker, let range = line.range(of: marker) else { return }
        apply(.secondary, to: range.lowerBound..<line.endIndex, in: line, result: &result)
    }

    private static func applySearchRanges(in line: String, searchText: String, to result: inout AttributedString) {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }

        var searchStart = line.startIndex
        while searchStart < line.endIndex,
              let range = line.range(of: query, options: [.caseInsensitive], range: searchStart..<line.endIndex) {
            apply(.primary, to: range, in: line, result: &result, background: Color.accentColor.opacity(0.22))
            searchStart = range.upperBound
        }
    }

    private static func apply(
        _ color: Color,
        to range: Range<String.Index>,
        in source: String,
        result: inout AttributedString,
        weight: Font.Weight? = nil,
        background: Color? = nil
    ) {
        guard let lower = AttributedString.Index(range.lowerBound, within: result),
              let upper = AttributedString.Index(range.upperBound, within: result) else {
            return
        }

        result[lower..<upper].foregroundColor = color
        if let weight {
            result[lower..<upper].font = .system(.body, design: .monospaced).weight(weight)
        }
        if let background {
            result[lower..<upper].backgroundColor = background
        }
    }

    private static func keywords(for artifact: Artifact) -> Set<String> {
        switch language(for: artifact) {
        case .swift:
            return ["actor", "as", "await", "case", "catch", "class", "enum", "false", "for", "func", "guard", "if", "import", "in", "let", "nil", "private", "public", "return", "self", "static", "struct", "switch", "throw", "throws", "true", "try", "var"]
        case .shell:
            return ["case", "cd", "do", "done", "elif", "else", "esac", "export", "fi", "for", "function", "if", "in", "local", "set", "then", "while"]
        case .javascript:
            return ["async", "await", "case", "catch", "class", "const", "else", "export", "false", "for", "function", "if", "import", "let", "new", "null", "return", "switch", "throw", "true", "try", "undefined", "var"]
        case .json:
            return ["true", "false", "null"]
        case .css, .toml, .yaml, .plain:
            return []
        }
    }

    private static func language(for artifact: Artifact) -> CodeLanguage {
        let ext = URL(fileURLWithPath: artifact.path).pathExtension.lowercased()
        switch ext {
        case "swift": return .swift
        case "sh", "bash", "zsh": return .shell
        case "js", "jsx", "ts", "tsx": return .javascript
        case "json", "jsonl", "schema": return .json
        case "css", "scss": return .css
        case "toml": return .toml
        case "yaml", "yml": return .yaml
        default: return .plain
        }
    }
}

private enum CodeLanguage {
    case swift
    case shell
    case javascript
    case json
    case css
    case toml
    case yaml
    case plain
}
