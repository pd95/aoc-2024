import Algorithms
import Foundation

struct Day14: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var gridWidth: Int = 101
  var gridHeight: Int = 103

  init(data: String) {
    self.data = data
  }

  init(data: String, gridWidth: Int, gridHeight: Int) {
    self.data = data
    self.gridWidth = gridWidth
    self.gridHeight = gridHeight
  }

  struct Position: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    var description: String {
      "(\(x),\(y))"
    }
  }

  private class Robot: Hashable, CustomStringConvertible {
    let id = UUID()
    var position: Position
    var velocity: Position
    var gridWidth: Int
    var gridHeight: Int

    init(position: Position, velocity: Position, gridWidth: Int, gridHeight: Int) {
      self.position = position
      self.velocity = velocity
      self.gridWidth = gridWidth
      self.gridHeight = gridHeight
    }

    func move() {
      position.x = (position.x + velocity.x + gridWidth) % gridWidth
      position.y = (position.y + velocity.y + gridHeight) % gridHeight
    }

    var description: String {
      "p=\(position) v=\(velocity)"
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: Robot, rhs: Robot) -> Bool {
      lhs.id == rhs.id
    }
  }

  private class Grid: CustomStringConvertible {
    let width: Int
    let height: Int
    private(set) var robots: Set<Robot> = []

    init(width: Int, height: Int) {
      self.width = width
      self.height = height
    }

    var cells: [[[Robot]]] {
      var cells = Array(repeating: Array(repeating: [Robot](), count: width), count: height)
      robots.forEach { cells[$0.position.y][$0.position.x].append($0) }
      return cells
    }

    var occupiedCells: [[Int]] {
      var cells = Array(repeating: Array(repeating: 0, count: width), count: height)
      robots.forEach {
        cells[$0.position.y][$0.position.x] += 1
      }
      return cells
    }

    var description: String {
      occupiedCells.map({ $0.reduce("", { $0 + ($1 == 0 ? "." : "\($1)") }) })
        .joined(separator: "\n")
    }

    func addRobot(_ robot: Robot) {
      robots.insert(robot)
    }

    func moveRobots() {
      robots.forEach {
        $0.move()
      }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    let grid = Grid(width: gridWidth, height: gridHeight)

    let regex = /p=(?<px>\d+),(?<py>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)\n*/

    var startRange = data.startIndex
    while let match = try? regex.firstMatch(in: data[startRange...]) {
      startRange = match.range.upperBound

      let position = Position(x: Int(match.output.px)!, y: Int(match.output.py)!)
      let velocity = Position(x: Int(match.output.vx)!, y: Int(match.output.vy)!)
      let robot = Robot(
        position: position, velocity: velocity, gridWidth: gridWidth, gridHeight: gridHeight)
      grid.addRobot(robot)
    }

    //print("--- Start ---")
    //print(grid.description)

    for _ in 1...100 {
      grid.moveRobots()
    }
    //print("--- after \(100) seconds ---")
    //print(grid.description)

    let occupiedCells = grid.occupiedCells
    var quadrantCounts: [Int] = Array(repeating: 0, count: 4)
    for y in 0..<gridHeight {
      if y == gridHeight / 2 {
        continue
      }
      for x in 0..<gridWidth {
        if x == gridWidth / 2 {
          continue
        }
        let quadrant = 2 * x / gridWidth + (2 * y / gridHeight) * 2
        let count = occupiedCells[y][x]
        quadrantCounts[quadrant] += count
      }
    }

    result = quadrantCounts.reduce(1, *)
    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    let grid = Grid(width: gridWidth, height: gridHeight)

    let regex = /p=(?<px>\d+),(?<py>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)\n*/

    var startRange = data.startIndex
    while let match = try? regex.firstMatch(in: data[startRange...]) {
      startRange = match.range.upperBound

      let position = Position(x: Int(match.output.px)!, y: Int(match.output.py)!)
      let velocity = Position(x: Int(match.output.vx)!, y: Int(match.output.vy)!)
      let robot = Robot(
        position: position, velocity: velocity, gridWidth: gridWidth, gridHeight: gridHeight)
      grid.addRobot(robot)
    }

    var i = 1
    while i < 10000 {
      grid.moveRobots()

      let occupiedCells = grid.occupiedCells

      for y in 0..<gridHeight {
        var continousCount = 0
        for x in 0..<gridWidth {
          if occupiedCells[y][x] == 1 {
            continousCount += 1
          } else {
            if continousCount >= 10 {
              print("--- after \(i) seconds ---")
              print("Found \(continousCount) continuous cells at \(x),\(y)")
              print(grid.description)
              return i
            }
            continousCount = 0
          }
        }
      }
      i += 1
    }

    return 0
  }
}
