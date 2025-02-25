import Foundation

protocol DecodablePin: Decodable, Pin {
  var repositoryURL: URL { get }
  var state: State { get }
  var host: Host? { get }
}

extension DecodablePin {
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
}
