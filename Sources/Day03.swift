import Algorithms
import RegexBuilder

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [Substring] {
    data.split(separator: "\n")
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    // Regexp to match mul(123,456)
    let regex = /mul\((?<f1>\d+),(?<f2>\d+)\)/
    for part in entities {
      var startIndex = part.startIndex
      while startIndex < part.endIndex {
        if let match = try? regex.firstMatch(in: part[startIndex...]) {
          if match.output.0.prefix(4) == "mul(" {
            result += Int(match.output.f1)! * Int(match.output.f2)!
          }

          startIndex = match.output.0.endIndex
        } else {
          break
        }
      }
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0
    var shouldCalc = true

    // Regexp to match mul(123,456), don't() and do()
    let regex = /mul\((?<f1>\d+),(?<f2>\d+)\)|don't\(\)|do\(\)/
    for part in entities {
      var startIndex = part.startIndex
      while startIndex < part.endIndex {
        if let match = try? regex.firstMatch(in: part[startIndex...]) {
          let (wholeMatch, f1, f2) = match.output
          if wholeMatch.prefix(4) == "mul(" {
            if shouldCalc, let f1, let f2 {
              result += Int(f1)! * Int(f2)!
            }
          } else if wholeMatch == "don't()" {
            shouldCalc = false
          } else if wholeMatch == "do()" {
            shouldCalc = true
          }

          startIndex = wholeMatch.endIndex
        } else {
          break
        }
      }
    }

    return result
  }
}
