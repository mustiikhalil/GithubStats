import XCTest

@testable import GithubActionsStatsCore

final class MockSession: URLSessionProtocol {

  var data: Data!
  var statusCode: Int!

  func dataAndStatusCode(for: URLRequest) async throws -> (Data, Int) {
    (data, statusCode)
  }
}
