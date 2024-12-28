import Algorithms

struct Day21: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Position: Hashable {
    var row: Int
    var column: Int

    func distance(to other: Position) -> Int {
      abs(row - other.row) + abs(column - other.column)
    }
  }

  struct KeypadRobot {
    private(set) var layout: [[Character]]

    private(set) var dangerPosition: Position = Position(row: 0, column: 0)
    private(set) var pointer: Position = Position(row: 0, column: 0)

    init(layout: [[Character]]) {
      self.layout = layout
      self.pointer = position(for: "A")
      self.dangerPosition = position(for: " ")
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
      if position.row < 0 || position.column < 0 || position.row >= layout.count || position.column >= layout[position.row].count {
        return " "
      }
      return layout[position.row][position.column]
    }

    mutating func move(to char: Character) -> Set<String> {
      //print(#function, char)
      return move(to: position(for: char))
    }

    mutating func move(to target: Position) -> Set<String> {
      //print(#function, pointer, target)
      var validDirections = Set<String>()

      var directions1 = [Character]()
      var directions2 = [Character]()

      let corner1 = Position(row: target.row, column: pointer.column)
      if corner1 != dangerPosition {
        if pointer.row-target.row >= 0 {
          directions1 += Array(repeating: "^", count: pointer.row-target.row)
        } else {
          directions1 += Array(repeating: "v", count: target.row-pointer.row)
        }
        if pointer.column-target.column >= 0 {
          directions1 += Array(repeating: "<", count: pointer.column-target.column)
        } else {
          directions1 += Array(repeating: ">", count: target.column-pointer.column)
        }
        validDirections.insert(String(directions1))
      }

      let corner2 = Position(row: pointer.row, column: target.column)
      if corner2 != dangerPosition {
        if pointer.column-target.column >= 0 {
          directions2 += Array(repeating: "<", count: pointer.column-target.column)
        } else {
          directions2 += Array(repeating: ">", count: target.column-pointer.column)
        }
        if pointer.row-target.row >= 0 {
          directions2 += Array(repeating: "^", count: pointer.row-target.row)
        } else {
          directions2 += Array(repeating: "v", count: target.row-pointer.row)
        }
        validDirections.insert(String(directions2))
      }

      pointer = target
      //print("valid directions: \(validDirections)")
      return validDirections
    }

    mutating func move(sequence: String) -> [String] {
      var nextCommands = [""]
      for char in sequence {
        // Calculate possible directions for movement
        let commands = self.move(to: char)

        // Combine new solutions with existing
        nextCommands = commands.flatMap { possibility in
          nextCommands.map {
            $0 + possibility + "A"
          }
        }
      }
      return nextCommands
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

    for line in data.split(separator: "\n") {
      print(line)
      let number = Int(line.trimmingCharacters(in: .letters)) ?? -1
      var complexity = 0
      var shortestPathLength = Int.max

      let numDirections = numpadRobot.move(sequence: String(line))

      print(numDirections.map({ ($0.count, $0) }), numDirections.count, line)
      print("-----")

      for numpadSolution in numDirections {
        print(line)
        print(numpadSolution)

        var directionalKeypad = KeypadRobot.directionalKeypad
        let cursorDirections = directionalKeypad.move(sequence: numpadSolution)

        print(cursorDirections.map({ ($0.count, $0) }), cursorDirections.count, line)
        print("-----")

        for cursorDirection in cursorDirections {

          print(line)
          print(numpadSolution)
          print(cursorDirection)

          var directionalKeypad2 = KeypadRobot.directionalKeypad
          let cursorDirections2 = directionalKeypad2.move(sequence: cursorDirection)

          print(cursorDirections2.map({ ($0.count, $0) }), cursorDirections2.count, line)
          print("-----")


          let testRobot = KeypadRobot.directionalKeypad
          if let cursor2Direction = cursorDirections2.min(by: { $0.count < $1.count }) {

            print(line)
            print(numpadSolution)
            print(cursorDirection)
            print(cursor2Direction)
            var pointer = testRobot.pointer
            for char in cursor2Direction {
              if char == "<" {
                pointer = Position(row: pointer.row, column: pointer.column - 1)
              } else if char == ">" {
                pointer = Position(row: pointer.row, column: pointer.column + 1)
              } else if char == "^" {
                pointer = Position(row: pointer.row - 1, column: pointer.column)
              } else if char == "v" {
                pointer = Position(row: pointer.row + 1, column: pointer.column)
              }
              assert(pointer.row >= 0 && pointer.row < testRobot.layout.count && pointer.column >= 0 && pointer.column < testRobot.layout[pointer.row].count)
              assert(pointer != testRobot.dangerPosition)
              assert(testRobot.character(for: pointer) != " ")
            }

            if shortestPathLength > cursor2Direction.count {
              shortestPathLength = cursor2Direction.count
              complexity = cursor2Direction.count * number
              print(line, "directions: \(cursor2Direction) length \(cursor2Direction.count) number \(number) complexity \(complexity)")
            }
          }
        }
      }
      result += complexity
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0


    var keypadRobot = KeypadRobot.numericKeypad

    func numberToDirections(_ char: Character) -> Set<String> {
      keypadRobot.move(to: char)
    }

    for line in data.split(separator: "\n") {
      print("Line \(line)")
      for char in line {
        print("Character \(char)")
        print(numberToDirections(char))
      }
      break
    }

    return result
  }
}
