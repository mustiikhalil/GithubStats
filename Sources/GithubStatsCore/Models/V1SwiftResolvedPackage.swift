import Foundation

struct V1SwiftResolvedPackage: Decodable {
  enum CodingKeys: CodingKey {
    case object
    case version
  }

  enum NestedCodingKeys: CodingKey {
    case pins
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let pins = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .object)
    self.pins = try pins.decode([V1Package].self, forKey: .pins)
    version = try container.decode(Int.self, forKey: .version)
  }
  let pins: [V1Package]
  let version: Int

}

struct V1Package: DecodablePin {
  let package: String
  let repositoryURL: URL
  let state: State
}
