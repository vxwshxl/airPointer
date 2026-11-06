// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AirPointer",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "AirPointer", targets: ["AirPointer"]),
    ],
    targets: [
        // Pure, deterministic logic: pointer math, gesture + dwell detection, settings.
        .target(name: "AirPointerCore"),
        // The macOS app: CoreMotion, IOBluetooth, CGEvent synthesis, MediaPlayer, UI.
        .executableTarget(
            name: "AirPointer",
            dependencies: ["AirPointerCore"],
            linkerSettings: [
                .linkedFramework("IOBluetooth"),
                .linkedFramework("CoreMotion"),
                .linkedFramework("MediaPlayer"),
                .linkedFramework("Carbon"),
            ]
        ),
        .testTarget(name: "AirPointerCoreTests", dependencies: ["AirPointerCore"]),
        .testTarget(name: "AirPointerAppTests", dependencies: ["AirPointer"]),
    ],
    swiftLanguageModes: [.v5]
)
