import Foundation

enum Errors: Error {
  case networkingError(statusCode: Int, str: String?)
  case invalidURL(str: String)
  case urlComponents(str: String)
  case emptyResponse
}
