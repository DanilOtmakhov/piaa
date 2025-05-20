//
//  main.swift
//  EditDistanceAlgorithms
//
//  Created by Danil Otmakhov on 27.04.2025.
//

import Foundation

print("Enter the first string:")
guard let source = readLine(), !source.isEmpty else {
    fatalError("First string is empty.")
}

print("Enter the second string:")
guard let target = readLine(), !target.isEmpty else {
    fatalError("Second string is empty.")
}

print("Enter the operation costs (replace insert delete) separated by spaces:")
guard let costsLine = readLine(),
      !costsLine.isEmpty else {
    fatalError("Operation costs input is empty.")
}

let costValues = costsLine.split(separator: " ").compactMap { Int($0) }
guard costValues.count == 3 else {
    fatalError("You must enter exactly three integer costs.")
}

let costs = Costs(
    replace: costValues[0],
    insert: costValues[1],
    delete: costValues[2]
)

let (operations, alignedSource, alignedTarget) = editDistanceWithTrace(costs: costs, source: source, target: target)
print("Edit operations sequence: \(operations)\n")

let distance = levenshteinDistance(costs: costs, source: source, target: target)
print("Levenshtein distance: \(distance)")

let (lcsLength, lcsSubstring) = longestCommonSubstring(source, target)
print("Longest common substring length: \(lcsLength)")
print("Longest common substring: \"\(lcsSubstring)\"")
