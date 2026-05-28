import AppKit
import SwiftUI

extension View {
    func badgePointerCursor() -> some View {
        modifier(BadgePointerCursorModifier())
    }
}

private struct BadgePointerCursorModifier: ViewModifier {
    @State private var didPushCursor = false

    func body(content: Content) -> some View {
        content
            .onHover { isHovering in
                if isHovering, !didPushCursor {
                    NSCursor.pointingHand.push()
                    didPushCursor = true
                } else if !isHovering, didPushCursor {
                    NSCursor.pop()
                    didPushCursor = false
                }
            }
            .onDisappear {
                if didPushCursor {
                    NSCursor.pop()
                    didPushCursor = false
                }
            }
    }
}
