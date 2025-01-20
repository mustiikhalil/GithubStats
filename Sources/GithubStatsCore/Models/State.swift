import Foundation

struct State: Decodable {
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
