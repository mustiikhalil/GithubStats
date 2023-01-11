import Foundation

protocol FileReader {
  func read(url: URL) throws -> Data
}

extension FileManager: FileReader {
  public func read(url: URL) throws -> Data {
    let path = url.path
    guard isReadableFile(atPath: path) else {
      throw Errors.fileNotFound
    }
    guard let data = contents(atPath: path) else {
      throw Errors.fileCantBeOpen
    }
    return data
  }
}
