# XcodeCloudSnapshotTesting

This package includes a method, `ciAssertSnapshot`, that you can use
use as a drop-in replacement for `swift-snapshot-testing`’s
`assertSnapshot`.

Unlike the original, the replacement places the snapshots in a place
where Xcode Cloud can find them.

It transitively exports `SnapshotTesting`, so you don’t need to explicitly
import `swift-snapshot-testing` in your `Package.swift`.
