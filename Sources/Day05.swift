import Algorithms
import RegexBuilder

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var lines: [Substring] { data.split(separator: "\n") }

  var updateRules: [Int: Set<Int>] {
    var rules = [Int: Set<Int>]()

    lines.filter({ $0.contains("|") }).forEach { (line: Substring) in
      let values = line.split(separator: "|")
      let v1 = Int(values[0])!
      let v2 = Int(values[1])!
      rules[v1, default: Set<Int>()].insert(v2)
    }

    return rules
  }

  var pageUpdates: [[Int]] {
    var allValues: [[Int]] = []
    lines.filter({ $0.contains(",") }).forEach { (line: Substring) in
      let values = line.split(separator: ",").map({ Int($0)! })
      allValues.append(values)
    }

    return allValues
  }

  func identifyInvalidPages(_ update: [Int], rules: [Int: Set<Int>]) -> [Int:[Int]] {
    var violatingPages = [Int:[Int]]()
    for (index, page) in update.enumerated() {

      //print("page \(page) at \(index)")
      let pagesAfter = rules[page, default: []]
      let before = update[0..<index]
      //let after = update[(index+1)...]
      let violations = before.filter(pagesAfter.contains(_:))
      //print("before", before)
      //print("after", after)
      //print("violations", violations)
      if !violations.isEmpty {
        violatingPages[page] = violations
      }
    }
    return violatingPages
  }

  func part1() -> Int {
    var result = 0
    let pageUpdates = pageUpdates
    let rules = updateRules

    // Identify and process all correctly ordered updates and calculate the sum of middle pages
    for update in pageUpdates {
      let violatingPages = identifyInvalidPages(update, rules: rules)
      if violatingPages.isEmpty {
        let middleIndex = Int(update.count / 2)
        //print("🟢 valid", update, middleIndex, "=>", update[middleIndex])
        result += update[middleIndex]
      } else {
        //print("🔴 invalid", update, "due to", violatingPages)
      }
    }

    // Should be 4872 for the "Day05.txt"
    return result
  }

  func part2() -> Int {
    var result = 0
    let pageUpdates = pageUpdates
    let rules = updateRules

    // Process all incorrect updates, fix them and calculate the sum of middle pages
    for var update in pageUpdates {
      var violatingPages = identifyInvalidPages(update, rules: rules)

      if violatingPages.isEmpty == false {
        //print("🔴 invalid", update, "due to", violatingPages)
        while violatingPages.isEmpty == false {
          for (page, violations) in violatingPages {
            //print("Resolving", page, "violating", violations)
            let pageIndex = update.firstIndex(of: page)!
            var firstIndex = update.endIndex
            for violation in violations {
              let violationIndex = update.firstIndex(of: violation)!
              if firstIndex > violationIndex {
                firstIndex = violationIndex
              }
            }
            update.swapAt(firstIndex, pageIndex)
            break   // fix only the first violation!
          }

          violatingPages = identifyInvalidPages(update, rules: rules)
        }
        //print("🟢 Fixed update", update, "is valid", violatingPages.isEmpty, violatingPages)

        let middleIndex = Int(update.count / 2)
        result += update[middleIndex]
      }
    }

    return result
  }
}
