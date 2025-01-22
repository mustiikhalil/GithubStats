import Foundation

final class LatestReleasesWorker {

  // MARK: Lifecycle

  init(
    token: String?,
    resolvedPackagePath: String,
    version: PackageVersion,
    fileManager: FileReader = FileManager.default,
    session: URLSessionProtocol = URLSession.shared)
  {
    self.token = token
    self.resolvedPackagePath = resolvedPackagePath
    self.version = version
    self.fileManager = fileManager
    networking = Networking(session: session)
  }

  // MARK: Internal

  func run() async throws -> [CombinedResponse] {
    guard let url = URL(string: resolvedPackagePath) else {
      throw Errors.invalidURL(str: resolvedPackagePath)
    }
    let data = try fileManager.read(url: url)
    switch version {
    case .v1:
      let decodedData = try decoder.decode(V1SwiftResolvedPackage.self, from: data)
      return try await fetchPackagesFrom(pins: decodedData.pins)
    case .v2:
      let decodedData = try decoder.decode(V2SwiftResolvedPackage.self, from: data)
      return try await fetchPackagesFrom(pins: decodedData.pins)
    }
  }

  // MARK: Private

  private lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  private let version: PackageVersion
  private let fileManager: FileReader
  private let token: String?
  private let resolvedPackagePath: String
  private let networking: Networking

  private func fetchPackagesFrom<T: Pin>(pins: [T]) async throws -> [CombinedResponse] {
    let token = token
    let networking = networking
    let decoder = decoder
    return try await withThrowingTaskGroup(
      of: CombinedResponse.self,
      returning: [CombinedResponse].self)
    { group in
      for pin in pins {
        group.addTask {
          try await
            pin.fetch(
              token: token,
              using: networking,
              decoder: decoder)
        }
      }

      var responses: [CombinedResponse] = []

      for try await response in group {
        responses.append(response)
      }

      return responses
    }
  }
}
