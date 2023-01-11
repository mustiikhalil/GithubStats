import Foundation

public struct ColorfulPrinter {

  public init() {}

  // MARK: Internal

  public func printSummary<T: PrintableData>(for item: T) {
    item.printingColorfulData(using: dateFormatter)
  }

  // MARK: Private

  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter
  }()

}

struct Printer {

  // MARK: Internal

  func printSummary<T: PrintableData>(for item: T) {
    item.printingData(using: dateFormatter)
  }

  // MARK: Private

  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter
  }()
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

public protocol PrintableData {
  func printingData(using: DateFormatter)
  func printingColorfulData(using: DateFormatter)
}

extension Statistics: PrintableData {

  public func printingColorfulData(using: DateFormatter) {
    assertionFailure("Not implemented")
  }

  public func printingData(using dateFormatter: DateFormatter) {
    print("Summary [\(name)]: ")
    print("workflow count: ", workflowCount)
    let startDate = dateFormatter.string(from: startDate)
    let endDate = dateFormatter.string(from: endDate)
    print("range: \(startDate) - \(endDate)")
    statuses.forEach { k, v in
      let percentage = Double(v.count) / totalRuns
      print("status: \(k) ---")
      print("percentage: \(Int(percentage * 100))")
      print("Total time: \(v.totalRunningTime.stringFromTimeInterval())")
      let averageTime: TimeInterval = v.totalRunningTime / Double(v.count)
      print("Average time across \(k) actions: \(averageTime.stringFromTimeInterval())")
    }
    let date: TimeInterval = averageTime / totalRuns
    print("Total time run: \(averageTime.stringFromTimeInterval())")
    print("Average time run: \(date.stringFromTimeInterval())")
  }
}

extension Array: PrintableData where Element: PrintableData {
  public func printingColorfulData(using dateformatter: DateFormatter) {
    for item in self {
      item.printingColorfulData(using: dateformatter)
    }
  }

  public func printingData(using dateformatter: DateFormatter) {
    for item in self {
      item.printingData(using: dateformatter)
    }
  }

}
