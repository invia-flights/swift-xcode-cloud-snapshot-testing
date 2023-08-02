// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodeCloudSnapshotTesting",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "XcodeCloudSnapshotTesting",
            targets: ["XcodeCloudSnapshotTesting"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.11.1"),
    ],
    targets: [
        .target(
            name: "XcodeCloudSnapshotTesting",
			dependencies: [.product(name: "SnapshotTesting", package: "swift-snapshot-testing")]),
        .testTarget(
            name: "XcodeCloudSnapshotTestingTests",
            dependencies: ["XcodeCloudSnapshotTesting"]),
    ]
)
