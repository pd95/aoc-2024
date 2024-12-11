import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day08Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """

  @Test func testPart1() async throws {
    let challenge = Day08(data: testData)
    #expect(String(describing: challenge.part1()) == "14")
  }

  @Test func testPart2() async throws {
    let challenge = Day08(data: testData)
    #expect(String(describing: challenge.part2()) == "34")
  }

  @Test func testRealPart1() async throws {
    let challenge = Day08()
    #expect(String(describing: challenge.part1()) == "269")
  }

  @Test func testRealPart2() async throws {
    let challenge = Day08()
    #expect(String(describing: challenge.part2()) == "949")
  }
}
