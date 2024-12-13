import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day12Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    AAAA
    BBCD
    BBCC
    EEEC
    """

  let testData2 = """
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """

  let testData3 = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

  @Test func testPart1() async throws {
    let challenge = Day12(data: testData)
    #expect(String(describing: challenge.part1()) == "140")
  }

  @Test func test2Part1() async throws {
    let challenge = Day12(data: testData2)
    #expect(String(describing: challenge.part1()) == "772")
  }

  @Test func test3Part1() async throws {
    let challenge = Day12(data: testData3)
    #expect(String(describing: challenge.part1()) == "1930")
  }

  @Test func testRealPart1() async throws {
    let challenge = Day12()
    #expect(String(describing: challenge.part1()) == "1533024")
  }

  @Test func testPart2() async throws {
    let challenge = Day12(data: testData)
    #expect(String(describing: challenge.part2()) == "80")
  }

  @Test func test2Part2() async throws {
    let challenge = Day12(data: testData2)
    #expect(String(describing: challenge.part2()) == "436")
  }

  @Test func test3Part2() async throws {
    let testData = """
      EEEEE
      EXXXX
      EEEEE
      EXXXX
      EEEEE
      """
    let challenge = Day12(data: testData)
    #expect(String(describing: challenge.part2()) == "236")
  }

  @Test func test4Part2() async throws {
    let testData = """
      AAAAAA
      AAABBA
      AAABBA
      ABBAAA
      ABBAAA
      AAAAAA
      """
    let challenge = Day12(data: testData)
    #expect(String(describing: challenge.part2()) == "368")
  }

  @Test func test5Part2() async throws {
    let challenge = Day12(data: testData3)
    #expect(String(describing: challenge.part2()) == "1206")
  }

  @Test func testRealPart2() async throws {
    let challenge = Day12()
    #expect(String(describing: challenge.part2()) == "910066")
  }
}
