import Foundation

public enum Request: Equatable {
  case workflowRun(withId: String)
  case latestRelease
  case latestCommit

  var url: String {
    let url = Request.base
    switch self {
    case let .workflowRun(id):
      return url + "%@/%@/actions/workflows/\(id)/runs"
    case .latestRelease:
      return url + "%@/%@/git/refs/tags"
    case .latestCommit:
      return url + "%@/%@/commits"
    }
  }

  private static let base = "https://api.github.com/repos/"
}

public struct Parameters {

  // MARK: Lifecycle

  public init(
    token: String?,
    url: URL,
    request: Request,
    branch: String? = nil,
    limit: Int = 1,
    paginationLimit: Int = 1,
    since: String? = nil,
    skipPrintingStats: Bool = true)
  {
    self.token = token
    repository = url.repository
    owner = url.owner
    self.branch = branch
    self.request = request
    self.limit = limit
    self.paginationLimit = paginationLimit
    self.since = since
    self.skipPrintingStats = skipPrintingStats
  }

  public init(
    token: String?,
    repository: String,
    owner: String,
    request: Request,
    limit: Int = 10,
    paginationLimit: Int = 10,
    since: String? = nil,
    skipPrintingStats: Bool = true)
  {
    self.token = token
    self.repository = repository
    self.owner = owner
    self.request = request
    self.limit = limit
    branch = nil
    self.paginationLimit = paginationLimit
    self.since = since
    self.skipPrintingStats = skipPrintingStats
  }

  // MARK: Internal

  let token: String?
  let repository: String
  let owner: String
  let request: Request
  let limit: Int
  let paginationLimit: Int
  let since: String?
  let branch: String?
  let skipPrintingStats: Bool

  func generateURLRequest(withPage page: Int) throws -> URLRequest {
    let str = String(format: request.url, owner, repository)
    guard let url = URL(string: str) else {
      throw Errors.invalidURL(str: str)
    }

    if request == .latestRelease {
      return generateURL(from: url)
    }

    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    var queryItems = [
      URLQueryItem(name: "per_page", value: "\(limit)"),
      URLQueryItem(name: "page", value: "\(page)"),
    ]

    if let branch = branch {
      queryItems.append(
        URLQueryItem(
          name: "sha",
          value: branch))
    }
    if let since = since {
      queryItems.append(
        URLQueryItem(
          name: "created",
          value: ">=\(since)"))
    }
    urlComponents?.queryItems = queryItems
    guard let url = urlComponents?.url else {
      throw Errors.urlComponents(
        str: urlComponents?.debugDescription ?? str)
    }
    return generateURL(from: url)
  }

  // MARK: Private

  private var headers: [String: String] {
    var headers: [String: String] = ["Accept": "application/vnd.github+json"]
    if let token {
      headers["Authorization"] = "Bearer \(token)"
    }
    return headers
  }

  private func generateURL(from url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = headers
    return request
  }

}

extension URL {
  var owner: String {
    pathComponents[1]
  }

  var repository: String {
    var repo = pathComponents.last!
    if repo.contains(".git") {
      repo.removeLast(4)
    }
    return repo
  }
}
