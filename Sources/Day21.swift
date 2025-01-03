import Algorithms

extension Day21.Edges {
  /*
   Graph representation of numeric keypad
   +---+---+---+
   | 7 | 8 | 9 |
   +---+---+---+
   | 4 | 5 | 6 |
   +---+---+---+
   | 1 | 2 | 3 |
   +---+---+---+
   | 0 | A |
   +---+---+
   */

  static let numericKeypad: Self = [
    "7" : ["4v", "8>"],
    "8" : ["7<", "9>", "5v"],
    "9" : ["8<", "6v"],
    "4" : ["7^", "5>", "1v"],
    "5" : ["8^", "4<", "6>", "2v"],
    "6" : ["9^", "5<", "3v"],
    "1" : ["4^", "2>"],
    "2" : ["5^", "1<", "3>", "0v"],
    "3" : ["6^", "2<", "Av"],
    "0" : ["2^", "A>"],
    "A" : ["3^", "0<"]
  ]


  /* Graph representation of directional keypad
   +---+---+
   | ^ | A |
   +---+---+---+
   | < | v | > |
   +---+---+---+
   */
  static let directionalKeypad: Self = [
    "^" : ["A>", "vv"],
    "A" : ["^<", ">v"],
    ">" : ["A^", "v<"],
    "<" : ["v>"],
    "v" : ["<<", "^^", ">>"]
  ]
}

struct Day21: AdventDay {

  typealias Edges = [Character: [String]]

  class Graph {
    private(set) var graph: Edges = [:]
    private(set) var paths: [Character: [Character: [String]]] = [:]

    private var shortestPathCache: [String: (cost: Int, paths: [String])] = [:]
    private var transformCache: [String: (cost: Int, paths: [[String]])] = [:]
    private(set) var costCache: [String: Int] = [:]

    init(graph: Edges) {
      self.graph = graph

      // Precompute all shortest paths
      for start in graph.keys {
        paths[start] = allShortestPaths(from: start)
      }
    }

    private func updateShortestPathCache(_ key: String, cost: Int, paths: [String]) {
      shortestPathCache[key] = (cost: cost, paths: paths)
    }

    private func updateTransformCache(_ key: String, cost: Int, paths: [[String]]) {
      transformCache[key] = (cost: cost, paths: paths)
    }

    func updateCostCache(_ key: String, cost: Int) {
      costCache[key] = cost
    }

    func shortestPaths(from fromChar: Character, to toChar: Character) async -> (cost: Int, paths: [String]) {
      let cacheKey = "\(fromChar)\(toChar)"
      if let cachedResult = shortestPathCache[cacheKey] {
        return cachedResult
      }

      guard let movements = paths[fromChar]?[toChar] else {
        fatalError("No valid path from \(fromChar) to \(toChar)")
      }

      var cost = Int.max
      var paths = [String]()

      for movement in movements {
        let enhancedMovement = "\(movement)A"
        let newCost = enhancedMovement.count
        if newCost < cost {
          cost = newCost
          paths = [enhancedMovement]
        } else if newCost == cost {
          paths.append(enhancedMovement)
        }
      }

      updateShortestPathCache(cacheKey, cost: cost, paths: paths)
      return (cost, paths)
    }

    func transform(_ sequence: String) async -> (cost: Int, paths: [[String]]) {
      if let cachedResult = transformCache[sequence] {
        return cachedResult
      }

      var resultCost = 0
      var resultPaths = [[String]]()

      let modifiedSequence = "A\(sequence)"
      for index in modifiedSequence.indices.dropLast() {
        let fromChar = modifiedSequence[index]
        let toChar = modifiedSequence[modifiedSequence.index(after: index)]

        let partialPath = await shortestPaths(from: fromChar, to: toChar)
        resultCost += partialPath.cost

        resultPaths.append(partialPath.paths)
      }

      updateTransformCache(sequence, cost: resultCost, paths: resultPaths)
      return (resultCost, resultPaths)
    }


    private func cost(_ sequence: String) -> Int {
      guard var previousChar = sequence.first else { return 0 }
      var cost = 1
      for char in sequence.dropFirst() {
        if char == previousChar {
          cost += 1
        } else {
          cost += 2
        }
        previousChar = char
      }
      return cost
    }

    private func allShortestPaths(from start: Character) -> [Character: [String]] {
      var queue: [(Character, String)] = [(start, "")]
      var visited: [Character: [String]] = [start: [""]]

      while !queue.isEmpty {
        let (node, sequence) = queue.removeFirst()

        for neighborCode in graph[node] ?? [] {
          let neighbor = neighborCode.first ?? "#"
          let direction = neighborCode.last ?? "#"
          let newSequence = sequence.appending(String(direction))
          let newCost = cost(newSequence)
          if visited[neighbor, default: []].count(where: { cost($0) < newCost }) == 0 {
            //print(start, neighbor, newSequence)
            visited[neighbor, default: []].append(newSequence)
            queue.append((neighbor, newSequence))
          }
        }
      }

      return visited
    }

    static var numericKeypad: Graph {
      Graph(graph: .numericKeypad)
    }
    static var directionalKeypad: Graph {
      Graph(graph: .directionalKeypad)
    }
  }

  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func findMinimumCostPath(code: String, using keypads: [Graph], currentLevel: Int = 0) async -> (cost: Int, paths: Set<String>) {
    //print(#function, code, currentLevel)
    let cacheKey = "\(code)\(currentLevel)"
    if let cachedResult = keypads[currentLevel].costCache[cacheKey] {
      return (cachedResult, [])
    }

    let result = await keypads[currentLevel].transform(code)

    // further transformation required?
    if currentLevel + 1 < keypads.count {
      var cost: Int = 0

      for part in result.paths {

        var minCost = Int.max
        for path in part {
          let transformedPart = await findMinimumCostPath(code: path, using: keypads, currentLevel: currentLevel + 1)
          //print(transformedPart)
          if transformedPart.cost < minCost {
            minCost = transformedPart.cost
          }
        }

        cost += minCost
      }

      keypads[currentLevel].updateCostCache(cacheKey, cost: cost)
      return (cost, [])
    }

    keypads[currentLevel].updateCostCache(cacheKey, cost: result.cost)
    return (result.cost, [])
  }


  // Replace this with your solution for the first part of the day's challenge.
  func part1() async -> Int {
    let codes = data.components(separatedBy: "\n")
    let numericKeypad = Graph.numericKeypad
    let directionalKeypad = Graph.directionalKeypad

    let keypads: [Graph] = (0...2).map({ $0 == 0 ? numericKeypad : directionalKeypad })

    var totalComplexity = 0

    for code in codes {
      let result = await findMinimumCostPath(code: code, using: keypads)
      let number = Int(code.trimmingCharacters(in: .letters)) ?? -1
      let complexity = result.cost * number
      print(code, result.cost, result.paths.count, number, complexity)
      totalComplexity += complexity
    }

    return totalComplexity
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() async -> Int {
    let codes = data.components(separatedBy: "\n")
    let numericKeypad = Graph.numericKeypad
    let directionalKeypad = Graph.directionalKeypad

    let keypads: [Graph] = (0...25).map({ $0 == 0 ? numericKeypad : directionalKeypad })

    var totalComplexity = 0

    for code in codes {
      let result = await findMinimumCostPath(code: code, using: keypads)
      let number = Int(code.trimmingCharacters(in: .letters)) ?? -1
      let complexity = result.cost * number
      print(code, result.cost, result.paths.count, number, complexity)
      totalComplexity += complexity
    }

    return totalComplexity
  }
}
