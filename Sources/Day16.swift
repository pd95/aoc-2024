import Algorithms

struct Day16: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Point: Equatable {
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
  }

  enum Direction: Character {
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
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
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

    var bestScore = Int.max
    var nextCheck = [(grid: [[Character]], point: Point, direction: Direction, score: Int)]()

    func checkShortestPath(through grid: [[Character]], from point: Point, facing direction: Direction, score: Int) {
      guard score <= bestScore else {
        return
      }
      if point == end {
        print("Reached end with score \(score)")
        if score < bestScore {
          bestScore = score
        }
      } else {

        var direction = direction
        var grid = grid
        let oldField = grid[point.y][point.x]

        //print(grid.map { String($0) }.joined(separator: "\n"))

        var next = point.next(direction)
        if grid[next.y][next.x] == "." || grid[next.y][next.x] == "E" {
          grid[point.y][point.x] = direction.rawValue
          nextCheck.append((grid, next, direction, score + 1))
          grid[point.y][point.x] = oldField
        }

        direction = direction.left()
        next = point.next(direction)
        if grid[next.y][next.x] == "." || grid[next.y][next.x] == "E" {
          grid[point.y][point.x] = direction.rawValue
          nextCheck.append((grid, next, direction, score + 1001))
          grid[point.y][point.x] = oldField
        }

        direction = direction.opposite()
        next = point.next(direction)
        if grid[next.y][next.x] == "." || grid[next.y][next.x] == "E" {
          grid[point.y][point.x] = direction.rawValue
          nextCheck.append((grid, next, direction, score + 1001))
          grid[point.y][point.x] = oldField
        }

        direction = direction.right()
        next = point.next(direction)
        if grid[next.y][next.x] == "." || grid[next.y][next.x] == "E" {
          grid[point.y][point.x] = direction.rawValue
          nextCheck.append((grid, next, direction, score + 2001))
          grid[point.y][point.x] = oldField
        }
      }
    }

    nextCheck.append((grid, start, .east, 0))
    while !nextCheck.isEmpty {
      let (grid, point, direction, score) = nextCheck.removeFirst()
      checkShortestPath(through: grid, from: point, facing: direction, score: score)
    }

    return bestScore
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    return result
  }
}
