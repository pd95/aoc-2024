import Algorithms
import Foundation

struct Day24: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  init(data: String) {
    self.data = data
  }

  class LogicSimulator {
    let inputBitCount: Int
    let outputBitCount: Int
    var wireStates: [String: Int]
    var logicRules: [(operation: String, input1: String, input2: String, output: String)]

    init(data: String) {
      var wireStates: [String: Int] = [:]
      var logicRules: [(operation: String, input1: String, input2: String, output: String)] = []

      for line in data.components(separatedBy: .newlines) {
        let wireState = line.components(separatedBy: ": ")
        if wireState.count == 2 {
          wireStates[wireState[0]] = Int(wireState[1])
        }

        let logicRule = line.split(separator: " -> ")
        if logicRule.count == 2 {
          let gateRule = logicRule[0].split(separator: " ")
          if gateRule.count == 3 {
            let rule = (operation: String(gateRule[1]), input1: String(gateRule[0]), input2: String(gateRule[2]), output: String(logicRule[1]))
            logicRules.append(rule)
          }
        }
      }

      inputBitCount = wireStates.keys.filter({ $0.hasPrefix("x") }).count
      outputBitCount = logicRules.map(\.output).filter({ $0.hasPrefix("z") }).count
      self.wireStates = wireStates
      self.logicRules = logicRules
    }

    func wire(_ name: String, _ number: Int?) -> String {
      if let number {
        return String(format: "%@%02ld", name, number)
      } else {
        return name
      }
    }

    func resetState(x: Int, y: Int) {
      var wireStates: [String: Int] = [:]
      for i in 0..<inputBitCount {
        wireStates[wire("x", i)] = (x & (1 << i)) > 0 ? 1 : 0
        wireStates[wire("y", i)] = (y & (1 << i)) > 0 ? 1 : 0
      }
      self.wireStates = wireStates
    }

    func dumpState() {
      for wire in wireStates.keys.sorted() {
        print(wire, ": ", wireStates[wire, default: -1])
      }
    }

    func evaluateState(for wire: String) -> Int {
      if let existingState = wireStates[wire] {
        return existingState
      }

      guard let rule = logicRules.first(where: { $0.output == wire }) else {
        fatalError("No rule found for \(wire)")
      }

      let input1State = evaluateState(for: rule.input1)
      let input2State = evaluateState(for: rule.input2)

      let result: Int
      switch rule.operation {
      case "AND": result = input1State & input2State
      case "OR": result = input1State | input2State
      case "XOR": result = input1State ^ input2State
      default:
        fatalError("Unknown operation \(rule.operation)")
      }
      wireStates[wire] = result

      return result
    }

    func evaluateOutput() -> Int {
      var result = 0
      for i in (0..<outputBitCount).reversed() {
        let zWire = wire("z", i)
        let state = evaluateState(for: zWire)
        result <<= 1
        result += state
      }

      return result
    }

    func intValue(_ name: String) -> Int {
      var result = 0
      assert(name == "x" || name == "y" || name == "z")
      let upperBound = name == "z" ? outputBitCount : inputBitCount
      for i in (0..<upperBound).reversed() {
        let state = evaluateState(for: wire(name, i))
        result <<= 1
        result += state
      }
      return result
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    let simulator = LogicSimulator(data: data)
    //simulator.dumpState()
    result = simulator.intValue("z")

    return result
  }


  var part2Operation: @Sendable (Int, Int) -> Int = { $0 + $1 }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> String {
    var result = ""
    var swappedWires = Set<String>()

    let simulator = LogicSimulator(data: data)
    simulator.dumpState()


    for i in 0..<simulator.inputBitCount {
      var x = 1 << i
      simulator.resetState(x: x, y: 0)
      var z = simulator.evaluateOutput()
      var expectedZ = part2Operation(x, 0)
      print(i, expectedZ, z)
      if z != expectedZ {
        let wire1 = simulator.wire("z", i)
        let wire2 = simulator.wire("z", Int(log2(Double(z))))
        print("Warning: incorrect result \(String(z, radix: 2)) for \(String(x, radix: 2)). Expected \(String(expectedZ, radix: 2)) ==> \(wire1), \(wire2) swapped")
        swappedWires.insert(wire1)
        swappedWires.insert(wire2)
      }

      simulator.resetState(x: 0, y: x)
      z = simulator.evaluateOutput()
      expectedZ = part2Operation(0, x)
      print(i, expectedZ, z)
      if z != expectedZ {
        let wire1 = simulator.wire("z", i)
        let wire2 = simulator.wire("z", Int(log2(Double(z))))
        print("Warning: incorrect result \(String(z, radix: 2)) for \(String(x, radix: 2)). Expected \(String(expectedZ, radix: 2)) ==> \(wire1), \(wire2) swapped")
        swappedWires.insert(wire1)
        swappedWires.insert(wire2)
      }

      simulator.resetState(x: x, y: x)
      z = simulator.evaluateOutput()
      expectedZ = part2Operation(x, x)
      print(i, expectedZ, z)
      if z != expectedZ {
        let wire1 = simulator.wire("z", Int(log2(Double(expectedZ))))
        let wire2 = simulator.wire("z", Int(log2(Double(z))))
        print("Warning: incorrect result \(String(z, radix: 2)) for \(String(x, radix: 2)). Expected \(String(expectedZ, radix: 2)) ==> \(wire1), \(wire2) swapped")
        swappedWires.insert(wire1)
        swappedWires.insert(wire2)
      }

      x = (1 << (i+1)) - 1
      simulator.resetState(x: x, y: x)
      z = simulator.evaluateOutput()
      expectedZ = part2Operation(x, x)
      print(i, expectedZ, z)
      if z != expectedZ {
        print("Warning: incorrect result \(String(z, radix: 2)) for \(String(x, radix: 2)). Expected \(String(expectedZ, radix: 2))")
//        let wire1 = simulator.wire("z", Int(log2(Double(expectedZ))))
//        let wire2 = simulator.wire("z", Int(log2(Double(z))))
//        print(" ==> \(wire1), \(wire2) swapped")
//        swappedWires.insert(wire1)
//        swappedWires.insert(wire2)
      }
    }
    /*

     15 32768 32768
     15 32768 32768
     15 65536 131072
     Warning: incorrect result 100000000000000000 for 1000000000000000. Expected 10000000000000000 ==> z16, z17 swapped
     16 65536 131072
     Warning: incorrect result 100000000000000000 for 10000000000000000. Expected 10000000000000000 ==> z16, z17 swapped
     16 65536 131072
     Warning: incorrect result 100000000000000000 for 10000000000000000. Expected 10000000000000000 ==> z16, z17 swapped
     16 131072 65536
     Warning: incorrect result 10000000000000000 for 10000000000000000. Expected 100000000000000000 ==> z17, z16 swapped

     */

    result = swappedWires.sorted().joined(separator: ",")

    return result
  }
}
