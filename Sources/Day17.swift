import Algorithms
import Foundation

struct Day17: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  enum Register: CustomStringConvertible {
    case a
    case b
    case c

    init?<T: StringProtocol>(rawValue: T) {
      switch rawValue {
      case "A": self = .a
      case "B": self = .b
      case "C": self = .c
      default: return nil
      }
    }

    var description: String {
      switch self {
      case .a: return "A"
      case .b: return "B"
      case .c: return "C"
      }
    }
  }

  struct MachineState: Hashable, Equatable {
    var program = [Int]()
    var registers = [Register: Int]()
    var instructionPointer: Int = 0
    var output: String = ""

    var isValidPointer: Bool {
      0..<program.count ~= instructionPointer
    }

    mutating func execute() {
      let opcode = program[instructionPointer]
      let operand = program[instructionPointer + 1]

      let comboOperand: Int?
      switch operand {
      case 0...3: comboOperand = program[instructionPointer + 1]
      case 4: comboOperand = registers[.a, default: 0]
      case 5: comboOperand = registers[.b, default: 0]
      case 6: comboOperand = registers[.c, default: 0]
      default: comboOperand = nil
      }

      instructionPointer += 2

      switch opcode {
      case 0: // adv
        registers[.a] = registers[.a, default: 0] / (1<<comboOperand!)
      case 1: // bxl
        registers[.b, default: 0] ^= operand
      case 2: // bst
        registers[.b, default: 0] = comboOperand! & 0x7
      case 3: // jnz
        if registers[.a, default: 0] != 0 {
          instructionPointer = operand
        }
      case 4: // bxc
        registers[.b, default: 0] ^= registers[.c, default: 0]
      case 5: // out
        output += "\(output.isEmpty ? "" : ",")\(comboOperand! & 0x7)"
      case 6: // bdv
        registers[.b] = registers[.a, default: 0] / (1<<comboOperand!)
      case 7: // cdv
        registers[.c] = registers[.a, default: 0] / (1<<comboOperand!)

      default:
        fatalError("Invalid opcode!")
      }
    }
  }


  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> String {
    var state = MachineState()

    // Read configuration from data
    let regex = /Register (?<register>[A-C]): (?<value>\d+)|Program: (?<program>[0-9,]+)/
    var startRange = data.startIndex
    while let match = try? regex.firstMatch(in: data[startRange...]) {
      startRange = match.range.upperBound

      if let registerMatch = match.output.register, let register = Register(rawValue: registerMatch),
          let valueMatch = match.output.value, let value = Int(valueMatch)
      {
        state.registers[register, default: 0] = value
      }
      if let programMatch = match.output.program {
        state.program = programMatch.split(separator: ",").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).compactMap(Int.init)
      }
    }

    // Execute program
    while state.isValidPointer {
      state.execute()
    }

    // return output
    return state.output
  }

  enum Part2State: Equatable {
    case identifyProgramLength
    case findingA(base: Int, bitmask: Int, matchingParts: Int)
    case foundBestSolution(Int)

    var foundBestSolution: Bool {
      switch self {
      case .foundBestSolution: return true
      default: return false
      }
    }
  }


  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> String {
    var result = ""
    var state = MachineState()

    let regex = /Register (?<register>[A-C]): (?<value>\d+)|Program: (?<program>[0-9,]+)/

    var startRange = data.startIndex
    var programCode = ""
    while let match = try? regex.firstMatch(in: data[startRange...]) {
      startRange = match.range.upperBound

      if let registerMatch = match.output.register, let register = Register(rawValue: registerMatch),
          let valueMatch = match.output.value, let value = Int(valueMatch)
      {
        state.registers[register, default: 0] = value
      }
      if let programMatch = match.output.program {
        programCode = String(programMatch)
        state.program = programMatch.split(separator: ",").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).compactMap(Int.init)
      }
    }

    let initialState = state

    @discardableResult
    func execute(_ a: Int) -> Bool {
      state = initialState
      state.registers[.a] = Int(a)
      
      while state.isValidPointer {
        state.execute()
      }
      //print("-", String(a, radix: 8), state.output, state.output.count == programCodeLength)
      //print("+", String(a, radix: 8), programCode)
      if state.output == programCode {
        print("🟢 found solution for part 2: \(a)")
        return true
      }
      return false
    }

    // optimize to find lower bound where program code matches
    let programCodeLength = programCode.count

    var processState = Part2State.identifyProgramLength
    var a = 1  // state.registers[.a]!
    while result.isEmpty {
      switch processState {
      case.identifyProgramLength:
        execute(a)
        if state.output.count < programCodeLength {
          //print("output too short")
          a = a << 1
        } else if state.output.count > programCodeLength {
          //print("output too long")
          a = a >> 1
        } else {

          var lowerBound = a >> 1
          var upperBound = a
          while (upperBound - lowerBound) > 1 {
            a = (lowerBound + upperBound + 1) / 2
            //print("Checking \(String(a, radix: 8))")
            if execute(a) {
              break
            }
            if state.output.count < programCodeLength {
              lowerBound = a
            } else {
              upperBound = a
            }
          }
          processState = .findingA(base: 0, bitmask: upperBound<<3, matchingParts: 0)
        }

      case .findingA(var base, var bitmask, var matchingParts):
        //print("finding A")
        let upperBound = bitmask << 4

        while matchingParts < programCodeLength && !processState.foundBestSolution {
          for b in 0...7 {
            a = upperBound + base + b*bitmask
            //print("base: \(String(base, radix: 8)), bitmask: \(String(bitmask, radix: 8)) a: \(String(a, radix: 8))")
            execute(a)

            let outputIndex: String.Index = state.output.index(state.output.startIndex, offsetBy: max(0, programCodeLength - matchingParts - 1 - 1))
            let outputEndIndex: String.Index = state.output.index(state.output.startIndex, offsetBy: max(0, programCodeLength - 1))
            let outputPart = state.output[outputIndex...outputEndIndex]
            let programIndex: String.Index = programCode.index(programCode.startIndex, offsetBy: max(0, programCodeLength - matchingParts - 1 - 1))
            let programPart = programCode[programIndex...]
            //print(outputPart, programPart, programPart == outputPart, programPart == outputPart ? "🟢" : "")

            if outputPart == programPart {
              base += b*bitmask
              matchingParts += 2
              //print("found valid part! new base \(String(base, radix: 8))")
              break
            }
          }

          bitmask >>= 3
          //print("new bitmask \(String(bitmask, radix: 8))")

          if bitmask <= 1 {
            //print("Finished bitshifting... start iterating as of \(String(base, radix: 8))")
            for i in 0..<upperBound {
              a = base + i
              //print("a = \(String(a, radix: 8))", a)
              if execute(a) {
                //print("Found solution using \(base+i)")
                processState = .foundBestSolution(base+i)
                break
              }
            }

            //fatalError("Unexpected 0 bitmask")
          }
        }

      case .foundBestSolution(let a):
        print("🟢 returning solution \(a)")
        result = String(a)
      }
    }

    return result
  }
}
