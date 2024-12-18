import Algorithms

struct Day18: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Point: Equatable, Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    func next(_ direction: Direction) -> Point {
      switch direction {
      case .north: return Point(x: x, y: y - 1)
      case .south: return Point(x: x, y: y + 1)
      case .east: return Point(x: x + 1, y: y)
      case .west: return Point(x: x - 1, y: y)
      }
    }

    func distance(to other: Point) -> Int {
      abs(other.x - x) + abs(other.y - y)
    }

    var description: String { "(\(x), \(y))" }
  }

  enum Direction: Character, CustomStringConvertible {
    case north = "^"
    case south = "v"
    case east = ">"
    case west = "<"

    func left() -> Direction {
      switch self {
      case .north: return .west
      case .south: return .east
      case .east: return .north
      case .west: return .south
      }
    }

    func opposite() -> Direction {
      switch self {
      case .north: return .south
      case .south: return .north
      case .east: return .west
      case .west: return .east
      }
    }

    func right() -> Direction {
      switch self {
      case .north: return .east
      case .south: return .west
      case .east: return .south
      case .west: return .north
      }
    }

    var description: String { String(rawValue) }
  }


  func findPath(start point: Point, in grid: [[Character]]) -> [Direction] {
    var nextCheck = [Point: (path: [Direction], score: Int)]()
    nextCheck[point] = ([], 0)

    var count = 0
    var visitedPoints = Set<Point>()
    while !nextCheck.isEmpty {
      guard let nextEntry = nextCheck.filter({ visitedPoints.contains($0.key) == false })
        .min(by: { $0.value.score < $1.value.score }) else {
        break
      }
      let point = nextEntry.key
      let (path, score) = nextEntry.value

      //print(count, point, score, nextCheck.count)

      if grid[point.y][point.x] == "E" {
        //print("Reached end with score \(score)")
        return path
      }

      var direction = path.last ?? .east
      var next = point.next(direction)
      if next.x >= 0 && next.y >= 0 && next.x < grid[0].count && next.y < grid.count {
        if grid[next.y][next.x] != "#" {
          let newScore = (path: path + [direction], score: score + 1)
          if (nextCheck[next]?.score ?? Int.max) > newScore.score {
            nextCheck[next] = newScore
          }
        }
      }

      direction = direction.left()
      next = point.next(direction)
      if next.x >= 0 && next.y >= 0 && next.x < grid[0].count && next.y < grid.count {
        if grid[next.y][next.x] != "#" {
          let newScore = (path: path + [direction], score: score + 1)
          if (nextCheck[next]?.score ?? Int.max) > newScore.score {
            nextCheck[next] = newScore
          }
        }
      }

      direction = direction.opposite()
      next = point.next(direction)
      if next.x >= 0 && next.y >= 0 && next.x < grid[0].count && next.y < grid.count {
        if grid[next.y][next.x] != "#" {
          let newScore = (path: path + [direction], score: score + 1)
          if (nextCheck[next]?.score ?? Int.max) > newScore.score {
            nextCheck[next] = newScore
          }
        }
      }

      visitedPoints.insert(point)
      count += 1
    }

    return []
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> String {
    var result = 0

    let lines = data.components(separatedBy: .newlines)
    let size = lines.count < 1024 ? 7 : 71
    let lineCount = lines.count < 1024 ? 12 : 1024

    let start = Point(x: 0, y: 0)
    var grid = Array(repeating: [Character](repeating: ".", count: size), count: size)
    grid[grid.count - 1][grid[0].count - 1] = "E"

    for line in lines[..<lineCount] {
      let coordinates: [Int] = line.split(separator: ",").compactMap({ Int($0) })
      grid[coordinates[1]][coordinates[0]] = "#"
    }

    //print("Grid")
    //print(grid.map { String($0) }.joined(separator: "\n"))

    let path = findPath(start: start, in: grid)
    result = path.count

//    for (y, row) in grid.enumerated() {
//      for (x, bit) in row.enumerated() {
//        var char = grid[y][x]
//        if visitedPoints.contains(Point(x: x, y: y)) {
//          char = "O"
//        }
//        print(char, terminator: "")
//      }
//      print()
//    }

    return String(result)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> String {
    let lines = data.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
    let size = lines.count < 1024 ? 7 : 71
    let lineCount = lines.count < 1024 ? 12 : 1024

    let start = Point(x: 0, y: 0)
    var grid = Array(repeating: [Character](repeating: ".", count: size), count: size)
    grid[grid.count - 1][grid[0].count - 1] = "E"

    var coordinates = [Point]()
    for line in lines {
      let data = line.split(separator: ",").compactMap({ Int($0) })
      if data.count == 2 {
        coordinates.append(Point(x: data[0], y: data[1]))
      }
    }

    func gridWithObstacles(_ grid: [[Character]], at points: any Sequence<Point>) -> [[Character]] {
      var grid = grid
      for point in points {
        grid[point.y][point.x] = "#"
      }
      return grid
    }

    // Use binary search implemented in Swift Algorithms package!
    let badIndex = coordinates.indices.partitioningIndex(where: { index in
      findPath(start: start, in: gridWithObstacles(grid, at: coordinates[...index])).isEmpty
    })

    let badPoint = coordinates[badIndex]

    return "\(badPoint.x),\(badPoint.y)"
  }
}
