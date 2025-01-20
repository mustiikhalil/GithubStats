import Foundation

struct V2SwiftResolvedPackage: Decodable {
  let pins: [V2Package]
  let version: Int
}

struct V2Package: DecodablePin {
  let identity: String
  let repositoryURL: URL
  let state: State

  enum CodingKeys: String, CodingKey {
    case identity
    case repositoryURL = "location"
    case state
  }
}
