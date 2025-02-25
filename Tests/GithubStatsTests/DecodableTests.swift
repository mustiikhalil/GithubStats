import Foundation
import Testing
@testable import GithubStatsCore

private let decoder: JSONDecoder = {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .iso8601
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  return decoder
}()

@Suite
struct Decoding {
  @Test
  func decodeV1() {
    let data = packageV1.data(using: .utf8)!
    let package = try! decoder.decode(V1SwiftResolvedPackage.self, from: data)

    #expect(package.version == 1)
    #expect(package.pins[0].tag == "2.32.0")
    #expect(package.pins[0].sha == "ad3c2f1b726549f5d2cd73350d96c3cfc4123075")
    #expect(package.pins[0].hasVersion == true)
    #expect(package.pins[0].name == "swift-nio")
    #expect(package.pins[0].owner == "apple")

    #expect(package.pins[1].tag == nil)
    #expect(package.pins[1].sha == "64ad02f8f5a9c2bd98f2ad6c389e6e86bc2d5b47")
    #expect(package.pins[1].hasVersion == false)
  }

  @Test
  func decodeV2() {
    let data = packageV2.data(using: .utf8)!
    let package = try! decoder.decode(V2SwiftResolvedPackage.self, from: data)

    #expect(package.version == 2)
    #expect(package.pins[0].tag == "2.32.0")
    #expect(package.pins[0].sha == "ad3c2f1b726549f5d2cd73350d96c3cfc4123075")
    #expect(package.pins[0].hasVersion == true)
    #expect(package.pins[0].name == "swift-nio")
    #expect(package.pins[0].owner == "apple")

    #expect(package.pins[1].tag == nil)
    #expect(package.pins[1].sha == "64ad02f8f5a9c2bd98f2ad6c389e6e86bc2d5b47")
    #expect(package.pins[1].hasVersion == false)
  }

  @Test
  func decodeV3() {
    let data = packageV3.data(using: .utf8)!
    let package = try! decoder.decode(V3SwiftResolvedPackage.self, from: data)

    #expect(package.version == 3)
    #expect(package.pins[0].tag == "1.5.0")
    #expect(package.pins[0].sha == "41982a3656a71c768319979febd796c6fd111d5c")
    #expect(package.pins[0].kind == "remoteSourceControl")
    #expect(package.pins[0].hasVersion == true)
    #expect(package.pins[0].name == "swift-argument-parser")
    #expect(package.pins[0].owner == "apple")

    #expect(package.pins[2].tag == nil)
    #expect(package.pins[2].sha == "b022b08312decdc46585e0b3440d97f6f22ef703")
    #expect(package.pins[2].hasVersion == false)
  }

}
