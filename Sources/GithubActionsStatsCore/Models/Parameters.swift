import Foundation

enum URLS: String {
  case workflowRuns = "%@/%@/actions/workflows/%@/runs"
  static let base = "https://api.github.com/repos/"

  var url: String {
    let str = rawValue
    switch self {
    case .workflowRuns:
      return URLS.base + str
    }
  }
}

public struct Parameters {

  // MARK: Lifecycle

  public init(
    token: String,
    repository: String,
    owner: String,
    workflowId: String,
    limit: Int,
    paginationLimit: Int,
    since: String? = nil,
    skipPrintingStats: Bool = true)
  {
    self.token = token
    self.repository = repository
    self.owner = owner
    self.workflowId = workflowId
    self.limit = limit
    self.paginationLimit = paginationLimit
    self.since = since
    self.skipPrintingStats = skipPrintingStats
  }

  // MARK: Internal

  let token: String
  let repository: String
  let owner: String
  let workflowId: String
  let url = URLS.workflowRuns
  let limit: Int
  let paginationLimit: Int
  let since: String?
  let skipPrintingStats: Bool

  func generateURLRequest(
    withPage page: Int)
    throws
    -> URLRequest
  {
    let str = String(format: url.url, owner, repository, workflowId)
    guard let url = URL(string: str) else {
      throw Errors.invalidURL(str: str)
    }
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    var queryItems = [
      URLQueryItem(name: "per_page", value: "\(limit)"),
      URLQueryItem(name: "page", value: "\(page)"),
    ]

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
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = [
      "Authorization": "Bearer \(token)",
      "Accept": "application/vnd.github+json"
    ]
    return request
  }
}
