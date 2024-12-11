import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    let diskMapCompact: [Character] = Array(data.trimmingCharacters(in: .whitespacesAndNewlines))
    var diskMap = [Int?]()

    // expand disk map
    for (index, sizeChar) in diskMapCompact.enumerated() {
      let size = Int(String(sizeChar))!
      if index % 2 == 0 {
        let fileID = index / 2
        diskMap.append(contentsOf: Array(repeating: fileID, count: size))
      } else {
        diskMap.append(contentsOf: Array(repeating: nil, count: size))
      }
    }

    // defragment disk
    var freeBlockPointer = diskMap.firstIndex(of: nil)!
    var lastUsedBlockPointer = diskMap.lastIndex(where: { $0 != nil })!
    while freeBlockPointer < lastUsedBlockPointer {

      diskMap[freeBlockPointer] = diskMap[lastUsedBlockPointer]
      diskMap[lastUsedBlockPointer] = nil

      repeat {
        freeBlockPointer = diskMap.index(after: freeBlockPointer)
      } while diskMap[freeBlockPointer] != nil
      repeat {
        lastUsedBlockPointer = diskMap.index(before: lastUsedBlockPointer)
      } while diskMap[lastUsedBlockPointer] == nil
    }

    // Calculate checksum
    let checksum = diskMap.enumerated().reduce(into: 0) {
      (checksum: inout Int, entry: (offset: Int, element: Int?)) in
      if let value = entry.element {
        checksum += value * entry.offset
      }
    }

    return checksum
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    let diskMapCompact: [Character] = Array(data.trimmingCharacters(in: .whitespacesAndNewlines))
    var diskMap = [Int?]()

    // expand disk map
    for (index, sizeChar) in diskMapCompact.enumerated() {
      let size = Int(String(sizeChar))!
      if index % 2 == 0 {
        let fileID = index / 2
        diskMap.append(contentsOf: Array(repeating: fileID, count: size))
      } else {
        diskMap.append(contentsOf: Array(repeating: nil, count: size))
      }
    }

    // defragment disk
    var lastUsedBlockPointer = diskMap.lastIndex(where: { $0 != nil })!
    while lastUsedBlockPointer > diskMap.startIndex {

      let fileID = diskMap[lastUsedBlockPointer]!
      let fileSize = Int(String(diskMapCompact[fileID * 2]))!
      lastUsedBlockPointer = diskMap.index(lastUsedBlockPointer, offsetBy: 1 - fileSize)

      // Find free space for this file
      var freeBlockPointer = diskMap.firstIndex(of: nil)!
      var freeSpace = 0
      repeat {
        freeSpace = 0
        while diskMap[freeBlockPointer] == nil && freeBlockPointer < lastUsedBlockPointer {
          freeSpace += 1
          freeBlockPointer += 1
        }
        if freeSpace >= fileSize {
          // enough space?
          break
        }
        while diskMap[freeBlockPointer] != nil && freeBlockPointer < lastUsedBlockPointer {
          freeBlockPointer += 1
        }
      } while freeSpace < fileSize && freeBlockPointer < lastUsedBlockPointer

      if freeSpace >= fileSize {
        freeBlockPointer = diskMap.index(freeBlockPointer, offsetBy: -freeSpace)
        for _ in 0..<fileSize {
          diskMap[freeBlockPointer] = diskMap[lastUsedBlockPointer]
          diskMap[lastUsedBlockPointer] = nil
          freeBlockPointer += 1
          lastUsedBlockPointer += 1
        }
        lastUsedBlockPointer = diskMap.index(lastUsedBlockPointer, offsetBy: -fileSize)
      }

      while lastUsedBlockPointer > diskMap.startIndex
        && (diskMap[lastUsedBlockPointer] == nil || diskMap[lastUsedBlockPointer]! >= fileID)
      {
        lastUsedBlockPointer -= 1
      }
    }

    // Calculate checksum
    let checksum = diskMap.enumerated().reduce(into: 0) {
      (checksum: inout Int, entry: (offset: Int, element: Int?)) in
      if let value = entry.element {
        checksum += value * entry.offset
      }
    }

    return checksum
  }
}
