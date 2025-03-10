//
//  main.swift
//  Backtracking
//
//  Created by Danil Otmakhov on 16.02.2025.
//

import Foundation

enum InputError: Error {
    case outOfRange
}

struct Square {
    let size: Int
    let x: Int
    let y: Int
}

class Desk {
    
    let size: Int
    var map: [[Int]]
    var count: Int
    var squares: [Square]
    var emptyCell: (Int, Int)?
    
    init(_ size: Int) {
        self.size = size
        self.map = Array(repeating: Array(repeating: 0, count: size), count: size)
        self.squares = []
        self.count = 0
        self.emptyCell = (0, 0)
        
        if size % 2 == 0 {
            setOptimizedEven()
        } else if isPrime(size) {
            setOptimizedPrime()
        } else if size % 2 != 0 && size % 3 != 0 {
            self.setDefault()
        }
    }
    
    private func setDefault() {
        addSquare(size: (size + 1) / 2, x: 0, y: 0)
        addSquare(size: (size - 1) / 2, x: 0, y: (size + 1) / 2)
        addSquare(size: (size - 1) / 2, x: (size + 1) / 2, y: 0)
    }
    
    private func setOptimizedEven() {
        let half = size / 2
        for i in 0..<2 {
            for j in 0..<2 {
                addSquare(size: half, x: i * half, y: j * half)
            }
        }
    }
    
    private func setOptimizedPrime() {
        addSquare(size: (size + 1) / 2, x: 0, y: 0)
        addSquare(size: size / 2, x: 0, y: (size + 1) / 2)
        addSquare(size: size / 2, x: (size + 1) / 2, y: 0)
    }
    
    private func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        if n < 4 { return true }
        for i in 2...Int(sqrt(Double(n))) {
            if n % i == 0 {
                return false
            }
        }
        return true
    }
    
    private func updateEmptyCell() {
        for i in 0..<size {
            for j in 0..<size {
                if map[i][j] == 0 {
                    emptyCell = (i, j)
                    return
                }
            }
        }
        
        emptyCell = nil
    }
    
    func isFull() -> Bool {
        return emptyCell == nil
    }
    
    func addSquare(size: Int, x: Int, y: Int) {
        for i in x..<x + size {
            for j in y..<y + size {
                map[i][j] = count + 1
            }
        }
        
        let square = Square(size: size, x: x, y: y)
        squares.append(square)
        count += 1
        
        updateEmptyCell()
    }
    
    func canAdd(size: Int, x: Int, y: Int) -> Bool {
        if y + size > self.size || x + size > self.size {
            return false
        }
        
        for i in x..<x + size {
            for j in y..<y + size {
                if map[i][j] != 0 {
                    return false
                }
            }
        }
        
        return true
    }
    
    func printDesk() {
        var output = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        for square in squares {
            for i in square.x..<square.x + square.size {
                for j in square.y..<square.y + square.size {
                    output[i][j] = square.size
                }
            }
        }
        
        for row in output {
            print(row.map { String($0) }.joined(separator: " "))
        }
    }
}

func backtracking(desk: Desk) -> Desk {
    var queue: [Desk] = [desk]
    
    while let first = queue.first, let emptyCell = first.emptyCell {
        queue.removeFirst()
        
        for i in (1..<first.size).reversed() {
            if first.canAdd(size: i, x: emptyCell.0, y: emptyCell.1) {
                let current = Desk(first.size)
                current.map = first.map
                current.squares = first.squares
                current.count = first.count
                
                current.addSquare(size: i, x: emptyCell.0, y: emptyCell.1)
                
                print("\nStep: \(current.count). Added square at (\(emptyCell.0), \(emptyCell.1)) with size \(i)")
                current.printDesk()
                
                if current.isFull() {
                    return current
                }
                
                queue.append(current)
            }
        }
    }
    
    return queue.first ?? desk
}

do {
    print("Enter the size of the square:")
    let n = Int(readLine()!)!
    guard n >= 2, n <= 20 else {
        throw InputError.outOfRange
    }
    let start = CFAbsoluteTimeGetCurrent()

    let desk = Desk(n)
    let answer = backtracking(desk: desk)

    let end = CFAbsoluteTimeGetCurrent()
    print("\nTime to complete: \(end - start) seconds")
    print(answer.count)
    for square in answer.squares {
        print("\(square.x) \(square.y) \(square.size)")
    }
} catch InputError.outOfRange {
    print("Error: The size of the square should be in the range from 2 to 20.")
}
