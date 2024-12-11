import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  enum Direction {
    case increasing, decreasing
  }

  func isReportSafe(_ report: [Int]) -> Bool {
    var direction: Direction?
    var previousNumber: Int = 0

    for (index, number) in report.enumerated() {
      if index > 0 {
        if direction == .decreasing {
          if previousNumber <= number {
            return false
          }
        } else if direction == .increasing {
          if previousNumber >= number {
            return false
          }
        } else {
          if previousNumber < number {
            direction = .increasing
          } else if previousNumber > number {
            direction = .decreasing
          } else {
            return false
          }
        }
        if abs(previousNumber - number) > 3 || abs(previousNumber - number) < 1 {
          return false
        }
      }
      previousNumber = number
    }
    return true
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var safeReports = 0

    for report in entities {
      if isReportSafe(report) {
        safeReports += 1
      }
    }

    return safeReports
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var safeReports = 0

    for report in entities {
      // Check for an safety error
      if isReportSafe(report) {
        safeReports += 1
      } else {

        // "Brute force" to find which entry to remove
        for i in report.indices {
          // remove entry from report and retry
          let newReport = Array(report[..<i] + report[(i + 1)...])
          if isReportSafe(newReport) {
            safeReports += 1
            break
          }
        }
      }
    }

    return safeReports
  }
}
