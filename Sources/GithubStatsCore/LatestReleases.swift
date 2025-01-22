import Foundation

public enum PackageVersion: String {
  case v1, v2
}

public struct LatestReleases {
  // MARK: Lifecycle

  public init(
    token: String? = nil,
    resolvedPackagePath: String,
    version: PackageVersion)
  {
    worker = LatestReleasesWorker(
      token: token,
      resolvedPackagePath: resolvedPackagePath,
      version: version)
  }

  public func run() async throws -> [CombinedResponse] {
    try await worker.run()
  }

  private let worker: LatestReleasesWorker
}
