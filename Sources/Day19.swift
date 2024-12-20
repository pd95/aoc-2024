import Algorithms

struct Day19: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    var towelTypes = [String]()
    var combinations = [String]()

    for line in data.split(separator: .newlineSequence) {
      let splits = line.split(separator: ", ")
      if splits.count > 1 {
        towelTypes = splits.map(String.init)
      } else {
        combinations.append(String(line))
      }
    }

    towelTypes.sort {
      $0.count >= $1.count
    }

    //print("towelTypes", towelTypes)
    //print("combinations", combinations)
    var unsuccessfulEndPatterns = Set<String>()

    func coversAll(of pattern: String, using towels: [String]) -> Bool {
      guard unsuccessfulEndPatterns.contains(pattern) == false else {
        return false
      }
      if pattern.isEmpty {
        return true
      }

      print(#function, pattern)
      for towel in towels {
        //print("testing", towel)
        if pattern.hasPrefix(towel) {
          if coversAll(of: String(pattern.dropFirst(towel.count)), using: towels) {
            return true
          }
        }
      }

      unsuccessfulEndPatterns.insert(pattern)

      return false
    }


    for combination in combinations {
      //print(combination)
      let relevantTowels = towelTypes.filter { combination.contains($0) }

      if coversAll(of: combination, using: relevantTowels) {
        print("🟢 \(combination) is solveable")
        result += 1
      } else {
        print("🔴 \(combination) is not solveable")
      }
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    var towelTypes = [String]()
    var combinations = [String]()

    for line in data.split(separator: .newlineSequence) {
      let splits = line.split(separator: ", ")
      if splits.count > 1 {
        towelTypes = splits.map(String.init)
      } else {
        combinations.append(String(line))
      }
    }

    towelTypes.sort {
      $0.count >= $1.count
    }

    //print("towelTypes", towelTypes)
    //print("combinations", combinations)
    var trackedPatterns: [String: Int] = [:]

    func coversAll(of pattern: String, using towels: [String], usedTowels: [String] = []) -> Int {
      //print(#function, pattern)

      var solutionsCount = [Int]()
      var count = 0
      for towel in towels {
        //print("testing", towel)
        if pattern == towel {
          // Full match with rest of pattern
          //let towelCombination = usedTowels.joined(separator: ",")+","+towel
          //print("🟢 used towels", towelCombination)
          solutionsCount.append(1)
          count += 1
        }
        else if pattern.hasPrefix(towel) {
          let remainingPattern = String(pattern.dropFirst(towel.count))
          if let existingSolutions = trackedPatterns[remainingPattern] {
            //print("🟢 reusing existing solutions", existingSolutions)
            //solutionsCount.append(contentsOf: existingSolutions.map({ $0 + 1 }))
            count += existingSolutions
          } else {
            let newSolutions = coversAll(of: remainingPattern, using: towels, usedTowels: usedTowels + [towel])
            //print("🟢 found new solutions", newSolutions)
            trackedPatterns[remainingPattern] = newSolutions
            //solutionsCount.append(contentsOf: newSolutions.map({ $0 + 1 }))
            count += newSolutions
          }
        }
      }
      //print(#function, pattern, count)

      return count
    }


    for combination in combinations {
      //print(combination)
      let relevantTowels = towelTypes.filter { combination.contains($0) }
      trackedPatterns.removeAll()
      let solutions = coversAll(of: combination, using: relevantTowels)
      if solutions > 0 {
        print("🟢 \(combination) is solveable with \(solutions) solutions")
        result += solutions
      } else {
        print("🔴 \(combination) is not solveable")
      }
    }

    return result
  }
}
