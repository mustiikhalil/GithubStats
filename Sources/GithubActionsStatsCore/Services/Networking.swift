import Foundation

public protocol URLSessionProtocol {
  func dataAndStatusCode(for urlRequest: URLRequest) async throws -> (Data, Int)
}

extension URLSession: URLSessionProtocol {

  public func dataAndStatusCode(for urlRequest: URLRequest) async throws -> (Data, Int) {
    let (data, response) = try await data(for: urlRequest)
    let httpResponse = response as? HTTPURLResponse
    return (data, httpResponse?.statusCode ?? -100)
  }
}

struct Networking {

  init(session: URLSessionProtocol) {
    self.session = session
  }

  func fetch(urlRequest: URLRequest) async throws -> Data {
    print("> url: \(urlRequest.url?.absoluteString ?? "NONE")")
    let (data, statusCode) = try await session.dataAndStatusCode(for: urlRequest)
    if statusCode >= 400 {
      throw Errors.networkingError(
        statusCode: statusCode,
        str: String(data: data, encoding: .utf8))
    }
    return data
  }

  private let session: URLSessionProtocol
}
