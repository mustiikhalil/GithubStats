import Foundation
import Rainbow

public enum Diffs: String {
  case patch = "Patch", minor = "Minor", major = "Major", unknown = "UNKNOWN", equal

  public func color(current: String, online: String) -> String {
    switch self {
    case .patch, .equal:
      let str = self == .equal ?
        "\(current) == \(online)" :
        "\(current) <= \(online) \(rawValue)"
      return str.green
    case .minor:
      return "\(current) <= \(online) \(rawValue)".yellow
    case .major:
      return "\(current) <= \(online) \(rawValue)".red
    case .unknown:
      return "\(current) <= \(online) \(rawValue)".blue
    }
  }
}

public struct CombinedResponse: PrintableData {

  // MARK: Lifecycle

  internal init(data: GithubRepositoryResponseProtocol, package: Pin) {
    self.data = data
    self.package = package
    diff = data.validate(currentTag: package.tag)
  }

  // MARK: Public

  public let diff: Diffs
  public let data: GithubRepositoryResponseProtocol
  public let package: Pin

  public func printingData(using: DateFormatter) {
    assertionFailure("Not implemented")
  }

  public func printingColorfulData(using: DateFormatter) {
    print(getColorfulData())
  }

  public func getColorfulData() -> String {
    var str = ""
    str += "package name: \(package.name.lightMagenta) owner: \(package.owner.lightMagenta)\n"
    let onlineSha = data.sha?.dropFirst(5)
    let packageSha = package.sha?.dropFirst(5)
    if package.hasVersion {
      str += "\(diff.color(current: package.tag ?? "", online: data.tag ?? ""))"
    } else {
      let updateRequired = isSafe ? "Safe".green : "Needs checking".yellow
      str += "online: \(onlineSha ?? "") current: \(packageSha ?? "") status: \(updateRequired)"
    }
    return str
  }

  // MARK: Internal

  var isSafe: Bool {
    data.sha == package.sha
  }
}
