import Algorithms

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Position: Hashable {
    let row: Int
    let col: Int
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    let grid: [[Character]] = data.split(separator: "\n").map({ Array(String($0)) })
    let gridSize = (height: grid.count, width: grid[0].count)
    let antennas = Set(data.filter({ $0.isNumber || $0.isLetter }))

    func isInGrid(_ position: Position) -> Bool {
      position.row >= 0 && position.row < gridSize.height && position.col >= 0
        && position.col < gridSize.width
    }

    var antennaPositions: [Character: [Position]] = [:]
    for (h, row) in grid.enumerated() {
      for (w, antenna) in row.enumerated() {
        if antennas.contains(antenna) {
          antennaPositions[antenna, default: []].append(Position(row: h, col: w))
        }
      }
    }

    var antinodePositions = Set<Position>()
    for positions in antennaPositions.values {
      for positions in positions.combinations(ofCount: 2) {
        let first = positions[0]
        let second = positions[1]

        let deltaRow = second.row - first.row
        let deltaCol = second.col - first.col

        var antinodePos = Position(row: first.row - deltaRow, col: first.col - deltaCol)
        if isInGrid(antinodePos) {
          antinodePositions.insert(antinodePos)
        }

        antinodePos = Position(row: second.row + deltaRow, col: second.col + deltaCol)
        if isInGrid(antinodePos) {
          antinodePositions.insert(antinodePos)
        }
      }
    }

    return antinodePositions.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    let grid: [[Character]] = data.split(separator: "\n").map({ Array(String($0)) })
    let gridSize = (height: grid.count, width: grid[0].count)
    let antennas = Set(data.filter({ $0.isNumber || $0.isLetter }))

    func isInGrid(_ position: Position) -> Bool {
      position.row >= 0 && position.row < gridSize.height && position.col >= 0
        && position.col < gridSize.width
    }

    var antennaPositions: [Character: [Position]] = [:]
    for (h, row) in grid.enumerated() {
      for (w, antenna) in row.enumerated() {
        if antennas.contains(antenna) {
          antennaPositions[antenna, default: []].append(Position(row: h, col: w))
        }
      }
    }

    var antinodePositions = Set<Position>()
    for positions in antennaPositions.values {
      for positions in positions.combinations(ofCount: 2) {
        let first = positions[0]
        let second = positions[1]
        antinodePositions.insert(first)
        antinodePositions.insert(second)

        let deltaRow = second.row - first.row
        let deltaCol = second.col - first.col

        var antinodePos = Position(row: first.row - deltaRow, col: first.col - deltaCol)
        while isInGrid(antinodePos) {
          antinodePositions.insert(antinodePos)
          antinodePos = Position(row: antinodePos.row - deltaRow, col: antinodePos.col - deltaCol)
        }

        antinodePos = Position(row: second.row + deltaRow, col: second.col + deltaCol)
        while isInGrid(antinodePos) {
          antinodePositions.insert(antinodePos)
          antinodePos = Position(row: antinodePos.row + deltaRow, col: antinodePos.col + deltaCol)
        }
      }
    }

    return antinodePositions.count
  }
}
