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


  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> String {

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
    var lowerBound = 0.0
    var upperBound = Double(Int.max)
    var a = lowerBound
    if state.registers[.a] == 59397658 {
      //                      2,4,1,1,7,5,4,6,1,4,0,3,5,5,3,0
      a = 203687564539236  // 2,4,5,0,1,0,0,4,4,3,7,5,5,1,3,0
      a = 207687564539236  // 2,4,5,4,6,1,5,0,2,5,5,1,4,5,2,0
      a = 200000000000000  // 5,5,5,5,1,5,3,6,5,7,1,2,5,4,2,0
      a = 205049100000000  // 5,5,5,5,1,5,3,6,5,7,1,2,5,4,2,0
      lowerBound = a
    }

    func testOutputLength(_ a: Double) -> Int {
      state = initialState
      state.registers[.a] = Int(a)
      
      while state.isValidPointer {
        state.execute()
      }
      
      return state.output.count
    }

    // optimize to find lower bound where program code matches
    var programCodeLength = programCode.count
    var outputLengthMatches = false
    while true {
      state = initialState
      print(a)
      state.registers[.a] = Int(a)

      while state.isValidPointer {
        state.execute()
      }

      print(state.output)
      print(programCode)
      //return "done"
      if state.output.count > programCodeLength {
        print("output too long")
        upperBound = a
        a = (upperBound-lowerBound) / 2
        outputLengthMatches = false
      }
      else if state.output.count < programCodeLength {
        print("output too short")
        lowerBound = a
        a = (upperBound-lowerBound) / 2
        outputLengthMatches = false
      } else {
        print(programCode)

        if state.output == programCode {
          print("matches program")
          return String(Int(a))
        }

        if outputLengthMatches == false {
          outputLengthMatches = true
          //print(lowerBound, upperBound)
          while true {
            let lowerBoundLength = testOutputLength(lowerBound)
            if lowerBoundLength == programCodeLength {
              break
            } else if lowerBoundLength < programCodeLength {
              lowerBound = (a - lowerBound) / 2
            }
          }
          a = lowerBound
        } else {
          a += 1
        }

//        let outputReversed = state.output.split(separator: ",").reversed().joined()
//        let programReversed = programCode.split(separator: ",").reversed().joined()
//        if outputReversed < programReversed {
//          print("output value too low")
//          lowerBound = a + 1
//        } else if outputReversed > programReversed {
//          print("output value too big")
//          upperBound = a - 1
//        } else {
//          a += 10
//        }
//        print(outputReversed, programReversed)

      }

    }

    return ""
  }
}
