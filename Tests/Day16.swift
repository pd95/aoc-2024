import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day16Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    """
  let testData2 = """
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################
    """
  @Test func testPart1() async throws {
    let challenge = Day16(data: testData)
    #expect(String(describing: challenge.part1()) == "7036")
  }

  @Test func test2Part1() async throws {
    let challenge = Day16(data: testData2)
    #expect(String(describing: challenge.part1()) == "11048")
  }

  @Test func testRealPart1() async throws {
    let challenge = Day16()
    #expect(String(describing: challenge.part1()) == "73432")
  }

  @Test func testPart2() async throws {
    let challenge = Day16(data: testData)
    #expect(String(describing: challenge.part2()) == "45")
  }

  @Test func test2Part2() async throws {
    let challenge = Day16(data: testData2)
    #expect(String(describing: challenge.part2()) == "64")
  }

//  @Test func testRealPart2() async throws {
//    let challenge = Day16()
//    #expect(String(describing: challenge.part2()) == "496")
//  }
}
