import Algorithms

struct Day21: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  enum Direction: Character, RawRepresentable {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"
  }

  struct Position: Hashable {
    var row: Int
    var column: Int

    func distance(to other: Position) -> Int {
      abs(row - other.row) + abs(column - other.column)
    }

    mutating func move(to direction: Direction) {

    }
  }

  struct KeypadRobot {
    private var layout: [[Character]]

    private var dangerRow = 0
    private(set) var pointer: Position = Position(row: 0, column: 0)

    init(layout: [[Character]]) {
      self.layout = layout
      self.pointer = position(for: "A")
      self.dangerRow = position(for: " ").row
    }

    func position(for char: Character) -> Position {
      for row in layout.indices {
        for column in layout[row].indices {
          if layout[row][column] == char {
            return Position(row: row, column: column)
          }
        }
      }
      fatalError("🔴 char \(char) not found")
    }

    func character(for position: Position) -> Character {
      layout[position.row][position.column]
    }

    mutating func move(to char: Character) -> Set<String> {
      //print(#function, char)
      return move(to: position(for: char))
    }

    mutating func move(to target: Position) -> Set<String> {
      var directions = [Character]()
      //print(#function, pointer, target)

      directions += Array(repeating: "^", count: max(pointer.row-target.row, 0))
      directions += Array(repeating: "v", count: max(target.row-pointer.row, 0))
      directions += Array(repeating: ">", count: max(target.column-pointer.column, 0))
      directions += Array(repeating: "<", count: max(pointer.column-target.column, 0))

      var validPermutations: Set<String> = []
      for permutation in directions.permutations(ofCount: directions.count) {

        // Filter all invalid permutaions
        var isValid = true
        var testPointer = pointer
        for direction in directions.compactMap(Direction.init) {
          testPointer.move(to: direction)
          if layout[testPointer.row][testPointer.column] == " " {
            isValid = false
            break
          }
        }
        if isValid {
          validPermutations.insert(String(permutation))
        }
      }

      pointer = target
      //print(#function, pointer, target, validPermutations)
      return validPermutations
    }

    func costForSequence(_ sequence: String, start pointer: Position) -> Int {
      var pointer = pointer
      return sequence.reduce(0) { cost, char in
        let currentChar = character(for: pointer)
        if currentChar == " " {
          return cost + 1000000
        } else {
          let position = position(for: char)
          let moveCost = pointer.distance(to: position)
          pointer = position
          return cost + moveCost
        }
      }
    }

    static var numericKeypad: KeypadRobot {
      KeypadRobot(layout: [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        [" ", "0", "A"]
      ])
    }

    static var directionalKeypad: KeypadRobot {
      KeypadRobot(layout: [
        [" ", "^", "A"],
        ["<", "v", ">"]
      ])
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    var numpadRobot = KeypadRobot.numericKeypad
    var directionalKeypad = KeypadRobot.directionalKeypad
    var directionalKeypad2 = KeypadRobot.directionalKeypad

    for line in data.split(separator: "\n") {
      var numDirections = [""]
      for char in line {
        // Calculate possible directions for movement
        let directionPossibilities = numpadRobot.move(to: char)

        // Combine new solutions with existing
        numDirections = directionPossibilities.flatMap { possibility in
          numDirections.map {
            $0 + possibility + "A"
          }
        }
        //print(numDirections)
      }
      let sortedNumDirections = numDirections.map {
        (cost: directionalKeypad.costForSequence($0, start: directionalKeypad.pointer), directions: $0)
      }.sorted(by: { $0.cost <= $1.cost })
      let numpadSolution = sortedNumDirections.first!.directions
      print("Sorted numpad directions: \(numpadSolution)")


      var cursorDirections = [""]
      for char in numpadSolution {
        // Calculate possible directions for movement
        let directionPossibilities = directionalKeypad.move(to: char)

        // Combine new solutions with existing
        cursorDirections = directionPossibilities.flatMap { possibility in
          cursorDirections.map {
            $0 + possibility + "A"
          }
        }

      }
      //print("Cursor directions: \(cursorDirections)")
      let sortedCursorDirections = cursorDirections.map {
        (cost: directionalKeypad2.costForSequence($0, start: directionalKeypad2.pointer), directions: $0)
      }.sorted(by: { $0.cost <= $1.cost })
      let cursor1Solution = sortedCursorDirections.first!.directions
      print("Sorted numpad directions: \(cursor1Solution)")


      var cursorDirections2 = [""]
      for char in sortedCursorDirections.first!.directions {
        // Calculate possible directions for movement
        let directionPossibilities = directionalKeypad2.move(to: char)

        // Combine new solutions with existing
        cursorDirections2 = directionPossibilities.flatMap { possibility in
          cursorDirections2.map {
            $0 + possibility + "A"
          }
        }
      }

      let sortedCursorDirections2 = cursorDirections2.map {
        (cost: $0.count, directions: $0)
      }.sorted(by: { $0.cost <= $1.cost })

      let cursor2Solution = sortedCursorDirections2.first!.directions
      print("Sorted numpad directions: \(cursor2Solution)")

      let number = Int(line.trimmingCharacters(in: .letters)) ?? -1
      let complexity = cursor2Solution.count * number
      print(line, "directions: \(cursor2Solution) (length \(cursor2Solution.count))", complexity)
      result += complexity
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    return result
  }
}
