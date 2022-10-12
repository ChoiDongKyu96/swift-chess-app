//
//  Position.swift
//  ChessApp
//
//  Created by 최동규 on 2022/10/01.
//

import Foundation

//enum RankError: LocalizedError {
//    case outOfRange(value: Int)
//
//    var errorDescription: String {
//        switch self {
//        case .outOfRange(let value):
//            return "out of range \(value), minValue is \(Rank.Config.minValue) and maxValue is \(Rank.Config.maxValue)"
//        }
//    }
//}
//
//enum FileError: LocalizedError {
//    case outOfRange(value: Int)
//
//    var errorDescription: String {
//        switch self {
//        case .outOfRange(let file):
//            return "out of range \(value), minValue is \(File.Config.minValue) and maxValue is \(File.Config.maxValue)"
//        }
//    }
//}

struct Position: Equatable {

    let rank: Rank
    let file: File

    init? (rank: Rank?, file: File?) {
        guard let rank = rank,
              let file = file else {
            return nil
        }
        self.rank = rank
        self.file = file

    }

    static func + (left: Position, right: Position) -> Position? {
        return Position(rank: left.rank + right.rank, file: left.file + right.file)
    }

    static func - (left: Position, right: Position) -> Position? {
        return Position(rank: left.rank + right.rank, file: left.file + right.file)
    }

    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.file == rhs.file && lhs.rank == rhs.rank
    }
}

struct Rank: Equatable {

    enum Config {
        static var minValue: Int = 0
        static var maxValue: Int = 7
        static var size: Int {
            return maxValue - minValue + 1
        }
    }

    var valueName: String {
        return String(value + 1)
    }
    let value: Int

    init? (_ value : Int) {
        guard (Config.minValue...Config.maxValue).contains(value) else { return nil
        }
        self.value = value
    }

    static func + (left: Rank, right: Rank) -> Rank? {
        return Rank(left.value + right.value)
    }

    static func + (left: Rank, right: Int) -> Rank? {
        return Rank(left.value + right)
    }

    static func + (left: Int, right: Rank) -> Rank? {
        return Rank(left + right.value)
    }

    static func - (left: Rank, right: Rank) -> Rank? {
        return Rank(left.value - right.value)
    }

    static func - (left: Rank, right: Int) -> Rank? {
        return Rank(left.value - right)
    }

    static func - (left: Int, right: Rank) -> Rank? {
        return Rank(left - right.value)
    }

    static func == (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.value == rhs.value
    }
}

struct File: Equatable {

    enum Config {
        static var minValue: Int = 0
        static var maxValue: Int = 7
        static var size: Int {
            return maxValue - minValue + 1
        }
    }

    var valueName: String {
        guard let ascii =  UnicodeScalar(value + 65) else {
            return "?"
        }
        return String(ascii)
    }
    let value: Int

    init? (_ value : Int) {
        guard (Config.minValue...Config.maxValue).contains(value) else { return nil
        }
        self.value = value
    }

    static func + (left: File, right: File) -> File? {
        return File(left.value + right.value)
    }

    static func + (left: File, right: Int) -> File? {
        return File(left.value + right)
    }

    static func + (left: Int, right: File) -> File? {
        return File(left + right.value)
    }

    static func - (left: File, right: File) -> File? {
        return File(left.value - right.value)
    }

    static func - (left: File, right: Int) -> File? {
        return File(left.value - right)
    }

    static func - (left: Int, right: File) -> File? {
        return File(left - right.value)
    }

    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.value == rhs.value
    }
}
