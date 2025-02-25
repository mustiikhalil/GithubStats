import Foundation

struct GithubWorkerService: PackageProviderService {
  let host: Host = .github
  var service: Networking { _service }
  var decoder: JSONDecoder { _decoder }

  init(service: Networking) {
    _service = service
  }

  private let _service: Networking
  private let _decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
}
