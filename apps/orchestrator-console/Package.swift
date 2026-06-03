// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "OrchestratorConsole",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "OrchestratorConsole", targets: ["OrchestratorConsole"])
    ],
    targets: [
        .target(
            name: "OrchestratorConsoleCore",
            path: "Sources/OrchestratorConsoleCore"
        ),
        .executableTarget(
            name: "OrchestratorConsole",
            dependencies: ["OrchestratorConsoleCore"],
            path: "Sources/OrchestratorConsole",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "OrchestratorConsoleCoreTests",
            dependencies: ["OrchestratorConsoleCore"],
            path: "Tests/OrchestratorConsoleCoreTests"
        )
    ]
)
