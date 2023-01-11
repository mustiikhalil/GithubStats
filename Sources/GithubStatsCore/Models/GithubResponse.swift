import Foundation

struct WorkFlow: Decodable {
  let name: String
  let path: String
  let conclusion: Status?
  let runStartedAt: Date
  let createdAt: Date
  let updatedAt: Date
}

struct GithubActionResponse: Decodable {
  let totalCount: Int
  let workflowRuns: [WorkFlow]
}

struct GithubActionResponses {
  var responses: [GithubActionResponse]
}
