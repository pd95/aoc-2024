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

    var nextCheck = [(point: Point, direction: Direction, points: Set<Point>, score: Int)]()
    nextCheck.append((start, .east, Set(), 0))

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
            print(count, point, score, visitedPoints.count)
            result = score
            allBestPathPoints.formUnion(visitedPoints)
          } else if score == result {
            print("Reached end with same score \(score)")
            print(count, point, score, visitedPoints.count)
            allBestPathPoints.formUnion(visitedPoints)
          } else {
            print(score, "score is higher than previous result \(result)")
          }
        } else {

          var direction = direction
          var next = point.next(direction)
          if grid[next.y][next.x] != "#" && visitedPoints.contains(next) == false {
            let newScore = (point: next, direction: direction, points: visitedPoints.union([point]), score: score + 1)
            nextCheck.append(newScore)
          }
          direction = direction.left()
          next = point.next(direction)
          if grid[next.y][next.x] != "#" && visitedPoints.contains(next) == false {
            let newScore = (point: next, direction: direction, points: visitedPoints.union([point]), score: score + 1001)
            nextCheck.append(newScore)
          }
          direction = direction.opposite()
          next = point.next(direction)
          if grid[next.y][next.x] != "#" && visitedPoints.contains(next) == false {
            let newScore = (point: next, direction: direction, points: visitedPoints.union([point]), score: score + 1001)
            nextCheck.append(newScore)
          }
        }
      }

      if result != 0 {
        break
      }

      nextCheck.removeAll(where: { $0.score == minScore })
      count += 1
    }

//    print(allBestPathPoints)
//    for point in allBestPathPoints {
//      grid[point.y][point.x] = "O"
//    }
//    print(grid.map { String($0) }.joined(separator: "\n"))

    return allBestPathPoints.count
  }
}
