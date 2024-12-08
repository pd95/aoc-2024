import Algorithms
import RegexBuilder

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var equations: [Substring] {
    data.split(separator: "\n")
  }

  var equationParts: [(result: Int, numbers: Array<Int>, text: String)] {
    let regex = /(?<result>\d+): (?<numbers>(?:\d+ ?)+)/
    var parts = [(result: Int, numbers: Array<Int>, text: String)]()

    for equation in equations {
      if let match = try? regex.wholeMatch(in: equation) {

        let equationResult = Int(match.output.result)!
        let equationNumbers = match.output.numbers.split(separator: " ").compactMap { Int($0)}
        parts.append((result: equationResult, numbers: equationNumbers, text: String(match.output.0)))
      } else {
        fatalError("Unexpected input: \(equation)")
      }
    }
    return parts
  }

  func checkResultPart1(currentResult: Int, expectedResult: Int, numbers: ArraySlice<Int>) -> Bool {
    guard let currentNumber = numbers.first else {
      return currentResult == expectedResult
    }
    let remainingNumbers = numbers.dropFirst()
    return checkResultPart1(currentResult: currentResult + currentNumber, expectedResult: expectedResult, numbers: remainingNumbers)
    || checkResultPart1(currentResult: currentResult * currentNumber, expectedResult: expectedResult, numbers: remainingNumbers)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    for (expectedResult, numbers, _) in equationParts {
      if checkResultPart1(currentResult: numbers[0], expectedResult: expectedResult, numbers: numbers.dropFirst()) {
        result += expectedResult
      }
    }

    return result
  }

  func checkResultPart2(currentResult: Int, expectedResult: Int, numbers: ArraySlice<Int>) -> Bool {
    guard let currentNumber = numbers.first else {
      return currentResult == expectedResult
    }
    let remainingNumbers = numbers.dropFirst()

    let sumResult = checkResultPart2(currentResult: currentResult + currentNumber, expectedResult: expectedResult, numbers: remainingNumbers)

    let multiplicationResult = checkResultPart2(currentResult: currentResult * currentNumber, expectedResult: expectedResult, numbers: remainingNumbers)

    let concatenatedNumber = Int(currentResult.description + currentNumber.description)!
    let concatenationResult = checkResultPart2(currentResult: concatenatedNumber, expectedResult: expectedResult, numbers: remainingNumbers)

    return sumResult || multiplicationResult || concatenationResult
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    for (expectedResult, numbers, _) in equationParts {
      if checkResultPart2(currentResult: numbers[0], expectedResult: expectedResult, numbers: numbers.dropFirst()) {
        result += expectedResult
      }
    }

    return result
  }
}
