import Algorithms

struct Day22: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct PseudoRandomNumberGenerator: CustomStringConvertible {
    var initialSecret: Int
    var numbersGenerated: Int = 0
    var secret: Int

    init(initialSecret: Int) {
      self.initialSecret = initialSecret
      self.secret = initialSecret
    }

    func mix(secret: Int, with number: Int) -> Int {
      secret ^ number
    }

    func prune(_ secret: Int) -> Int {
      secret % 16777216
    }

    @discardableResult
    mutating func next() -> Int {
      secret = prune(mix(secret: secret, with: secret * 64))
      secret = prune(mix(secret: secret, with: secret / 32))
      secret = prune(mix(secret: secret, with: secret * 2048))
      numbersGenerated += 1
      return secret
    }

    var description: String {
      "\(initialSecret): \(secret) (after \(numbersGenerated) numbers)"
    }
  }


  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    var generators: [PseudoRandomNumberGenerator] = data.components(separatedBy: .newlines)
      .compactMap(Int.init)
      .map(PseudoRandomNumberGenerator.init)

    for _ in 0..<2000 {
      generators.indices.forEach({ generators[$0].next() })
    }
    generators.forEach {
      //print($0)
      result += $0.secret
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    return result
  }
}
