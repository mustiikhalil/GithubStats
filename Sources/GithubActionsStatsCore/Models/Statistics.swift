import Foundation

public enum Status: String, Decodable {
  case cancelled, success, failure, inProgress
}

public struct Statistics {
  public let name: String
  public let workflowCount: Int
  public let startDate: Date
  public let endDate: Date
  public let statuses: [Status: StatusStats]
  public let averageTime: Double
  public let totalRuns: Double
}

public struct StatusStats {
  public var count: Int
  public var totalRunningTime: TimeInterval

  static func += (lhs: inout StatusStats, rhs: StatusStats) {
    lhs.count += rhs.count
    lhs.totalRunningTime += rhs.totalRunningTime
  }
}
