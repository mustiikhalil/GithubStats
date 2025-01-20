import XCTest

@testable import GithubStatsCore

final class MockSession: URLSessionProtocol {
  var data: Data!
  var statusCode: Int!

  func dataAndStatusCode(for _: URLRequest) async throws -> (Data, Int) {
    (data, statusCode)
  }
}
