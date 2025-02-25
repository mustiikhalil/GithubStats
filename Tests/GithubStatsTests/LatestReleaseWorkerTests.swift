//
//  LatestReleaseWorkerTests.swift
//  GithubStats
//
//  Created by Streaming on 2025-02-25.
//

import Foundation
import Testing
@testable import GithubStatsCore

@Suite
struct LatestReleaseWorker {

  // MARK: Internal

  @Test
  func workerV1() async throws {
    try await runWorker(str: packageV1, version: .v1)
  }

  @Test
  func workerV2() async throws {
    try await runWorker(str: packageV2, version: .v2)
  }

  @Test
  func workerV3() async throws {
    try await runWorker(str: packageV3, version: .v3)
  }

  @Test
  func workerGitLab() async throws {
    try await runWorker(str: packageWithGitlab, version: .v2)
  }

  // MARK: Private

  private func runWorker(
    str: String,
    version: PackageVersion = .v1) async throws
  {
    let reader = FileReaderMock()
    reader.data = str.data(using: .utf8)!
    let session = MockSession()
    session.data = "[{\"ref\": \"reference\", \"object\": {\"sha\": \"sha\"}}]".data(using: .utf8)!

    session.statusCode = 200
    let worker = LatestReleasesWorker(
      token: nil,
      resolvedPackagePath: "/user/project/package.resolved",
      version: version,
      fileManager: reader,
      session: session)
    let response = try await worker.run()
    #expect(response.count == 3)
  }
}

private final class FileReaderMock: FileReader {
  var data: Data!

  func read(url _: URL) throws -> Data {
    data
  }
}
