import Algorithms

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Point: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String {
      "(\(x), \(y))"
    }
  }

  func distinctReachableEndpoints(start: Point, map: [[Int]]) -> Set<Point> {
    var endPoints: Set<Point> = []

    let height = map[start.y][start.x]
    //print(#function, start, height)
    if height == 9 {
      return [start]
    }
    let neighbors: [Point] = [
      Point(x: start.x + 1, y: start.y),
      Point(x: start.x - 1, y: start.y),
      Point(x: start.x, y: start.y + 1),
      Point(x: start.x, y: start.y - 1),
    ]

    let nextLevel = height + 1
    let mapHeight = map.count
    let mapWidth = map[0].count
    neighbors.forEach { neighbor in
      guard neighbor.x >= 0 && neighbor.x < mapWidth && neighbor.y >= 0 && neighbor.y < mapHeight else { return }
      if map[neighbor.y][neighbor.x] == nextLevel {
        endPoints.formUnion(distinctReachableEndpoints(start: neighbor, map: map))
      }
    }

    return endPoints
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0
    let map: [[Int]] = data.split(separator: "\n")
      .map({
        $0.split(separator: "")
          .map({ Int($0)! })
      })

    for (y, row) in map.enumerated() {
      for (x, column) in row.enumerated() {
        if column == 0 {
          result += distinctReachableEndpoints(start: Point(x: x, y: y), map: map).count
        }
      }
    }

    return result
  }


  func distinctHikingTrails(trail: [Point],  map: [[Int]]) -> Set<[Point]> {
    let start = trail.last!

    let height = map[start.y][start.x]
    //print(#function, start, height)
    if height == 9 {
      return [trail]
    }

    var newTrails: Set<[Point]> = []
    let neighbors: [Point] = [
      Point(x: start.x + 1, y: start.y),
      Point(x: start.x - 1, y: start.y),
      Point(x: start.x, y: start.y + 1),
      Point(x: start.x, y: start.y - 1),
    ]

    let nextLevel = height + 1
    let mapHeight = map.count
    let mapWidth = map[0].count
    neighbors.forEach { neighbor in
      guard neighbor.x >= 0 && neighbor.x < mapWidth && neighbor.y >= 0 && neighbor.y < mapHeight else { return }
      if map[neighbor.y][neighbor.x] == nextLevel {
        newTrails.formUnion(distinctHikingTrails(trail: trail + [neighbor], map: map))
      }
    }

    return newTrails
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0
    let map: [[Int]] = data.split(separator: "\n")
      .map({
        $0.split(separator: "")
          .map({ Int($0)! })
      })

    for (y, row) in map.enumerated() {
      for (x, column) in row.enumerated() {
        if column == 0 {
          result += distinctHikingTrails(trail: [Point(x: x, y: y)], map: map).count
        }
      }
    }

    return result
  }
}
