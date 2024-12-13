import Algorithms

struct Day12: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Point: Hashable, CustomStringConvertible, Comparable {
    var x: Int
    var y: Int

    var description: String {
      "(\(x),\(y))"
    }

    static func < (lhs: Point, rhs: Point) -> Bool {
      if lhs.y == rhs.y {
        if lhs.x < rhs.x {
          return true
        } else {
          return false
        }
      } else {
        if lhs.y < rhs.y {
          return true
        } else {
          return false
        }
      }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var result = 0

    var grid: [[Character]] = data.split(separator: "\n").map({ Array($0) })
    for y in grid.indices {
      for x in grid[y].indices {
        let currentAreaType = grid[y][x]
        if currentAreaType.isUppercase {
          let visitedAreaType = Character(grid[y][x].lowercased())
          //print("Visiting area type", currentAreaType, "at", y, x)

          // not yet processed area
          var area = 0
          var perimeter = 0
          var queue: Set<Point> = Set([Point(x: x, y: y)])
          while !queue.isEmpty {
            let point = queue.removeFirst()
            let (y, x) = (point.y, point.x)
            area += 1
            grid[y][x] = visitedAreaType
            if y > 0 {
              if grid[y - 1][x] != currentAreaType && grid[y - 1][x] != visitedAreaType {
                perimeter += 1
              } else {
                if grid[y - 1][x] != visitedAreaType {
                  queue.insert(Point(x: x, y: y - 1))
                }
              }
            } else {
              perimeter += 1
            }
            if y < grid.count - 1 {
              if grid[y + 1][x] != currentAreaType && grid[y + 1][x] != visitedAreaType {
                perimeter += 1
              } else {
                if grid[y + 1][x] != visitedAreaType {
                  queue.insert(Point(x: x, y: y + 1))
                }
              }
            } else {
              perimeter += 1
            }
            if x > 0 {
              if grid[y][x - 1] != currentAreaType && grid[y][x - 1] != visitedAreaType {
                perimeter += 1
              } else {
                if grid[y][x - 1] != visitedAreaType {
                  queue.insert(Point(x: x - 1, y: y))
                }
              }
            } else {
              perimeter += 1
            }
            if x < grid[y].count - 1 {
              if grid[y][x + 1] != currentAreaType && grid[y][x + 1] != visitedAreaType {
                perimeter += 1
              } else {
                if grid[y][x + 1] != visitedAreaType {
                  queue.insert(Point(x: x + 1, y: y))
                }
              }
            } else {
              perimeter += 1
            }
            //print("checked area at", y, x, "(area: \(area), perimeter: \(perimeter))")
          }

          let price = area * perimeter
          //print("Area type \(currentAreaType) has area \(area) and perimeter \(perimeter). Price \(price).")

          result += price
        }
      }
    }

    return result
  }

  struct EdgeLocation: OptionSet, Hashable, CustomStringConvertible {
    let rawValue: Int

    static let top = EdgeLocation(rawValue: 1 << 0)
    static let bottom = EdgeLocation(rawValue: 1 << 1)
    static let left = EdgeLocation(rawValue: 1 << 2)
    static let right = EdgeLocation(rawValue: 1 << 3)

    var description: String {
      var text: String = ""
      if rawValue & Self.top.rawValue != 0 {
        text += "top,"
      }
      if rawValue & Self.bottom.rawValue != 0 {
        text += "bottom,"
      }
      if rawValue & Self.left.rawValue != 0 {
        text += "left,"
      }
      if rawValue & Self.right.rawValue != 0 {
        text += "right,"
      }
      text = text.trimmingCharacters(in: .punctuationCharacters)
      text = "[\(text)]"
      return text
    }

    var isCorner: Bool {
      self.isSuperset(of: [.top, .left]) || self.isSuperset(of: [.bottom, .left])
        || self.isSuperset(of: [.top, .right]) || self.isSuperset(of: [.bottom, .right])
    }

