//
//  algorithms.swift
//  EditDistanceAlgorithms
//
//  Created by Danil Otmakhov on 27.04.2025.
//

import Foundation
    
enum EditOperation: String {
    case match = "M"
    case replace = "R"
    case insert = "I"
    case delete = "D"
}


struct Costs {
    let replace: Int
    let insert: Int
    let delete: Int
    
    init(replace: Int, insert: Int, delete: Int) {
        guard replace >= 0, insert >= 0, delete >= 0 else {
            fatalError("The cost of operations should be non-negative.")
        }
        self.replace = replace
        self.insert = insert
        self.delete = delete
    }
}


func buildEditDistanceMatrix(costs: Costs, source: String, target: String) -> [[Int]] {
    let a = Array(source)
    let b = Array(target)
    let n = a.count
    let m = b.count
    
    var dp = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)
    
    for i in 0...n {
        dp[i][0] = i * costs.delete
    }
    
    for j in 0...m {
        dp[0][j] = j * costs.insert
    }
    
    print("Initial Matrix:")
    printMatrix(dp, source: source, target: target)
    
    for i in 1...n {
        for j in 1...m {
            print("Processing dp[\(i)][\(j)] for characters '\(a[i - 1])' (source[\(i - 1)]) and '\(b[j - 1])' (target[\(j - 1)])")
            
            if a[i - 1] == b[j - 1] {
                dp[i][j] = dp[i - 1][j - 1]
                print("  Characters match, copying value from dp[\(i - 1)][\(j - 1)] = \(dp[i][j])")
            } else {
                let costReplace = dp[i - 1][j - 1] + costs.replace
                let costInsert = dp[i][j - 1] + costs.insert
                let costDelete = dp[i - 1][j] + costs.delete
                
                print("""
                    Characters differ:
                     - Replace: dp[\(i - 1)][\(j - 1)] + replace(\(costs.replace)) = \(costReplace)
                     - Insert:  dp[\(i)][\(j - 1)] + insert(\(costs.insert)) = \(costInsert)
                     - Delete:  dp[\(i - 1)][\(j)] + delete(\(costs.delete)) = \(costDelete)
                    """)
                
                dp[i][j] = min(costReplace, costInsert, costDelete)
                let operation: String
                if dp[i][j] == costReplace {
                    operation = "replace"
                } else if dp[i][j] == costInsert {
                    operation = "insert"
                } else {
                    operation = "delete"
                }
                print("  Selected operation: \(operation), dp[\(i)][\(j)] = \(dp[i][j])")
            }
            print()
        }
        
        print("Matrix after processing row \(i) ('\(a[i - 1])'):")
        printMatrix(dp, source: source, target: target)
    }
    
    return dp
}


func editDistanceWithTrace(costs: Costs, source: String, target: String) -> (operations: String, source: String, target: String) {
    let a = Array(source)
    let b = Array(target)
    let n = a.count
    let m = b.count
    
    let dp = buildEditDistanceMatrix(costs: costs, source: source, target: target)
    
    var operations: [EditOperation] = []
    var i = n
    var j = m
    
    print("Tracing back operations:")
    
    while i > 0 || j > 0 {
        if i > 0 && j > 0 && a[i - 1] == b[j - 1] {
            operations.append(.match)
            print("M(\(i), \(j)) — Match '\(a[i - 1])'")
            i -= 1
            j -= 1
        } else {
            if i > 0 && j > 0 && dp[i][j] == dp[i - 1][j - 1] + costs.replace {
                operations.append(.replace)
                print("R(\(i), \(j)) — Replace '\(a[i - 1])' with '\(b[j - 1])'")
                i -= 1
                j -= 1
            } else if j > 0 && dp[i][j] == dp[i][j - 1] + costs.insert {
                operations.append(.insert)
                print("I(\(i), \(j)) — Insert '\(b[j - 1])'")
                j -= 1
            } else if i > 0 && dp[i][j] == dp[i - 1][j] + costs.delete {
                operations.append(.delete)
                print("D(\(i), \(j)) — Delete '\(a[i - 1])'")
                i -= 1
            }
        }
    }
    
    let operationsString = operations.reversed().map { $0.rawValue }.joined()
    
    return (operationsString, source, target)
}


func levenshteinDistance(costs: Costs, source: String, target: String) -> Int {
    let dp = buildEditDistanceMatrix(costs: costs, source: source, target: target)
    return dp[source.count][target.count]
}


func longestCommonSubstring(_ source: String, _ target: String) -> (length: Int, substring: String) {
    if source.isEmpty || target.isEmpty {
        return (0, "")
    }
    
    let a = Array(source)
    let b = Array(target)
    let n = a.count
    let m = b.count
    
    var dp = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)
    var maxLength = 0
    var endIndex = 0
    
    for i in 1...n {
        for j in 1...m {
            if a[i - 1] == b[j - 1] {
                dp[i][j] = dp[i - 1][j - 1] + 1
                if dp[i][j] > maxLength {
                    maxLength = dp[i][j]
                    endIndex = i
                }
            }
        }
    }
    
    let startIndex = endIndex - maxLength
    let substring = String(a[startIndex..<endIndex])
    
    return (maxLength, substring)
}


func printMatrix(_ matrix: [[Int]], source: String, target: String) {
    let a = Array(source)
    let b = Array(target)
    
    let header = "\t\t" + b.map { String($0) }.joined(separator: "\t")
    print(header)
    
    for (i, row) in matrix.enumerated() {
        let prefix = i == 0 ? "-" : String(a[i - 1])
        let line = row.map { String($0) }.joined(separator: "\t")
        print("\(prefix)\t\(line)")
    }
    print()
}
