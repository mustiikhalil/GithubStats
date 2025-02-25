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
    let networking = Networking(session: session)
    registeredServices = [
      GithubWorkerService(service: networking)
    ]
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
    case .v3:
      let decodedData = try decoder.decode(V3SwiftResolvedPackage.self, from: data)
      return try await fetchPackagesFrom(pins: decodedData.pins)
    }
  }

  // MARK: Private

  private let version: PackageVersion
  private let fileManager: FileReader
  private let token: String?
  private let resolvedPackagePath: String
  private let registeredServices: [PackageProviderService]
  private let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  private func fetchPackagesFrom<T: DecodablePin>(
    pins: [T]) async throws
    -> [CombinedResponse]
  {
    let token = token
    return try await withThrowingTaskGroup(
      of: [CombinedResponse].self,
      returning: [CombinedResponse].self)
    { group in
      for registeredService in registeredServices {
        group.addTask {
          try await registeredService.fetchPackagesFrom(pins: pins, token: token)
        }
      }
      var responses: [CombinedResponse] = []

      for try await response in group {
        responses.append(contentsOf: response)
      }

      return responses
    }
  }
}
