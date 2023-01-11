import ArgumentParser
import Foundation
import GithubStatsCore

@main
struct GithubStats: ParsableCommand, AsyncParsableCommand {

  static var configuration: CommandConfiguration {
    CommandConfiguration(
      commandName: "github-actions-stats",
      subcommands: [
        WorkflowsCommand.self,
        LatestReleasesCommand.self
      ])
  }

}
