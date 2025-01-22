import XCTest

@testable import GithubStatsCore

final class MockSession: @unchecked Sendable, URLSessionProtocol {
  var data: Data!
  var statusCode: Int!

  func dataAndStatusCode(for _: URLRequest) async throws -> (Data, Int) {
    (data, statusCode)
  }
}
