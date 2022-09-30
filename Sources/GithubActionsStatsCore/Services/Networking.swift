import Foundation

struct Networking {

  init(session: URLSession) {
    self.session = session
  }

  func fetch(urlRequest: URLRequest) async throws -> Data {
    print("> url: \(urlRequest.url?.absoluteString ?? "NONE")")
    let (data, response) = try await session.data(for: urlRequest)
    if let response = response as? HTTPURLResponse, response.statusCode > 400 {
      throw Errors.networkingError(
        statusCode: response.statusCode,
        str: String(data: data, encoding: .utf8))
    }
    return data
  }

  private let session: URLSession
}
