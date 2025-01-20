import ArgumentParser
import Foundation
import GithubStatsCore

struct LatestReleasesCommand: ParsableCommand, AsyncParsableCommand {
  static var configuration: CommandConfiguration {
    CommandConfiguration(commandName: "latest-release")
  }

  @Argument(help: "Bearer Token that has access to the repository")
  var token: String

  @Argument(help: "Path to the resolved file")
  var resolvedPackage: String

  @Argument(help: "Package Version to be parsed")
  var version: PackageVersion?

  func run() async throws {
    let latestRelease = LatestReleases(
      token: token,
      resolvedPackagePath: resolvedPackage,
      version: version ?? .v2)
    let data = try await latestRelease.run()
    let printer = ColorfulPrinter()
    printer.printSummary(for: data)
  }
}

extension PackageVersion: ExpressibleByArgument {
  public init?(argument: String) {
    self.init(rawValue: argument)
  }
}
