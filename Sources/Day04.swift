import Algorithms
import RegexBuilder

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n")
      .map({ Array($0) })
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    let entities = entities
    let width = entities[0].count
    let height = entities.count

    func findXMAS(_ x: Int, _ y: Int, _ string: Substring, dx: Int, dy: Int) -> Bool {

      guard x >= 0 && y >= 0 && x < width && y < height else {
        return false
      }
      guard let character = string.first else {
        return false
      }

      if entities[y][x] == character {
        let restOfString = string.dropFirst()
        if restOfString.isEmpty {
          return true
        } else {
          let result = findXMAS(x+dx, y+dy, restOfString, dx: dx, dy: dy)
          return result
        }
      }
      return false
    }

    for y in 0..<height {
      for x in 0..<width {
        if entities[y][x] != "X" { continue }

        if findXMAS(x, y, "XMAS", dx: 1, dy: 0) {
          result += 1   // 3
        }
        if findXMAS(x, y, "XMAS", dx: 0, dy: 1) {
          result += 1   // 1
        }
        if findXMAS(x, y, "XMAS", dx: -1, dy: 0) {
          result += 1   // 2
        }
        if findXMAS(x, y, "XMAS", dx: 0, dy: -1) {
          result += 1   // 2
        }
        if findXMAS(x, y, "XMAS", dx: 1, dy: 1) {
          result += 1   // 1
        }
        if findXMAS(x, y, "XMAS", dx: -1, dy: 1) {
          result += 1   // 1
        }
        if findXMAS(x, y, "XMAS", dx: 1, dy: -1) {
          result += 1   // 4
        }
        if findXMAS(x, y, "XMAS", dx: -1, dy: -1) {
          result += 1   // 4
        }
      }
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    let entities = entities
    let width = entities[0].count
    let height = entities.count

    func findMAS(_ x: Int, _ y: Int, _ string: Substring, dx: Int, dy: Int) -> Bool {

      guard x >= 0 && y >= 0 && x < width && y < height else {
        return false
      }
      guard let character = string.first else {
        return false
      }

      if entities[y][x] == character {
        let restOfString = string.dropFirst()
        if restOfString.isEmpty {
          return true
        } else {
          let result = findMAS(x+dx, y+dy, restOfString, dx: dx, dy: dy)
          return result
        }
      }
      return false
    }

    for y in 0..<height {
      for x in 0..<width {
        if entities[y][x] != "M" { continue }

        //  M.M
        //  .A.
        //  S.S
        if findMAS(x, y, "MAS", dx: 1, dy: 1) && findMAS(x+2, y, "MAS", dx: -1, dy: 1) {
          result += 1   // 1
        }

        //  M.S
        //  .A.
        //  M.S
        if findMAS(x, y, "MAS", dx: 1, dy: 1) && findMAS(x, y+2, "MAS", dx: 1, dy: -1) {
          result += 1   // 3
        }

        //  S.S
        //  .A.
        //  M.M
        if findMAS(x, y, "MAS", dx: 1, dy: -1) && findMAS(x+2, y, "MAS", dx: -1, dy: -1) {
          result += 1   // 4
        }

        //  S.M
        //  .A.
        //  S.M
        if findMAS(x, y, "MAS", dx: -1, dy: 1) && findMAS(x, y+2, "MAS", dx: -1, dy: -1) {
          result += 1   // 1
        }
      }
    }

    return result
  }
}
