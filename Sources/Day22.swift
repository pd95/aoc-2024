import Algorithms

struct Day22: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct PseudoRandomNumberGenerator: CustomStringConvertible {
    var initialSecret: Int
    var numbersGenerated: Int = 0
    var secret: Int
    var priceChange: Int = 0
    var priceChanges: [Int] = []

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
      let initialPrice = price
      secret = prune(mix(secret: secret, with: secret * 64))
      secret = prune(mix(secret: secret, with: secret / 32))
      secret = prune(mix(secret: secret, with: secret * 2048))
      numbersGenerated += 1
      priceChange = price - initialPrice
      if priceChanges.count == 4 {
        priceChanges.removeFirst()
      }
      priceChanges.append(priceChange)
      //print(self)
      return secret
    }

    var price: Int {
      secret % 10
    }

    var description: String {
      "\(initialSecret): \(price) (\(priceChange)) after \(numbersGenerated) numbers"
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

    var generators: [PseudoRandomNumberGenerator] = data.components(separatedBy: .newlines)
      .compactMap(Int.init)
      .map(PseudoRandomNumberGenerator.init)

    // For each random number generator, generate 2000 entries
    print("Collecting sequences for \(generators.count) generators")
    var sequences: [[Int]: [(generatorIndex: Int, price: Int)]] = [:]
    for _ in 0..<2000 {

      generators.indices.forEach({ index in
        // generate next number
        generators[index].next()

        // Check whether we have a sequence of 4 price changes
        let priceChanges = generators[index].priceChanges
        guard priceChanges.count == 4 else { return }

        // Check if we haven't already had the same sequence for this generator
        guard sequences[priceChanges] == nil || sequences[priceChanges, default: []].firstIndex(where: { $0.generatorIndex == index }) == nil else {
          return
        }

        // Remember the generator and the price
        sequences[priceChanges, default: []].append((index, generators[index].price))
      })
    }

    print("number of sequences", sequences.count)

    // For each sequence, calculate the number of generators and the total number of bananas and sort it
    let occurences = sequences.mapValues { entry in
      let total = entry.reduce(0, { $0 + $1.price })
      return (matches: entry.count, bananas: total)
    }
    .sorted(by: { $0.value.1 > $1.value.1 })

    //print("number of sequence occurrences", occurences.map(\.value).reduce(0, +))
    //print("Top 10 occurences", occurences[..<10])

    result = occurences.first!.value.bananas

    return result
  }
}
