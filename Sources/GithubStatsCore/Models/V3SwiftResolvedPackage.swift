import Foundation

struct V3SwiftResolvedPackage: Decodable {
  let pins: [V3Package]
  let version: Int
}

struct V3Package: DecodablePin {

  // MARK: Lifecycle

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    identity = try container.decode(String.self, forKey: .identity)
    kind = try container.decodeIfPresent(String.self, forKey: .kind)
    repositoryURL = try container.decode(URL.self, forKey: .repositoryURL)
    state = try container.decode(State.self, forKey: .state)
    host = Host(rawValue: repositoryURL.host())
  }

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case identity
    case kind
    case repositoryURL = "location"
    case state
  }

  let identity: String
  let kind: String?
  let repositoryURL: URL
  let state: State
  let host: Host?

}
