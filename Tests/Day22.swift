import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day22Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    1
    10
    100
    2024
    """

  let testData2 = """
    1
    2
    3
    2024
    """

  @Test func testPseudoRandomNumberGenerator() async throws {
    var generator = Day22.PseudoRandomNumberGenerator(initialSecret: 123)

    // Check basic utility operations
    #expect(generator.mix(secret: 42, with: 15) == 37)
    #expect(generator.prune(100000000) == 16113920)

    #expect(generator.price == 3)  // Initial price

    #expect(generator.next() == 15887950)
    #expect(generator.price == 0)
    #expect(generator.priceChange == -3)

    #expect(generator.next() == 16495136)
    #expect(generator.price == 6)
    #expect(generator.priceChange == 6)

    #expect(generator.next() == 527345)
    #expect(generator.price == 5)
    #expect(generator.priceChange == -1)

    #expect(generator.next() == 704524)
    #expect(generator.price == 4)
    #expect(generator.priceChange == -1)

    #expect(generator.next() == 1553684)
    #expect(generator.price == 4)
    #expect(generator.priceChange == 0)

    #expect(generator.next() == 12683156)
    #expect(generator.price == 6)
    #expect(generator.priceChange == 2)

    #expect(generator.next() == 11100544)
    #expect(generator.price == 4)
    #expect(generator.priceChange == -2)

    #expect(generator.next() == 12249484)
    #expect(generator.price == 4)
    #expect(generator.priceChange == 0)

    #expect(generator.next() == 7753432)
    #expect(generator.price == 2)
    #expect(generator.priceChange == -2)

    #expect(generator.next() == 5908254)
    #expect(generator.price == 4)
    #expect(generator.priceChange == 2)
  }

  @Test func testPart1() async throws {
    let challenge = Day22(data: testData)
    #expect(String(describing: challenge.part1()) == "37327623")
  }

  @Test func testRealPart1() async throws {
    let challenge = Day22()
    #expect(String(describing: challenge.part1()) == "14691757043")
  }

  @Test func testPart2() async throws {
    let challenge = Day22(data: testData2)
    #expect(String(describing: challenge.part2()) == "23")
  }

  @Test func testRealPart2() async throws {
    let challenge = Day22()
    #expect(String(describing: challenge.part2()) == "1831")
  }
}
