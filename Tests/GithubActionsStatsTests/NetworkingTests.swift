import XCTest

@testable import GithubActionsStatsCore

final class NetworkingTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    url = URLRequest(
      url: URL(
        string: "https://github.com")!)
    session = MockSession()
    networking = Networking(session: session)
  }

  func testReturningData() async {
    session.data = Data([1] as [UInt8])
    session.statusCode = 200
    do {
      let data = try await networking.fetch(
        urlRequest: url)
      XCTAssertEqual(data, session.data)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  func testReturning400() async {
    session.data = Data([1] as [UInt8])
    session.statusCode = 400
    do {
      _ = try await networking.fetch(
        urlRequest: url)
      XCTFail("Test should fail")
    } catch {
      let err = error as? Errors
      XCTAssertNotNil(err)
    }
  }

  // MARK: Private

  private var url: URLRequest!
  private var networking: Networking!
  private var session: MockSession!
}
