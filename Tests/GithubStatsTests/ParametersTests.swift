import XCTest
@testable import GithubStatsCore

final class ParametersTests: XCTestCase {
  func testGeneratingURL() {
    let token = "token"
    let params = Parameters(
      token: token,
      repository: "GithubStats",
      owner: "mustiikhalil",
      request: .workflowRun(withId: "1"),
      limit: 10,
      paginationLimit: 1)
    do {
      let urlRequest = try params.generateURLRequest(withPage: 0)
      XCTAssertEqual(
        urlRequest.url?.absoluteString,
        "https://api.github.com/repos/mustiikhalil/GithubStats/actions/workflows/1/runs?per_page=10&page=0")
      XCTAssertEqual(
        urlRequest.allHTTPHeaderFields?["Authorization"],
        "Bearer \(token)")

      let urlRequest1 = try params.generateURLRequest(withPage: 2)
      XCTAssertEqual(
        urlRequest1.url?.absoluteString,
        "https://api.github.com/repos/mustiikhalil/GithubStats/actions/workflows/1/runs?per_page=10&page=2")
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  func testGeneratingURLWithoutToken() {
    let params = Parameters(
      token: nil,
      repository: "GithubStats",
      owner: "mustiikhalil",
      request: .workflowRun(withId: "1"),
      limit: 10,
      paginationLimit: 1)
    do {
      let urlRequest = try params.generateURLRequest(withPage: 0)
      XCTAssertEqual(
        urlRequest.url?.absoluteString,
        "https://api.github.com/repos/mustiikhalil/GithubStats/actions/workflows/1/runs?per_page=10&page=0")
      XCTAssertEqual(
        urlRequest.allHTTPHeaderFields?["Authorization"],
        nil)

      let urlRequest1 = try params.generateURLRequest(withPage: 2)
      XCTAssertEqual(
        urlRequest1.url?.absoluteString,
        "https://api.github.com/repos/mustiikhalil/GithubStats/actions/workflows/1/runs?per_page=10&page=2")
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
}
