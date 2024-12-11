import Algorithms

struct Day11: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var stones: [Int] = data.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
      .compactMap({ Int($0) })

    //print(stones)
    for _ in 1...25 {
      var newStones = [Int]()
      for stone in stones {
        let string = String(stone)
        if stone == 0 {
          newStones.append(1)
        } else if string.count.isMultiple(of: 2) {
          let leftHalf = string[..<string.index(string.startIndex, offsetBy: string.count / 2)]
          let rightHalf = string[string.index(string.startIndex, offsetBy: string.count / 2)...]
          newStones.append(Int(leftHalf)!)
          newStones.append(Int(rightHalf)!)
        } else {
          newStones.append(stone * 2024)
        }
      }
      stones = newStones
    }

    return stones.count
  }


  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0
    let stones: [Int] = data.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
      .compactMap({ Int($0) })
    var stoneMap: [Int: [Int]] = [:]
    var stonesAtBlink: [Int: Int] = [:]

    func calculateNextValues(for stone: Int) -> [Int] {
      if let nextValues = stoneMap[stone] {
        return nextValues
      }
      let nextValues: [Int]
      let string = String(stone)
      if stone == 0 {
        nextValues = [1]
      } else if string.count.isMultiple(of: 2) {
        let leftHalf = string[..<string.index(string.startIndex, offsetBy: string.count / 2)]
        let rightHalf = string[string.index(string.startIndex, offsetBy: string.count / 2)...]
        nextValues = [Int(leftHalf)!, Int(rightHalf)!]
      } else {
        nextValues = [stone * 2024]
      }
      stoneMap[stone] = nextValues

      return nextValues
    }

    stones.forEach {
      stonesAtBlink[$0, default: 0] += 1
    }

    for _ in 1...75 {
      var nextStones = [Int: Int]()
      for (stone, count) in stonesAtBlink {
        let nextValues = calculateNextValues(for: stone)
        for nextStone in nextValues {
          nextStones[nextStone, default: 0] += count
        }
      }
      stonesAtBlink = nextStones
    }
    result = stonesAtBlink.values.reduce(0, +)

    return result
  }
}
