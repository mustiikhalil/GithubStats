
import XCTest

@testable import GithubStatsCore

final class DecodableTests: XCTestCase {

  // MARK: Internal

  func testDecodeV1() {
    let string = """
    {
      "object": {
        "pins": [
          {
            "package": "swift-nio",
            "repositoryURL": "https://github.com/apple/swift-nio.git",
            "state": {
              "branch": null,
              "revision": "ad3c2f1b726549f5d2cd73350d96c3cfc4123075",
              "version": "2.32.0"
            }
          },
          {
            "package": "swift-algorithms",
            "repositoryURL": "https://github.com/apple/swift-algorithms.git",
            "state": {
              "branch": "main",
              "revision": "64ad02f8f5a9c2bd98f2ad6c389e6e86bc2d5b47",
              "version": null
            }
          },
          {
            "package": "swift-collections",
            "repositoryURL": "https://github.com/apple/swift-collections.git",
            "state": {
              "branch": null,
              "revision": "81d1e46256483b2f23b61eb1a588ff5c8d37e9b9",
              "version": null
            }
          }
        ]
      },
      "version": 1
    }
    """

    let data = string.data(using: .utf8)!
    let package = try! decoder.decode(V1SwiftResolvedPackage.self, from: data)

    XCTAssertEqual(package.version, 1)
    XCTAssertEqual(package.pins[0].tag, "2.32.0")
    XCTAssertEqual(package.pins[0].sha, "ad3c2f1b726549f5d2cd73350d96c3cfc4123075")
    XCTAssertEqual(package.pins[0].hasVersion, true)
    XCTAssertEqual(package.pins[0].name, "swift-nio")
    XCTAssertEqual(package.pins[0].owner, "apple")

    XCTAssertEqual(package.pins[1].tag, nil)
    XCTAssertEqual(package.pins[1].sha, "64ad02f8f5a9c2bd98f2ad6c389e6e86bc2d5b47")
    XCTAssertEqual(package.pins[1].hasVersion, false)
  }

  func testDecodeV2() {
    let string = """
    {
      "pins": [
        {
          "identity": "swift-nio",
          "location": "https://github.com/apple/swift-nio.git",
          "state": {
            "branch": null,
            "revision": "ad3c2f1b726549f5d2cd73350d96c3cfc4123075",
            "version": "2.32.0"
          }
        },
        {
          "identity": "swift-algorithms",
          "location": "https://github.com/apple/swift-algorithms.git",
          "state": {
            "branch": "main",
            "revision": "64ad02f8f5a9c2bd98f2ad6c389e6e86bc2d5b47",
            "version": null
          }
        },
        {
          "identity": "swift-collections",
          "location": "https://github.com/apple/swift-collections.git",
          "state": {
            "branch": null,
            "revision": "81d1e46256483b2f23b61eb1a588ff5c8d37e9b9",
            "version": null
          }
        }
      ],
      "version": 2
    }
    """

    let data = string.data(using: .utf8)!
    let package = try! decoder.decode(V2SwiftResolvedPackage.self, from: data)

    XCTAssertEqual(package.version, 2)
    XCTAssertEqual(package.pins[0].tag, "2.32.0")
    XCTAssertEqual(package.pins[0].sha, "ad3c2f1b726549f5d2cd73350d96c3cfc4123075")
    XCTAssertEqual(package.pins[0].hasVersion, true)
    XCTAssertEqual(package.pins[0].name, "swift-nio")
    XCTAssertEqual(package.pins[0].owner, "apple")

    XCTAssertEqual(package.pins[1].tag, nil)
    XCTAssertEqual(package.pins[1].sha, "64ad02f8f5a9c2bd98f2ad6c389e6e86bc2d5b47")
    XCTAssertEqual(package.pins[1].hasVersion, false)
  }

  // MARK: Private

  private lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
}