    var count: Int {
      var count = 0
      if rawValue & Self.top.rawValue != 0 {
        count += 1
      }
      if rawValue & Self.bottom.rawValue != 0 {
        count += 1
      }
      if rawValue & Self.left.rawValue != 0 {
        count += 1
      }
      if rawValue & Self.right.rawValue != 0 {
        count += 1
      }

      return count
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var result = 0

    var grid: [[Character]] = data.split(separator: "\n").map({ Array($0) })
    for y in grid.indices {
      for x in grid[y].indices {
        let currentAreaType = grid[y][x]
        if currentAreaType.isUppercase {
          let visitedAreaType = Character(grid[y][x].lowercased())
          //print("Visiting area type", currentAreaType, "at", y, x)

          // not yet processed area
          var area = 0
          var queue: Set<Point> = Set([Point(x: x, y: y)])
          var perimeterParts = [Point: EdgeLocation]()
          while !queue.isEmpty {
            let point = queue.removeFirst()
            let (y, x) = (point.y, point.x)
            area += 1
            grid[y][x] = visitedAreaType
            if y > 0 {
              if grid[y - 1][x] != currentAreaType && grid[y - 1][x] != visitedAreaType {
                perimeterParts[point, default: EdgeLocation()].insert(.top)
              } else {
                if grid[y - 1][x] != visitedAreaType {
                  queue.insert(Point(x: x, y: y - 1))
                }
              }
            } else {
              perimeterParts[point, default: EdgeLocation()].insert(.top)
            }
            if y < grid.count - 1 {
              if grid[y + 1][x] != currentAreaType && grid[y + 1][x] != visitedAreaType {
                perimeterParts[point, default: EdgeLocation()].insert(.bottom)
              } else {
                if grid[y + 1][x] != visitedAreaType {
                  queue.insert(Point(x: x, y: y + 1))
                }
              }
            } else {
              perimeterParts[point, default: EdgeLocation()].insert(.bottom)
            }
            if x > 0 {
              if grid[y][x - 1] != currentAreaType && grid[y][x - 1] != visitedAreaType {
                perimeterParts[point, default: EdgeLocation()].insert(.left)
              } else {
                if grid[y][x - 1] != visitedAreaType {
                  queue.insert(Point(x: x - 1, y: y))
                }
              }
            } else {
              perimeterParts[point, default: EdgeLocation()].insert(.left)
            }
            if x < grid[y].count - 1 {
              if grid[y][x + 1] != currentAreaType && grid[y][x + 1] != visitedAreaType {
                perimeterParts[point, default: EdgeLocation()].insert(.right)
              } else {
                if grid[y][x + 1] != visitedAreaType {
                  queue.insert(Point(x: x + 1, y: y))
                }
              }
            } else {
              perimeterParts[point, default: EdgeLocation()].insert(.right)
            }
            //print("checked area at", y, x, "(area: \(area), perimeter: \(perimeter))")
          }

          let sortedPerimeterKeys = Array(perimeterParts.keys).sorted()
          //print("Perimeter: \(perimeterParts.count)\n")
          //sortedPerimeterKeys.forEach {
          //  print("\($0) \(perimeterParts[$0]!.description)")
          //}

          var sides = 0

          // MARK: - Find horizontal lines
          var tempPerimeter = perimeterParts
          for point in sortedPerimeterKeys {
            let location = tempPerimeter[point]!
            //print("point", point, location, location.isCorner)
            if location.isCorner == false { continue }

            if location.contains(.top) && location.contains(.left) {
              sides += 1
              //print("  \(sides) \(point) follow top -> right")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.top) {
                tempPerimeter[point]!.remove(.top)
                if newPart.contains(.right) {
                  break
                }
                point.x += 1
              }
            } else if location.contains(.top) && location.contains(.right) {
              sides += 1
              //print("  \(sides) \(point) follow top -> left")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.top) {
                tempPerimeter[point]!.remove(.top)
                if newPart.contains(.left) {
                  break
                }
                point.x -= 1
              }
            }
            if location.contains(.bottom) && location.contains(.left) {
              sides += 1
              //print("  \(sides) \(point) follow bottom -> right")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.bottom) {
                tempPerimeter[point]!.remove(.bottom)
                if newPart.contains(.right) {
                  break
                }
                point.x += 1
              }
            } else if location.contains(.bottom) && location.contains(.right) {
              sides += 1
              //print("  \(sides) \(point) follow bottom -> left")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.bottom) {
                tempPerimeter[point]!.remove(.bottom)
                if newPart.contains(.left) {
                  break
                }
                point.x -= 1
              }
            }
          }

          // Find all remaining edges (which are not corners)
          var remainingSides = tempPerimeter.filter({ $0.value.isSubset(of: [.top, .bottom]) }).keys
            .sorted()
          for point in remainingSides {
            let location = tempPerimeter[point]!
            if location.contains(.top) {
              sides += 1
              //print("  \(sides) \(point) follow top -> right")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.top) {
                tempPerimeter[point]!.remove(.top)
                point.x += 1
              }
            }
            if location.contains(.bottom) {
              sides += 1
              //print("  \(sides) \(point) follow bottom -> right")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.bottom) {
                tempPerimeter[point]!.remove(.bottom)
                point.x += 1
              }
            }
          }

          // MARK: - Find vertical lines
          tempPerimeter = perimeterParts
          for point in sortedPerimeterKeys {
            let location = tempPerimeter[point]!
            //print("point", point, location, location.isCorner)
            if location.isCorner == false { continue }

            if location.contains(.top) && location.contains(.left) {
              sides += 1
              //print("  \(sides) \(point) follow left -> down")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.left) {
                tempPerimeter[point]!.remove(.left)
                if newPart.contains(.bottom) {
                  break
                }
                point.y += 1
              }
            } else if location.contains(.bottom) && location.contains(.left) {
              sides += 1
              //print("  \(sides) \(point) follow left -> up")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.left) {
                tempPerimeter[point]!.remove(.left)
                if newPart.contains(.top) {
                  break
                }
                point.y -= 1
              }
            }
            if location.contains(.top) && location.contains(.right) {
              sides += 1
              //print("  \(sides) \(point) follow right -> down")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.right) {
                tempPerimeter[point]!.remove(.right)
                if newPart.contains(.bottom) {
                  break
                }
                point.y += 1
              }
            } else if location.contains(.bottom) && location.contains(.right) {
              sides += 1
              //print("  \(sides) \(point) follow right -> up")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.right) {
                tempPerimeter[point]!.remove(.right)
                if newPart.contains(.top) {
                  break
                }
                point.y -= 1
              }
            }
          }

          // Find all remaining edges (which are not corners)
          remainingSides = tempPerimeter.filter({ $0.value.isSubset(of: [.left, .right]) }).keys
            .sorted()
          for point in remainingSides {
            let location = tempPerimeter[point]!
            if location.contains(.left) {
              sides += 1
              //print("  \(sides) \(point) follow left -> bottom")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.left) {
                tempPerimeter[point]!.remove(.left)
                point.y += 1
              }
            }
            if location.contains(.right) {
              sides += 1
              //print("  \(sides) \(point) follow bottom -> right")
              var point = point
              while let newPart = tempPerimeter[point], newPart.contains(.right) {
                tempPerimeter[point]!.remove(.right)
                point.y += 1
              }
            }
          }

          let price = area * sides
          //print(currentAreaType, ":", area, sides, price)
          result += price
        }
      }
    }
    //print(currentAreaType, ":", area, sides, price)

    return result
  }
}
