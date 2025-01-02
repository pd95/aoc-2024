import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day21Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    029A
    980A
    179A
    456A
    379A
    """

  /*
   Numeric keypad
    +---+---+---+
    | 7 | 8 | 9 |
    +---+---+---+
    | 4 | 5 | 6 |
    +---+---+---+
    | 1 | 2 | 3 |
    +---+---+---+
        | 0 | A |
        +---+---+

   Directional keypad
        +---+---+
        | ^ | A |
    +---+---+---+
    | < | v | > |
    +---+---+---+

   */

  @Test func testDynamicProgrammingShortestPath() async throws {
    let challenge = Day21(data: testData)

    let keyPad = Day21.Graph.numericKeypad
    #expect(await keyPad.shortestPaths(from: "A", to: "0").cost == 2)
    #expect(await keyPad.shortestPaths(from: "A", to: "0").paths == ["<A"])
    #expect(await keyPad.shortestPaths(from: "0", to: "2").paths == ["^A"])
    #expect(await keyPad.shortestPaths(from: "2", to: "9").paths == ["^^>A", ">^^A"])
    #expect(await keyPad.shortestPaths(from: "9", to: "A").paths == ["vvvA"])

    #expect(await keyPad.transform("029A").cost == 12)
    //#expect(keyPad.transform("029A").paths == ["<A^A>^^AvvvA", "<A^A^^>AvvvA"])


    #expect(await challenge.findMinimumCostPath(code: "029A", using: [.numericKeypad]).cost == 12)
    #expect(await challenge.findMinimumCostPath(code: "029A", using: [.numericKeypad]).paths == [])
    #expect(await challenge.findMinimumCostPath(code: "029A", using: [.numericKeypad]).paths == [])

    #expect(await challenge.findMinimumCostPath(code: "029A", using: [.numericKeypad, .directionalKeypad]).cost == 28)
    #expect(await challenge.findMinimumCostPath(code: "0", using: [.numericKeypad, .directionalKeypad, .directionalKeypad]).cost == 18)
    #expect(await challenge.findMinimumCostPath(code: "029A", using: [.numericKeypad, .directionalKeypad, .directionalKeypad]).cost == 68)
    #expect(await challenge.findMinimumCostPath(code: "980A", using: [.numericKeypad, .directionalKeypad, .directionalKeypad]).cost == 60)
    #expect(await challenge.findMinimumCostPath(code: "179A", using: [.numericKeypad, .directionalKeypad, .directionalKeypad]).cost == 68)
    #expect(await challenge.findMinimumCostPath(code: "456A", using: [.numericKeypad, .directionalKeypad, .directionalKeypad]).cost == 64)
    #expect(await  challenge.findMinimumCostPath(code: "379A", using: [.numericKeypad, .directionalKeypad, .directionalKeypad]).cost == 64)

    //    #expect(challenge.transformSequenceOptimized("A029A", using: .numericKeypad).cost == 12)
    //    #expect(challenge.transformSequenceOptimized("A029A", using: .numericKeypad).minSequence == "<A^A>^^AvvvA")
    //
    //    #expect(challenge.transformSequenceOptimized("A<A^A>^^AvvvA", using: .directionalKeypad).cost == 28)
    //    #expect(challenge.transformSequenceOptimized("A<A^A>^^AvvvA", using: .directionalKeypad).minSequence == "<v<A>>^A<A>AvA<^AA>A<vAAA>^A")
    //
    //    #expect(challenge.transformSequenceOptimized("A<v<A>>^A<A>AvA<^AA>A<vAAA>^A", using: .directionalKeypad).cost == 70)
    //    #expect(challenge.transformSequenceOptimized("A<v<A>>^A<A>AvA<^AA>A<vAAA>^A", using: .directionalKeypad).minSequence == "<v<A>A<A>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A")
    //    #expect(challenge.transformSequenceOptimized("A<A^A>^^AvvvA", using: .directionalKeypad)
    //      .contains("v<<A>>^A<A>AvA<^AA>A<vAAA>^A"))
    //    #expect(challenge.transformSequenceOptimized("Av<<A>>^A<A>AvA<^AA>A<vAAA>^A", using: .directionalKeypad).cost == 68)
    //#expect(challenge.dynamicProgrammingOptimizedPath(for: "029A", using: [.numericKeypad]) == "<A^A^^>AvvvA")

    //#expect(challenge.dynamicProgrammingOptimizedPath(for: "029A", using: [.directionalKeypad, .numericKeypad]) == "<A^A^^>AvvvA")
  }


  @Test func testPart1() async throws {
    let challenge = Day21(data: testData)
    #expect(String(describing: await challenge.part1()) == "126384")
  }

  @Test func testRealPart1() async throws {
    let challenge = Day21()
    #expect(String(describing: await challenge.part1()) == "242484")
  }

  @Test func testPart2() async throws {
    let challenge = Day21(data: testData)
    #expect(String(describing: await challenge.part2()) == "126384")
  }

  @Test func testRealPart2() async throws {
    let challenge = Day21()
    #expect(String(describing: await challenge.part2()) == "242484")
  }
}
