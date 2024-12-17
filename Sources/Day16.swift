import Algorithms

struct Day16: AdventDay {
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

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    var grid: [[Character]] = []
    var start = Point(x: 0, y: 0)

    // Parse the input data
    for line in data.components(separatedBy: .newlines) {
      grid.append(Array(line))
      if let startIndex = line.firstIndex(of: "S") {
        start = Point(
          x: line.distance(from: line.startIndex, to: startIndex),
          y: grid.count - 1
        )
        grid[start.y][start.x] = "."
        //print("start at \(start)")
      }
    }

    var nextCheck = [Point: (path: [Direction], score: Int)]()
    nextCheck[start] = ([], 0)

    //print("Grid")
    //print(grid.map { String($0) }.joined(separator: "\n"))


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
        print("Reached end with score \(score)")
        result = score
        break
      }

      var direction = path.last ?? .east
      var next = point.next(direction)
      if grid[next.y][next.x] != "#" {
        let newScore = (path: path + [direction], score: score + 1)
        if (nextCheck[next]?.score ?? Int.max) > newScore.score {
          nextCheck[next] = newScore
        }
      }
      direction = direction.left()
      next = point.next(direction)
      if grid[next.y][next.x] != "#" {
        let newScore = (path: path + [direction], score: score + 1001)
        if (nextCheck[next]?.score ?? Int.max) > newScore.score {
          nextCheck[next] = newScore
        }
      }
      direction = direction.opposite()
      next = point.next(direction)
      if grid[next.y][next.x] != "#" {
        let newScore = (path: path + [direction], score: score + 1001)
        if (nextCheck[next]?.score ?? Int.max) > newScore.score {
          nextCheck[next] = newScore
        }
      }

      visitedPoints.insert(point)
      count += 1
    }

    return result
  }

  struct BitGrid {
    var grid: [BitArray]

    init(width: Int, height: Int) {
      grid = Array(repeating: BitArray(repeating: false, count: width), count: height)
    }

    mutating func merge(with other: BitGrid) {
      for (y, row) in other.grid.enumerated() {
        for (x, bit) in row.enumerated() {
          if bit {
            grid[y][x] = true
          }
        }
      }
    }

    mutating func visit(at point: Point) {
      grid[point.y][point.x] = true
    }

    func visited(at point: Point) -> BitGrid {
      var newGrid = self
      newGrid.grid[point.y][point.x] = true
      return newGrid
    }

    func isVisited(at point: Point) -> Bool {
      grid[point.y][point.x]
    }

    var points: Set<Point> {
      var visitedPoints = Set<Point>()
      for (y, row) in grid.enumerated() {
        for (x, bit) in row.enumerated() {
          if bit {
            visitedPoints.insert(Point(x: x, y: y))
          }
        }
      }
      return visitedPoints
    }

    func print(_ charGrid: [[Character]]? = nil) -> String {
      var chars = [Character]()
      for (y, row) in grid.enumerated() {
        for (x, bit) in row.enumerated() {
          chars.append(bit ? "O" : (charGrid?[y][x] ?? "."))
        }
        chars.append("\n")
      }
      return String(chars)
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    var grid: [[Character]] = []
    var start = Point(x: 0, y: 0)
    var end = Point(x: 0, y: 0)

    // Parse the input data
    for line in data.components(separatedBy: .newlines) {
      grid.append(Array(line))
      if let endIndex = line.firstIndex(of: "E") {
        end = Point(
          x: line.distance(from: line.startIndex, to: endIndex),
          y: grid.count - 1
        )
        print("End at \(end)")
      }
      if let startIndex = line.firstIndex(of: "S") {
        start = Point(
          x: line.distance(from: line.startIndex, to: startIndex),
          y: grid.count - 1
        )
        grid[start.y][start.x] = "."
        print("start at \(start)")
      }
    }

    let bitGrid = BitGrid(width: grid[0].count, height: grid.count).visited(at: start)

    var nextCheck = [(point: Point, direction: Direction, grid: BitGrid, score: Int)]()
    nextCheck.append((start, .east, bitGrid, 0))

    //print("Grid")
    //print(grid.map { String($0) }.joined(separator: "\n"))


    var count = 0
    var allBestPathPoints = Set<Point>()
    allBestPathPoints.insert(start)
    allBestPathPoints.insert(end)

    while !nextCheck.isEmpty {
      nextCheck.sort(by: { lhs, rhs in
        if lhs.score == rhs.score {
          return lhs.point.distance(to: end) < rhs.point.distance(to: end)
        }
        return lhs.score < rhs.score
      })

      let minScore = nextCheck[0].score
      let nextPoints = nextCheck.filter({ $0.score == minScore })
      print(count, "min score \(minScore) found for \(nextPoints.count) points", nextCheck[0].point)
      for (point, direction, visitedPoints, score) in nextPoints {

        //print(count, point, score, visitedPoints.count)

        if grid[point.y][point.x] == "E" {
          if result == 0 {
            print("First reached end with score \(score)")
            print(count, point, score, visitedPoints.points.count)
            result = score
            allBestPathPoints.formUnion(visitedPoints.points)
          } else if score == result {
            print("Reached end with same score \(score)")
            print(count, point, score, visitedPoints.points.count)
            allBestPathPoints.formUnion(visitedPoints.points)
          } else {
            print(score, "score is higher than previous result \(result)")
          }
        } else {

          var direction = direction
          var next = point.next(direction)
          if grid[next.y][next.x] != "#" && visitedPoints.isVisited(at: next) == false {
            let newScore = (point: next, direction: direction, grid: visitedPoints.visited(at: point), score: score + 1)
            if let index = nextCheck.firstIndex(where: { $0.point == newScore.point && $0.score == newScore.score && $0.direction == newScore.direction }) {
              nextCheck[index].grid.merge(with: newScore.grid)
            } else {
              nextCheck.append(newScore)
            }
          }
          direction = direction.left()
          next = point.next(direction)
          if grid[next.y][next.x] != "#" && visitedPoints.isVisited(at: next) == false {
            let newScore = (point: next, direction: direction, grid: visitedPoints.visited(at: point), score: score + 1001)
            if let index = nextCheck.firstIndex(where: { $0.point == newScore.point && $0.score == newScore.score && $0.direction == newScore.direction }) {
              nextCheck[index].grid.merge(with: newScore.grid)
            } else {
              nextCheck.append(newScore)
            }
          }
          direction = direction.opposite()
          next = point.next(direction)
          if grid[next.y][next.x] != "#" && visitedPoints.isVisited(at: next) == false {
            let newScore = (point: next, direction: direction, grid: visitedPoints.visited(at: point), score: score + 1001)
            if let index = nextCheck.firstIndex(where: { $0.point == newScore.point && $0.score == newScore.score && $0.direction == newScore.direction }) {
              nextCheck[index].grid.merge(with: newScore.grid)
            } else {
              nextCheck.append(newScore)
            }
          }
        }
      }

      if result != 0 {
        break
      }

      nextCheck.removeAll(where: { $0.score == minScore })
      count += 1
    }

    return allBestPathPoints.count
  }
}
