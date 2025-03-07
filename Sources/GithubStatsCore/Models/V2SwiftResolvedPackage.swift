import Foundation

struct V2SwiftResolvedPackage: Decodable {
  let pins: [V2Package]
  let version: Int
}

struct V2Package: DecodablePin {
  let identity: String
  let repositoryURL: URL
  let state: State
  let host: Host?

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    identity = try container.decode(String.self, forKey: .identity)
    repositoryURL = try container.decode(URL.self, forKey: .repositoryURL)
    state = try container.decode(State.self, forKey: .state)
    host = Host(rawValue: repositoryURL.host())
  }

  enum CodingKeys: String, CodingKey {
    case identity
    case repositoryURL = "location"
    case state
  }
}
