import SwiftUI

struct AppLogoView: View {
    var body: some View {
        Image("orchestrator-logo-transparent", bundle: .module)
            .resizable()
            .interpolation(.high)
            .scaledToFit()
            .accessibilityLabel("Orchestrator Console")
    }
}
