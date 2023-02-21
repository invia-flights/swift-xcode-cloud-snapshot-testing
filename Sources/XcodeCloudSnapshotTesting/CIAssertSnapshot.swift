import Foundation
@_exported import SnapshotTesting
import XCTest

/// Returns a valid snapshot directory under the project’s `ci_scripts`.
///
/// - Parameter file: A `StaticString` representing the current test’s filename.
/// - Returns: A directory for the snapshots.
/// - Note: It makes strong assumptions about the structure of the project; namely,
///   it expects the project to consist of a single package located at the root.
func snapshotDirectory(
	for file: StaticString,
	testsPathComponent: String = "Tests",
	packagesPathComponent: String = "Packages",
	ciScriptsPathComponent: String = "ci_scripts",
	snapshotsPathComponent: String = "__Snapshots__"
) -> String {
	let fileURL = URL(fileURLWithPath: "\(file)", isDirectory: false)

	let packageRootPath = fileURL
		.pathComponents
		.prefix(while: { $0 != testsPathComponent && $0 != packagesPathComponent })

	let testsPath = packageRootPath + [testsPathComponent]

	let relativePath = fileURL
		.deletingPathExtension()
		.pathComponents
		.dropFirst(testsPath.count)

	let snapshotDirectoryPath = packageRootPath + [ciScriptsPathComponent, snapshotsPathComponent] +
		relativePath
	return snapshotDirectoryPath.joined(separator: "/")
}

/// Asserts that a given value matches references on disk.
///
/// - Parameters:
///   - value: A value to compare against a reference.
///   - snapshotting: An array of strategies for serializing, deserializing, and comparing values.
///   - recording: Whether or not to record a new reference.
///   - timeout: The amount of time a snapshot must be generated in.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in
/// which this function was called.
///   - testName: The name of the test in which failure occurred. Defaults to the function name of
/// the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this
/// function was called.
///   - testsPathComponent: The name of the tests directory. Defaults to “Tests”.
@MainActor
public func ciAssertSnapshot<Value>(
	matching value: @autoclosure () throws -> Value,
	as snapshotting: Snapshotting<Value, some Any>,
	named name: String? = nil,
	record recording: Bool = false,
	timeout: TimeInterval = 5,
	file: StaticString = #file,
	testName: String = #function,
	line: UInt = #line,
	testsPathComponent: String = "Tests"
) {
	let failure = verifySnapshot(
		matching: try value(),
		as: snapshotting,
		named: name,
		record: recording,
		snapshotDirectory: snapshotDirectory(for: file, testsPathComponent: testsPathComponent),
		timeout: timeout,
		file: file,
		testName: testName
	)

	guard let message = failure else { return }
	XCTFail(message, file: file, line: line)
}
