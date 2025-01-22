import Foundation

public protocol Pin: Sendable {
  var name: String { get }
  var owner: String { get }
  var sha: String? { get }
  var tag: String? { get }
  var hasVersion: Bool { get }

  func fetch(
    token: String?,
    using: Networking,
    decoder: JSONDecoder)
    async throws -> CombinedResponse
}
