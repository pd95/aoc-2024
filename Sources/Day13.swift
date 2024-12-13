import Algorithms

struct Day13: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    let regex = /Button A: X\+(?<buttonAX>\d+), Y\+(?<buttonAY>\d+)\nButton B: X\+(?<buttonBX>\d+), Y\+(?<buttonBY>\d+)\nPrize: X=(?<prizeX>\d+), Y=(?<prizeY>\d+)/

    var startRange = data.startIndex
    while let match = try? regex.firstMatch(in: data[startRange...]) {
      //print("\n\n\(match.output.0)\n")
      startRange = match.range.upperBound

      let priceX = Int(match.output.prizeX)!
      let priceY = Int(match.output.prizeY)!
      let buttonAX = Int(match.output.buttonAX)!
      let buttonAY = Int(match.output.buttonAY)!
      let buttonBX = Int(match.output.buttonBX)!
      let buttonBY = Int(match.output.buttonBY)!

      var bestMatch: (a: Int, b: Int, cost: Int)?
      for aTapCount in 0...100 {
        var foundMatch: (a: Int, b: Int, cost: Int)?
        for bTapCount in 0...100 {
          let positionX = aTapCount * buttonAX + bTapCount * buttonBX
          let positionY = aTapCount * buttonAY + bTapCount * buttonBY
          if positionX == priceX && positionY == priceY {
            foundMatch = (aTapCount, bTapCount, aTapCount*3 + bTapCount*1)
            break
          }
        }
        if let foundMatch {
          //print("found \(foundMatch)")
          if let currentBestMatch = bestMatch {
            if foundMatch.cost < currentBestMatch.cost {
              //print("  => is better!")
              bestMatch = foundMatch
            }
          } else {
            bestMatch = foundMatch
          }
        }
      }
      if let bestMatch {
        //print(bestMatch)
        result += bestMatch.cost
      //} else {
      //  print("No solution found")
      }
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    let regex = /Button A: X\+(?<buttonAX>\d+), Y\+(?<buttonAY>\d+)\nButton B: X\+(?<buttonBX>\d+), Y\+(?<buttonBY>\d+)\nPrize: X=(?<prizeX>\d+), Y=(?<prizeY>\d+)/

    var startRange = data.startIndex
    while let match = try? regex.firstMatch(in: data[startRange...]) {
      //print("\n\n\(match.output.0)\n")
      startRange = match.range.upperBound

      let priceX = Int(match.output.prizeX)!+10000000000000
      let priceY = Int(match.output.prizeY)!+10000000000000
      let buttonAX = Int(match.output.buttonAX)!
      let buttonAY = Int(match.output.buttonAY)!
      let buttonBX = Int(match.output.buttonBX)!
      let buttonBY = Int(match.output.buttonBY)!


      /*
       We have to solve the following equations to determine the aTapCount and bTapCount
          priceX = aTapCount * buttonAX + bTapCount * buttonBX
          priceY = aTapCount * buttonAY + bTapCount * buttonBY
       */
      let determinant = Double(buttonAX * buttonBY - buttonBX * buttonAY)

      if determinant == 0 {
        print("The system of equations does not have a unique solution.")
      } else {
        // Solve for aTapCount and bTapCount using Cramer's Rule
        let aTapCount = Double(priceX * buttonBY - priceY * buttonBX) / determinant
        let bTapCount = Double(buttonAX * priceY - buttonAY * priceX) / determinant

        // Output the result
        if aTapCount == Double(Int(aTapCount)) && bTapCount == Double(Int(bTapCount)) {
          //print("aTapCount: \(aTapCount), bTapCount: \(bTapCount)")
          result += Int(aTapCount) * 3 + Int(bTapCount)
        //} else {
        //  print("no solution")
        }
      }
    }

    return result
  }
}
