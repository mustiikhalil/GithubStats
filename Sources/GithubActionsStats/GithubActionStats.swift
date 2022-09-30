import ArgumentParser
import Foundation
import GithubActionsStatsCore

@main
struct GithubActionsStats: ParsableCommand, AsyncParsableCommand {

  static var configuration: CommandConfiguration {
    CommandConfiguration(commandName: "github-actions-stats")
  }

  @Argument(help: "Bearer Token that has access to the repository")
  var token: String

  @Argument(help: "The account owner of the repository. The name is not case sensitive.")
  var owner: String

  @Argument(help: "The name of the repository. The name is not case sensitive.")
  var repository: String

  @Argument(
    help: "The ID of the workflow. You can also pass the workflow file name as a string.")
  var workflow: String

  @Option(
    name: .shortAndLong,
    help: "The number of results per page (max 100).")
  var limit: Int = 30

  @Option(
    name: .shortAndLong,
    help: "Page number of the results to fetch.")
  var paginationLimit: Int = 1

  @Option(
    name: .shortAndLong,
    help: """
    Returns workflow runs created within the given date-time range check:
    https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax#query-for-dates
    """)
  var since: String?

  func run() async throws {
    let parameters = Parameters(
      token: token,
      repository: repository,
      owner: owner,
      workflowId: workflow,
      limit: limit,
      paginationLimit: paginationLimit,
      since: since)

    var githubActionCore = GithubActionsStatsCore(
      parameters: parameters)
    try await githubActionCore.run()
  }

}
