import Foundation

public struct FailableDecodable<T: Decodable>: Decodable {
  public init(from decoder: Decoder) throws {
    result = Result(catching: { try T(from: decoder) })
  }

  public var value: T? {
    try? result.get()
  }

  let result: Result<T, Error>
}
