import Foundation

public struct GithubActionsStatsCore {

  // MARK: Lifecycle

  public init(
    parameters: Parameters,
    session: URLSessionProtocol = URLSession.shared)
  {
    self.parameters = parameters
    networking = Networking(session: session)
  }

  // MARK: Public

  @discardableResult
  public mutating func run() async throws -> Statistics {
    let responses = try await fetchGithubData(parameters: parameters)
    let githubStatistics = GithubStatistics(
      response: responses)
    let statistics = try githubStatistics.run()
    if !parameters.skipPrintingStats {
      printer
        .printSummary(for: statistics)
    }
    return statistics
  }

  // MARK: Private

  private lazy var printer = Printer()
  private let parameters: Parameters

  private lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  private let networking: Networking

  private mutating func fetchGithubData(parameters: Parameters) async throws -> GithubResponses {
    var githubResponses: [GithubResponse] = []
    for page in 1 ... parameters.paginationLimit {
      let request = try parameters.generateURLRequest(
        withPage: page)
      let data = try await networking.fetch(
        urlRequest: request)
      let response = try decoder.decode(GithubResponse.self, from: data)
      githubResponses.append(response)
      if response.workflowRuns.count < parameters.limit {
        break
      }
    }

    return GithubResponses(
      responses: githubResponses)
  }

}
