import Foundation

public protocol GithubRepositoryResponseProtocol {
  var sha: String? { get }
  var tag: String? { get }
}

extension GithubRepositoryResponseProtocol {
  func validate(currentTag: String?) -> Diffs {
    guard let strippedTag = tag, let currentStrippedTag = currentTag else {
      return .unknown
    }
    return currentStrippedTag.versionCompare(strippedTag)
  }
}

struct GithubReleaseResponse: Decodable, GithubRepositoryResponseProtocol {

  // MARK: Lifecycle

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let _tag = try container.decodeIfPresent(String.self, forKey: .ref)
    if let _tag = _tag,
       let str = _tag.version
    {
      if str.contains("alpha") || str.contains("beta") {
        throw Errors.alphaOrBetaRelease
      }
      tag = str.filter("0123456789.".contains)
    } else {
      tag = nil
    }

    let commit = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .object)
    sha = try commit.decodeIfPresent(String.self, forKey: .sha)
  }

  // MARK: Internal

  enum CodingKeys: CodingKey {
    case ref
    case object
  }

  enum NestedCodingKeys: CodingKey {
    case sha
  }

  let tag: String?
  let sha: String?
}

struct GithubCommitResponse: Decodable, GithubRepositoryResponseProtocol {
  let sha: String?
  var tag: String? { nil }
}

extension String {
  func versionCompare(_ otherVersion: String) -> Diffs {
    switch compare(otherVersion, options: .numeric) {
    case .orderedAscending:
      return diffOnStringsSplitted(otherVersion)
    case .orderedDescending:
      return .unknown
    case .orderedSame:
      return .equal
    }
  }

  func diffOnStringsSplitted(_ otherVersion: String) -> Diffs {
    let current = split(separator: ".")
    let _otherVersion = otherVersion.split(separator: ".")

    if current.first != _otherVersion.first {
      return .major
    }

    if current[1] != _otherVersion[1] {
      return .minor
    }

    return .patch
  }
}

extension String {

  var version: String? {
    let str = split(separator: "/")
      .last?
      .trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
    let range = str?.rangeOfCharacter(
      from: .letters.union(CharacterSet(charactersIn: "/_?><,;:'!@#$%^&*()_+-=")))

    if let range = range {
      if str?[range.lowerBound ..< range.upperBound] != "v" {
        return nil
      }
    }
    return str
  }
}
