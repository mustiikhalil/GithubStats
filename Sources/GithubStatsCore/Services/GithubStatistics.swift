import Foundation

struct GithubStatistics {

  // MARK: Lifecycle

  init(response: GithubActionResponses) {
    self.response = response
  }

  // MARK: Internal

  func run() throws -> Statistics {
    let workflows = response.responses
      .flatMap { response in
        response.workflowRuns
      }
      .filter { workflow in
        workflow.conclusion != nil
      }
    guard !response.responses.isEmpty else {
      throw Errors.emptyResponse
    }
    var totalRuns = 0.0
    var statuses: [Status: StatusStats] = [:]
    var totalTime: TimeInterval = 0
    for workflow in workflows {
      totalRuns += 1
      let diff = workflow.updatedAt.timeIntervalSince1970 - workflow.runStartedAt.timeIntervalSince1970
      totalTime += diff
      if let status = workflow.conclusion {
        statuses[status, default: StatusStats(count: 0, totalRunningTime: 0)] +=
          StatusStats(count: 1, totalRunningTime: diff)
      }
    }

    return Statistics(
      name: workflows.first!.path,
      workflowCount: workflows.count,
      startDate: workflows.first!.createdAt,
      endDate: workflows.last!.createdAt,
      statuses: statuses,
      averageTime: totalTime,
      totalRuns: totalRuns)
  }

  // MARK: Private

  private let response: GithubActionResponses

}
