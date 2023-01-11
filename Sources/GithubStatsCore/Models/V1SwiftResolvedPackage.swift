import Foundation

struct V1SwiftResolvedPackage: Decodable {
  enum CodingKeys: CodingKey {
    case object
    case version
  }

  enum NestedCodingKeys: CodingKey {
    case pins
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let pins = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .object)
    self.pins = try pins.decode([V1Packages].self, forKey: .pins)
    version = try container.decode(Int.self, forKey: .version)
  }
  let pins: [V1Packages]
  let version: Int

}

struct V1Packages: Decodable {
  let package: String
  let repositoryURL: URL
  let state: V1State
}

extension V1Packages: Pin {

  var tag: String? {
    state.version
  }

  var name: String {
    repositoryURL.repository
  }

  var owner: String {
    repositoryURL.owner
  }

  var sha: String? {
    state.revision
  }

  var hasVersion: Bool {
    state.hasVersion
  }

  func fetch(
    token: String,
    using networking: Networking,
    decoder: JSONDecoder)
    async throws -> GithubRepositoryResponseProtocol
  {
    if state.hasVersion {
      let request = try state.generateURL(token: token, url: repositoryURL)
      let data = try await networking.fetch(urlRequest: request)
      let values = try decoder
        .decode([FailableDecodable<GithubReleaseResponse>].self, from: data)
        .compactMap { $0.value }
        .filter { $0.tag != nil }
        .sorted(by: { r1, r2 in
          r1.tag?.compare(r2.tag ?? "", options: .numeric) == .orderedAscending
        })
      return values.last!
    } else {
      let request = try state.generateURL(token: token, url: repositoryURL)
      let data = try await networking.fetch(urlRequest: request)
      return try decoder.decode([GithubCommitResponse].self, from: data).first!
    }
  }
}

struct V1State: Decodable {
  let branch: String?
  let revision: String?
  let version: String?

  var hasVersion: Bool {
    version != nil
  }

  func generateURL(token: String, url: URL) throws -> URLRequest {
    let params = Parameters(
      token: token,
      url: url,
      request: hasVersion ? .latestRelease : .latestCommit,
      branch: branch)
    return try params.generateURLRequest(withPage: 1)
  }
}
