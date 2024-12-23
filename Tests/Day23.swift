import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day23Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    kh-tc
    qp-kh
    de-cg
    ka-co
    yn-aq
    qp-ub
    cg-tb
    vc-aq
    tb-ka
    wh-tc
    yn-cg
    kh-ub
    ta-co
    de-co
    tc-td
    tb-wq
    wh-td
    ta-ka
    td-qp
    aq-cg
    wq-ub
    ub-vc
    de-ta
    wq-aq
    wq-vc
    wh-yn
    ka-de
    kh-ta
    co-tc
    wh-qp
    tb-vc
    td-yn
    """

  @Test func testPart1() async throws {
    let challenge = Day23(data: testData)
    #expect(String(describing: challenge.part1()) == "7")
  }

  @Test func testRealPart1() async throws {
    let challenge = Day23()
    #expect(String(describing: challenge.part1()) == "1358")
  }

  @Test func testPart2() async throws {
    let challenge = Day23(data: testData)
    #expect(String(describing: challenge.part2()) == "co,de,ka,ta")
  }

  @Test func testRealPart2() async throws {
    let challenge = Day23()
    #expect(String(describing: challenge.part2()) == "cl,ei,fd,hc,ib,kq,kv,ky,rv,vf,wk,yx,zf")
  }
}
