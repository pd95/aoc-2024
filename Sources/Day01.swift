import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    let leftList = entities.map({ $0[0] })
    let rightList = entities.map({ $0[1] })

    // Calculate the total distance between your lists
    let result = zip(leftList.sorted(), rightList.sorted())
      .reduce(into: 0) { distance, numberPair in
        distance += abs(numberPair.0 - numberPair.1)
      }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    let leftList = entities.map({ $0[0] })
    let rightList = entities.map({ $0[1] }).sorted()

    let allNumbers = Set(leftList)
    var occurances = [Int: Int]()
    for number in allNumbers {
      let count = rightList.count(where: { $0 == number })
      occurances[number] = count
    }

    // calculate score
    let result = leftList.reduce(into: 0) { score, number in
      if let count = occurances[number] {
        score += number * count
      }
    }
    return result
  }
}
