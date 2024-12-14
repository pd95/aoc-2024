import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day14Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """

  @Test func testPart1() async throws {
    let challenge = Day14(data: testData, gridWidth: 11, gridHeight: 7)
    #expect(String(describing: challenge.part1()) == "12")
  }

  @Test func testRealPart1() async throws {
    let challenge = Day14()
    #expect(String(describing: challenge.part1()) == "229839456")
  }

  //  @Test func testPart2() async throws {
  //    let challenge = Day14(data: testData, gridWidth: 11, gridHeight: 7)
  //    #expect(String(describing: challenge.part2()) == "7138")
  //  }

  @Test func testRealPart2() async throws {
    let challenge = Day14()
    #expect(String(describing: challenge.part2()) == "7138")
  }
}
