import Foundation

struct Printer {

  // MARK: Lifecycle

  init(statistics: Statistics) {
    self.statistics = statistics
  }

  // MARK: Internal

  func printSummary() {
    print("Summary: ")
    print("workflow count: ", statistics.workflowCount)
    let startDate = dateFormatter.string(from: statistics.startDate)
    let endDate = dateFormatter.string(from: statistics.endDate)
    print("range: \(startDate) - \(endDate)")
    statistics.statuses.forEach { k, v in
      let percentage = Double(v.count) / statistics.totalRuns
      print("status: \(k) ---")
      print("percentage: \(Int(percentage * 100))")
      print("Total time: \(v.totalRunningTime.stringFromTimeInterval())")
      let averageTime: TimeInterval = v.totalRunningTime / Double(v.count)
      print("Average time accross \(k) actions: \(averageTime.stringFromTimeInterval())")
    }
    let date: TimeInterval = statistics.averageTime / statistics.totalRuns
    print("Total time run: \(statistics.averageTime.stringFromTimeInterval())")
    print("Average time run: \(date.stringFromTimeInterval())")
  }

  // MARK: Private

  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter
  }()

  private let statistics: Statistics
}

extension TimeInterval {
  fileprivate func stringFromTimeInterval() -> String {
    let time = NSInteger(self)
    let ms = Int(truncatingRemainder(dividingBy: 1) * 1000)
    let seconds = time % 60
    let minutes = (time / 60) % 60
    let hours = (time / 3600)
    return String(format: "%0.2d:%0.2d:%0.2d.%0.3d", hours, minutes, seconds, ms)
  }
}
