import Algorithms

struct Day15: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Point {
    var x: Int
    var y: Int

    mutating func move(_ direction: Character) {
      x += direction == ">" ? 1 : direction == "<" ? -1 : 0
      y += direction == "^" ? -1 : direction == "v" ? 1 : 0
    }

    func moved(by direction: Character) -> Point {
      var newPoint = self
      newPoint.move(direction)
      return newPoint
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    var grid: [[Character]] = []
    var movements: [Character] = []
    var robot = Point(x: 0, y: 0)

    // Parse the input data
    for line in data.components(separatedBy: .newlines) {
      if let robotIndex = line.firstIndex(of: "@") {
        robot = Point(
          x: line.distance(from: line.startIndex, to: robotIndex),
          y: grid.count
        )
        //print("Robot at \(robot)")
      }
      if line.contains("#") {
        grid.append(Array(line))
      } else {
        movements.append(contentsOf: line)
      }
    }

    //print("Grid")
    //print(grid.map { String($0) }.joined(separator: "\n"))
    //print(String(movements))

    func canMove(from position: Point, by direction: Character) -> Bool {
      let newPosition = position.moved(by: direction)

      guard newPosition.x >= 0 && newPosition.y >= 0 else { return false }
      guard newPosition.x < grid[newPosition.y].count else { return false }
      if grid[newPosition.y][newPosition.x] == "#" { return false }
      if grid[newPosition.y][newPosition.x] == "O" {
        return canMove(from: newPosition, by: direction)
      }

      //print("can move to \(newPosition): \(grid[newPosition.y][newPosition.x])")
      return true
    }

    func moveCell(from position: Point, by direction: Character) {
      let newPosition = position.moved(by: direction)
      guard grid[newPosition.y][newPosition.x] != "#" else {
        fatalError("Moving into a wall!")
      }
      if grid[newPosition.y][newPosition.x] == "O" {
        moveCell(from: newPosition, by: direction)
      }
      guard grid[newPosition.y][newPosition.x] == "." else {
        fatalError("Box didn't move!")
      }
      grid[newPosition.y][newPosition.x] = grid[position.y][position.x]
      grid[position.y][position.x] = "."
    }

    // Process all movements
    while let direction = movements.first {
      movements.removeFirst()

      //print("Move \(direction):")
      if canMove(from: robot, by: direction) {
        moveCell(from: robot, by: direction)
        robot.move(direction)
      }
      //print(grid.map { String($0) }.joined(separator: "\n"))
      //print(String(movements))
    }

    // Calculate sum of GPS positons
    for (row, gridRow) in grid.enumerated() {
      let positions = gridRow.enumerated().filter({ $0.element == "O" })
        .map(\.offset)
      for position in positions {
        //print("\(position): \(row * 100 + position)")
        result += row * 100 + position
      }
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    var grid: [[Character]] = []
    var movements: [Character] = []
    var robot = Point(x: 0, y: 0)

    // Parse the input data
    for line in data.components(separatedBy: .newlines) {
      if let robotIndex = line.firstIndex(of: "@") {
        robot = Point(
          x: line.distance(from: line.startIndex, to: robotIndex)*2,
          y: grid.count
        )
        //print("Robot at \(robot)")
      }
      if line.contains("#") {
        var newLine = ""
        for char in line {

          let block: String
          switch char {
            case "#": block = "##"
            case "O": block = "[]"
            case "@": block = "@."
            default: block = ".."
          }
          newLine.append(block)
        }
        grid.append(Array(newLine))
      } else {
        movements.append(contentsOf: line)
      }
    }

    //print("Grid")
    //print(grid.map { String($0) }.joined(separator: "\n"))
    //print(String(movements))

    func canMove(from position: Point, by direction: Character) -> Bool {
      let newPosition = position.moved(by: direction)

      guard newPosition.x >= 0 && newPosition.y >= 0 else { return false }
      guard newPosition.x < grid[newPosition.y].count else { return false }
      if grid[newPosition.y][newPosition.x] == "#" { return false }
      if grid[newPosition.y][newPosition.x] == "[" {
        if direction == "^" || direction == "v" {
          return canMove(from: newPosition, by: direction) && canMove(from: Point(x: newPosition.x+1, y: newPosition.y), by: direction)
        } else {
          return canMove(from: newPosition, by: direction)
        }
      } else if grid[newPosition.y][newPosition.x] == "]" {
        if direction == "^" || direction == "v" {
          return canMove(from: newPosition, by: direction) && canMove(from: Point(x: newPosition.x-1, y: newPosition.y), by: direction)
        } else {
          return canMove(from: newPosition, by: direction)
        }
      }

      //print("can move to \(newPosition): \(grid[newPosition.y][newPosition.x])")
      return true
    }

    func moveCell(from position: Point, by direction: Character) {
      let newPosition = position.moved(by: direction)
      guard grid[newPosition.y][newPosition.x] != "#" else {
        fatalError("Moving into a wall!")
      }
      if grid[newPosition.y][newPosition.x] == "[" {
        if direction == "^" || direction == "v" {
          moveCell(from: Point(x: newPosition.x+1, y: newPosition.y), by: direction)
        }
        moveCell(from: newPosition, by: direction)
      } else if grid[newPosition.y][newPosition.x] == "]" {
        if direction == "^" || direction == "v" {
          moveCell(from: Point(x: newPosition.x-1, y: newPosition.y), by: direction)
        }
        moveCell(from: newPosition, by: direction)
      }
      guard grid[newPosition.y][newPosition.x] == "." else {
        fatalError("Box didn't move!")
      }
      grid[newPosition.y][newPosition.x] = grid[position.y][position.x]
      grid[position.y][position.x] = "."
    }

    // Process all movements
    while let direction = movements.first {
      movements.removeFirst()

      //print("Move \(direction):")
      if canMove(from: robot, by: direction) {
        moveCell(from: robot, by: direction)
        robot.move(direction)
      }
      //print(grid.map { String($0) }.joined(separator: "\n"))
      //print(String(movements))
    }

    // Calculate sum of GPS positons
    for (row, gridRow) in grid.enumerated() {
      let positions = gridRow.enumerated().filter({ $0.element == "[" })
        .map(\.offset)
      for position in positions {
        //print("\(position): \(row * 100 + position)")
        result += row * 100 + position
      }
    }

    return result
  }
}
