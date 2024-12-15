import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day15Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ########
    #..O.O.#
    ##@.O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    <^^>>>vv<v>>v<<
    """
  let testData2 = """
    ##########
    #..O..O.O#
    #......O.#
    #.OO..O.O#
    #..O@..O.#
    #O#..O...#
    #O..O..O.#
    #.OO.O.OO#
    #....O...#
    ##########

    <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    """
  let testData3 = """
    #######
    #...#.#
    #.....#
    #..OO@#
    #..O..#
    #.....#
    #######

    <vv<<^^<<^^
    """

  @Test func testPart1() async throws {
    let challenge = Day15(data: testData)
    #expect(String(describing: challenge.part1()) == "2028")
  }

  @Test func test2Part1() async throws {
    let challenge = Day15(data: testData2)
    #expect(String(describing: challenge.part1()) == "10092")
  }

  @Test func testRealPart1() async throws {
    let challenge = Day15()
    #expect(String(describing: challenge.part1()) == "1568399")
  }

  @Test func test3Part2() async throws {
    let challenge = Day15(data: testData3)
    #expect(String(describing: challenge.part2()) == "618")
  }

  @Test func testPart2() async throws {
    let challenge = Day15(data: testData)
    #expect(String(describing: challenge.part2()) == "1751")
  }

  @Test func test2Part2() async throws {
    let challenge = Day15(data: testData2)
    #expect(String(describing: challenge.part2()) == "9021")
  }

  @Test func testRealPart2() async throws {
    let challenge = Day15()
    #expect(String(describing: challenge.part2()) == "1575877")
  }
}
