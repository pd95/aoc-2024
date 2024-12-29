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


  @Test func testKeypadRobotMovePossibilities() async throws {
    var robot = Day21.KeypadRobot.numericKeypad
    #expect(robot.move(to: "7").count == 1)
    #expect(robot.move(to: "0").count == 1)
    #expect(robot.move(to: "6").count == 2)
    #expect(robot.move(to: "1").count == 2)
    #expect(robot.move(to: "9").count == 2)
    #expect(robot.move(to: "4").count == 2)
    #expect(robot.move(to: "A").count == 1)

    robot = Day21.KeypadRobot.directionalKeypad
    #expect(robot.move(to: "<").count == 1)
    #expect(robot.move(to: "A").count == 1)
    #expect(robot.move(to: "A").count == 1)
    #expect(robot.move(to: "v").count == 2)
    #expect(robot.move(to: ">").count == 1)
    #expect(robot.move(to: "^").count == 2)
    #expect(robot.move(to: "<").count == 1)
  }

  @Test func testPart1() async throws {
    let challenge = Day21(data: testData)
    #expect(String(describing: challenge.part1()) == "126384")
  }

  @Test func testRealPart1() async throws {
    let challenge = Day21()
    #expect(String(describing: challenge.part1()) == "242484")
  }

  @Test func testPart2() async throws {
    let challenge = Day21(data: testData)
    #expect(String(describing: challenge.part2()) == "126384")
  }

  @Test func testRealPart2() async throws {
    let challenge = Day21()
    #expect(String(describing: challenge.part2()) == "242484")
  }
}
