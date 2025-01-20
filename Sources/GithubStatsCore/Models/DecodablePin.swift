import Foundation

protocol DecodablePin: Decodable, Pin {
    var repositoryURL: URL { get }
    var state: State { get }
}
extension DecodablePin {
    
    var tag: String? {
        state.version
    }
    
    var name: String {
        repositoryURL.repository
    }
    
    var owner: String {
        repositoryURL.owner
    }
    
    var sha: String? {
        state.revision
    }
    
    var hasVersion: Bool {
        state.hasVersion
    }
    
    func fetch(
        token: String,
        using networking: Networking,
        decoder: JSONDecoder)
    async throws -> GithubRepositoryResponseProtocol
    {
        if state.hasVersion {
            let request = try state.generateURL(token: token, url: repositoryURL)
            let data = try await networking.fetch(urlRequest: request)
            let values = try decoder
                .decode([FailableDecodable<GithubReleaseResponse>].self, from: data)
                .compactMap { $0.value }
                .filter { $0.tag != nil }
                .sorted(by: { r1, r2 in
                    r1.tag?.compare(r2.tag ?? "", options: .numeric) == .orderedAscending
                })
            return values.last!
        } else {
            let request = try state.generateURL(token: token, url: repositoryURL)
            let data = try await networking.fetch(urlRequest: request)
            return try decoder.decode([GithubCommitResponse].self, from: data).first!
        }
    }
}
