import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day17Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    """

  @Test func testPart1() async throws {
    let challenge = Day17(data: testData)
    #expect(String(describing: challenge.part1()) == "4,6,3,5,6,3,5,2,1,0")
  }

//  @Test func testPart1Instruction1() async throws {
//    let challenge = Day17(data: """
//    Register A: 0
//    Register B: 2024
//    Register C: 43690
//
//    Program: 4,0
//    """)
//    #expect(String(describing: challenge.part1()) == "4,6,3,5,6,3,5,2,1,0")
//  }

  @Test func testRealPart1() async throws {
    let challenge = Day17()
    #expect(String(describing: challenge.part1()) == "4,6,1,4,2,1,3,1,6")
  }

  @Test func testPart2() async throws {
    let testData2 = """
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,3,5,4,3,0
  """
    let challenge = Day17(data: testData2)
    #expect(String(describing: challenge.part2()) == "117440")
  }

//  @Test func testRealPart2() async throws {
//    let challenge = Day17()
//    #expect(String(describing: challenge.part2()) == "0")
//  }
}
