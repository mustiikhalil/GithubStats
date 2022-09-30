import Foundation

struct WorkFlow: Decodable {
  let name: String
  let conclusion: Status?
  let runStartedAt: Date
  let createdAt: Date
  let updatedAt: Date
}

struct GithubResponse: Decodable {
  let totalCount: Int
  let workflowRuns: [WorkFlow]
}

struct GithubResponses {
  var responses: [GithubResponse]
}
