import XCTest

@testable import GithubStatsCore

final class GithubStatisticsTests: XCTestCase {

  func testStatisticsFailureRun() {
    let responses = GithubActionResponses(responses: [])
    let statistics = GithubStatistics(response: responses)
    XCTAssertThrowsError(try statistics.run(), "Throws emptyResponse Error")
  }

  func testStatisticsRun() {
    let totalCount = 9
    let newest = Date(timeIntervalSince1970: 100_000_000)
    let oldest = Date(timeIntervalSince1970: 0)
    let responses = GithubActionResponses(
      responses: [
        GithubActionResponse(
          totalCount: totalCount,
          workflowRuns: [
            WorkFlow(
              name: "CI-job",
              path: "some.yml",
              conclusion: .success,
              runStartedAt: oldest,
              createdAt: oldest,
              updatedAt: oldest.adding(timeInternal: 1000000)),
            WorkFlow(
              name: "CI-job",
              path: "some.yml",
              conclusion: .success,
              runStartedAt: oldest,
              createdAt: oldest,
              updatedAt: oldest.adding(timeInternal: 1000000)),
            WorkFlow(
              name: "CI-job",
              path: "some.yml",
              conclusion: .failure,
              runStartedAt: oldest,
              createdAt: oldest,
              updatedAt: oldest.adding(timeInternal: 1000)),
            WorkFlow(
              name: "CI-job",
              path: "some.yml",
              conclusion: .cancelled,
              runStartedAt: oldest,
              createdAt: oldest,
              updatedAt: oldest.adding(timeInternal: 1000)),
            WorkFlow(
              name: "CI-job",
              path: "some.yml",
              conclusion: .inProgress,
              runStartedAt: oldest,
              createdAt: oldest,
              updatedAt: oldest.adding(timeInternal: 10000)),
          ]),
        GithubActionResponse(
          totalCount: totalCount,
          workflowRuns: [
            WorkFlow(
              name: "CI-job",
              path: "some.yml",
              conclusion: .success,
              runStartedAt: oldest,
              createdAt: oldest,
              updatedAt: oldest.adding(timeInternal: 900000)),
            WorkFlow(
              name: "CI-job",
              path: "some.yml",
              conclusion: .success,
              runStartedAt: oldest,
              createdAt: oldest,
              updatedAt: oldest.adding(timeInternal: 900000)),
            WorkFlow(
              name: "CI-job",
              path: "some.yml",
              conclusion: .success,
              runStartedAt: oldest,
              createdAt: oldest,
              updatedAt: oldest.adding(timeInternal: 800000)),
            WorkFlow(
              name: "CI-job",
              path: "some.yml",
              conclusion: .success,
              runStartedAt: newest,
              createdAt: newest,
              updatedAt: newest.adding(timeInternal: 1000000)),
          ])
      ])
    let statistics = GithubStatistics(response: responses)
    do {
      let statistics = try statistics.run()
      XCTAssertEqual(statistics.name, "some.yml")
      XCTAssertEqual(statistics.workflowCount, 9)
      XCTAssertEqual(statistics.totalRuns, 9)
      XCTAssertEqual(statistics.averageTime, 5612000.0)
      XCTAssertEqual(statistics.startDate, oldest)
      XCTAssertEqual(statistics.endDate, newest)
      XCTAssertEqual(statistics.statuses[.inProgress]?.totalRunningTime, 10000.0)
      XCTAssertEqual(statistics.statuses[.inProgress]?.count, 1)
      XCTAssertEqual(statistics.statuses[.success]?.totalRunningTime, 5600000.0)
      XCTAssertEqual(statistics.statuses[.success]?.count, 6)
      XCTAssertEqual(statistics.statuses[.failure]?.totalRunningTime, 1000.0)
      XCTAssertEqual(statistics.statuses[.failure]?.count, 1)
      XCTAssertEqual(statistics.statuses[.cancelled]?.totalRunningTime, 1000.0)
      XCTAssertEqual(statistics.statuses[.cancelled]?.count, 1)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

}

extension Date {
  fileprivate func adding(timeInternal: TimeInterval) -> Date {
    Date(timeIntervalSince1970: timeIntervalSince1970 + timeInternal)
  }
}
