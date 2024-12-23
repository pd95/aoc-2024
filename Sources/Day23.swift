import Algorithms

struct Day23: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    var allComputers = Set<String>()
    var allConnections: [String: Set<String>] = [:]

    for line in data.split(separator: .newlineSequence) {
      let computers = line.components(separatedBy: "-")
      allComputers.insert(computers[0])
      allComputers.insert(computers[1])

      allConnections[computers[0], default: []].insert(computers[1])
      allConnections[computers[1], default: []].insert(computers[0])
    }

    // Find all connections of a computer starting with "t", having more than 3 connections
    let c = allComputers.filter {
      $0.hasPrefix("t") && allConnections[$0, default: []].count >= 3
    }.map { mainComputer in
      //print("mainComputer", mainComputer)
      var sets = Set<[String]>()
      let mainConnections = allConnections[mainComputer, default: []]
      for neighborComputer in mainConnections {
        //print("neighborComputer", neighborComputer)
        let connections = allConnections[neighborComputer, default: []]
        let intersection = connections.intersection(mainConnections)
        //print("intersection has \(intersection.count) elements")
        for neigbor2Computer in intersection {
          let newLAN = [mainComputer, neighborComputer, neigbor2Computer].sorted()
          //print("  adding ", newLAN)
          sets.insert(newLAN)
        }
      }
      //print(sets)
      //return (key: mainComputer, value: sets, count: sets.count)
      return sets
    }.reduce(Set<[String]>()) { $0.union($1) }

    result = c.count

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> String {
    var result = ""

    var allConnections: [String: Set<String>] = [:]

    for line in data.split(separator: .newlineSequence) {
      let computers = line.components(separatedBy: "-")
      allConnections[computers[0], default: [computers[0]]].insert(computers[1])
      allConnections[computers[1], default: [computers[1]]].insert(computers[0])
    }

    let x = allConnections
      .mapValues { connections in
        var intersect: Set<String> = connections
        //print("connections.count \(connections.count)")
        for connection in connections {
          if connections.intersection(allConnections[connection]!).count < connections.count - 1 {
            intersect.remove(connection)
          }
        }
        //print("intersect.count \(intersect.count)")
        return (set: intersect, count: intersect.count)
      }
      .max { lhs, rhs in
        lhs.value.count <= rhs.value.count
      }
      .map(\.value.set)

    result = x!.sorted().joined(separator: ",")
    print(result)

    return result
  }
}
