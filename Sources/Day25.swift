import Algorithms

struct Day25: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    var keys = Set<[Int]>()
    var locks = Set<[Int]>()

    for lockOrKey in data.split(separator: "\n\n") {

      // Parse height information (ignoring first and last line of data)
      var heights = Array(repeating: 0, count: 5)
      for line in lockOrKey.split(separator: "\n").dropFirst().dropLast() {
        for (index, char) in line.enumerated() {
          if char == "#" {
            heights[index] += 1
          }
        }
      }

      if lockOrKey.hasPrefix("#####") {
        locks.insert(heights)
      } else if lockOrKey.hasPrefix(".....") {
        keys.insert(heights)
      }
    }

//    print("------------------ Lock -------------")
//    print(locks)
//
//    print("------------------ Keys -------------")
//    print(keys)

    func keyFitsLock(key: [Int], lock: [Int]) -> Bool {
      for (index, height) in key.enumerated() {
        if height + lock[index] > 5 {
          return false
        }
      }
      return true
    }

    for lock in locks.sorted(by: { String(describing: $0) < String(describing: $1) }) {
      for key in keys.sorted(by: { String(describing: $0) < String(describing: $1) }) {
        //print("lock \(lock) with key \(key)...")
        if keyFitsLock(key: key, lock: lock) {
          //print("  Success!")
          result += 1
        }
      }
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    return result
  }
}
