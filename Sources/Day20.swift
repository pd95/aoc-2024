import Algorithms

struct Day20: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Point: Equatable, Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    var left: Point {
      Point(x: x-1, y: y)
    }

    var right: Point {
      Point(x: x+1, y: y)
    }

    var up: Point {
      Point(x: x, y: y-1)
    }

    var down: Point {
      Point(x: x, y: y+1)
    }

    var description: String { "(\(x), \(y))" }
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
      if let startIndex = line.firstIndex(of: "S") {
        start = Point(
          x: line.distance(from: line.startIndex, to: startIndex),
          y: grid.count - 1
        )
        grid[start.y][start.x] = "."
        //print("start at \(start)")
      }
      else if let startIndex = line.firstIndex(of: "E") {
        end = Point(
          x: line.distance(from: line.startIndex, to: startIndex),
          y: grid.count - 1
        )
        grid[end.y][end.x] = "."
        //print("end at \(end)")
      }
    }

    assert(start != Point(x: 0, y: 0))
    assert(start != end)

    func printGrid() {
      for row in grid {
        for char in row {
          print(char, terminator: "")
        }
        print()
      }
    }

    func charAt(_ point: Point) -> Character? {
      if point.x < 0 || point.y < 0 || point.x >= grid[0].count || point.y >= grid.count {
        return nil
      }
      return grid[point.y][point.x]
    }

    func accessiblePoint(_ point: Point) -> Point? {
      return charAt(point) == "." ? point : nil
    }

    var cheatPathLengths: [Int: [[Point]]] = [:]
    var distanceFromStart: [Point: Int] = [:]
    var regularPath: [Point] = []
    var regularPathLength = 0

    func calcRegularPathLength(point: Point, length: Int = 0) {

      // register distance
      distanceFromStart[point] = length
      regularPath.append(point)

      if point == end {
        regularPathLength = length
      }

      grid[point.y][point.x] = "o"
      defer { grid[point.y][point.x] = "." }

      if let next = accessiblePoint(point.left) {
        print("left")
        calcRegularPathLength(point: next, length: length + 1)
      }
      if let next = accessiblePoint(point.up) {
        print("up")
        calcRegularPathLength(point: next, length: length + 1)
      }
      if let next = accessiblePoint(point.right) {
        print("right")
        calcRegularPathLength(point: next, length: length + 1)
      }
      if let next = accessiblePoint(point.down) {
        print("down")
        calcRegularPathLength(point: next, length: length + 1)
      }
    }

    calcRegularPathLength(point: start)
    printGrid()

    for point in regularPath {
      let regularDistance = distanceFromStart[point]!
      var cheatStart = point.right
      if distanceFromStart[cheatStart] == nil {
        let cheatEnd = cheatStart.right
        if let nextDistance = distanceFromStart[cheatEnd] {
          if nextDistance > regularDistance {
            let savedTime = (nextDistance - regularDistance - 2)
            //print(savedTime, nextDistance, regularDistance)
            cheatPathLengths[savedTime, default: []].append([cheatStart, cheatEnd])
          }
        }
      }
      cheatStart = point.left
      if distanceFromStart[cheatStart] == nil {
        let cheatEnd = cheatStart.left
        if let nextDistance = distanceFromStart[cheatEnd] {
          if nextDistance > regularDistance {
            let savedTime = (nextDistance - regularDistance - 2)
            //print(savedTime, nextDistance, regularDistance)
            cheatPathLengths[savedTime, default: []].append([cheatStart, cheatEnd])
          }
        }
      }
      cheatStart = point.up
      if distanceFromStart[cheatStart] == nil {
        let cheatEnd = cheatStart.up
        if let nextDistance = distanceFromStart[cheatEnd] {
          if nextDistance > regularDistance {
            let savedTime = (nextDistance - regularDistance - 2)
            //print(savedTime, nextDistance, regularDistance)
            cheatPathLengths[savedTime, default: []].append([cheatStart, cheatEnd])
          }
        }
      }
      cheatStart = point.down
      if distanceFromStart[cheatStart] == nil {
        let cheatEnd = cheatStart.down
        if let nextDistance = distanceFromStart[cheatEnd] {
          if nextDistance > regularDistance {
            let savedTime = (nextDistance - regularDistance - 2)
            //print(savedTime, nextDistance, regularDistance)
            cheatPathLengths[savedTime, default: []].append([cheatStart, cheatEnd])
          }
        }
      }
    }

    if grid.count < 20 {
      var totalCheats = 0
      for length in cheatPathLengths.keys.sorted() {
        let cheatCount = cheatPathLengths[length]!.count
        print("\(cheatCount) cheats that save \(length) picoseconds")
        totalCheats += cheatCount
      }
      
      print("Total cheats: \(totalCheats)")
      result = totalCheats
    } else {
      var totalCheats = 0
      for length in cheatPathLengths.keys.sorted() {
        if length >= 100 {
          let cheatCount = cheatPathLengths[length]!.count
          print("\(cheatCount) cheats that save \(length) picoseconds")
          totalCheats += cheatCount
        }
      }

      print("Total cheats: \(totalCheats)")
      result = totalCheats
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    return result
  }
}
