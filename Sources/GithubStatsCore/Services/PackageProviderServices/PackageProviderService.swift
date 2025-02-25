import Foundation

protocol PackageProviderService: Sendable {
  var service: Networking { get }
  var decoder: JSONDecoder { get }
  var host: Host { get }
}

extension PackageProviderService {
  func fetchPackagesFrom<T: Pin & DecodablePin>(pins: [T], token: String? = nil) async throws -> [CombinedResponse] {
    try await withThrowingTaskGroup(
      of: CombinedResponse.self,
      returning: [CombinedResponse].self)
    { group in
      for pin in pins where pin.host == host {
        group.addTask {
          try await fetch(pin: pin)
        }
      }

      var responses: [CombinedResponse] = []

      for try await response in group {
        responses.append(response)
      }

      return responses
    }
  }

  func fetch<T: Pin & DecodablePin>(pin: T, token: String? = nil) async throws -> CombinedResponse {
    if pin.state.hasVersion {
      let request = try pin.state.generateURL(token: token, url: pin.repositoryURL, host: pin.host)
      let data = try await service.fetch(urlRequest: request)
      let values = try decoder
        .decode([FailableDecodable<GithubReleaseResponse>].self, from: data)
        .compactMap { $0.value }
        .filter { $0.tag != nil }
        .sorted(by: { r1, r2 in
          r1.tag?.compare(r2.tag ?? "", options: .numeric) == .orderedAscending
        })
      guard let last = values.last else { throw Errors.emptyResponse }
      return CombinedResponse(data: last, package: pin)
    } else {
      let request = try pin.state.generateURL(token: token, url: pin.repositoryURL, host: pin.host)
      let data = try await service.fetch(urlRequest: request)
      let value = try decoder.decode([GithubCommitResponse].self, from: data).first!
      return CombinedResponse(data: value, package: pin.self)
    }
  }
}
