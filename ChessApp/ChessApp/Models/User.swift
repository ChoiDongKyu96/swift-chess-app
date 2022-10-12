//
//  User.swift
//  ChessApp
//
//  Created by 최동규 on 2022/10/01.
//

import Foundation

protocol User: AnyObject {

    var score: Int { get set }
    var pawnPolicy: PawnPolicy { get }
    var bishopPolicy: PiecePolicy { get }
    var rookPolicy: PiecePolicy { get }
    var queenPolicy: PiecePolicy { get }
    var knightPolicy: PiecePolicy { get }

    func resetPiece(in matrix: [[Board.BlockState]]) -> [[Board.BlockState]]?
}

extension User {
    func resetPiece(in matrix: [[Board.BlockState]]) -> [[Board.BlockState]]? {
        guard let matrixHasPawn = pawnPolicy.resetPiece(in: matrix, by: self),
              let matrixHasBishop = bishopPolicy.resetPiece(in: matrixHasPawn, by: self),
              let matrixHasRook = rookPolicy.resetPiece(in: matrixHasBishop, by: self),
              let matrixHasQueen = queenPolicy.resetPiece(in: matrixHasRook, by: self),
              let matrixHasKngiht = knightPolicy.resetPiece(in: matrixHasQueen, by: self) else { return nil }

        return matrixHasKngiht
    }
}

final class BlackUser: User {

    var score: Int = 0
    let pawnPolicy: PawnPolicy = BlackPawnPolicy()
    let bishopPolicy: PiecePolicy = BlackBishopPolicy()
    let rookPolicy: PiecePolicy = BlackRookPolicy()
    let queenPolicy: PiecePolicy = BlackQueenPolicy()
    let knightPolicy: PiecePolicy = BlackKnightPolicy()

    struct BlackPawnPolicy: PawnPolicy {

        let iconString: String = "♟"

        func possiblePositions(from position: Position) -> [Position] {
            return [Position(rank: Rank(position.rank.value + 1), file: position.file)]
            .compactMap { $0 }
        }

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let rankForPawn = Rank(1) else { return nil }
            var matrix = matrix
            matrix[rankForPawn.value] = (0..<File.Config.size).map { fileValue -> Board.BlockState in
                guard let position = Position(rank: rankForPawn, file: File(fileValue)) else { return .empty }
                let pawn = Pawn(position: position, user: user)
                return .exist(pawn)
            }

            return matrix
        }
    }

    struct BlackBishopPolicy: PiecePolicy {

        let iconString: String = "♝"

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let position1 = Position(rank: Rank(0), file: File(2)),
                  let position2 = Position(rank: Rank(0), file: File(5)) else { return nil }
            var matrix = matrix
            matrix[position1.rank.value][position1.file.value] = .exist(Bishop(position: position1, user: user))
            matrix[position2.rank.value][position2.file.value] = .exist(Bishop(position: position2, user: user))
            return matrix
        }
    }

    struct BlackRookPolicy: PiecePolicy {

        let iconString: String = "♜"

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let position1 = Position(rank: Rank(0), file: File(0)),
                  let position2 = Position(rank: Rank(0), file: File(7)) else { return nil }
            var matrix = matrix
            matrix[position1.rank.value][position1.file.value] = .exist(Rook(position: position1, user: user))
            matrix[position2.rank.value][position2.file.value] = .exist(Rook(position: position2, user: user))
            return matrix
        }
    }

    struct BlackQueenPolicy: PiecePolicy {

        let iconString: String = "♛"

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let position1 = Position(rank: Rank(0), file: File(4)) else { return nil }
            var matrix = matrix
            matrix[position1.rank.value][position1.file.value] = .exist(Queen(position: position1, user: user))
            return matrix
        }
    }

    struct BlackKnightPolicy: PiecePolicy {

        let iconString: String = "♞"

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let position1 = Position(rank: Rank(0), file: File(1)),
                  let position2 = Position(rank: Rank(0), file: File(6)) else { return nil }
            var matrix = matrix
            matrix[position1.rank.value][position1.file.value] = .exist(Knight(position: position1, user: user))
            matrix[position2.rank.value][position2.file.value] = .exist(Knight(position: position2, user: user))
            return matrix
        }
    }
    
    init() { }
}

final class WhiteUser: User {

    var score: Int = 0
    let pawnPolicy: PawnPolicy = WhitePawnPolicy()
    let bishopPolicy: PiecePolicy = WhiteBishopPolicy()
    let rookPolicy: PiecePolicy = WhiteRookPolicy()
    let queenPolicy: PiecePolicy = WhiteQueenPolicy()
    let knightPolicy: PiecePolicy = WhiteKnightPolicy()

    struct WhitePawnPolicy: PawnPolicy {

        let iconString: String = "♙"

        func possiblePositions(from position: Position) -> [Position] {
           return [Position(rank: position.rank - 1, file: position.file)]
            .compactMap { $0 }
        }

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let rankForPawn = Rank(6) else { return nil }
            var matrix = matrix

            matrix[rankForPawn.value] = (0..<File.Config.size).map { fileValue -> Board.BlockState in
                guard let position = Position(rank: rankForPawn, file: File(fileValue)) else { return .empty }
                let pawn = Pawn(position: position, user: user)
                return .exist(pawn)
            }
            return matrix
        }
    }

    struct WhiteBishopPolicy: PiecePolicy {

        let iconString: String = "♗"

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let position1 = Position(rank: Rank(7), file: File(2)),
                  let position2 = Position(rank: Rank(7), file: File(5)) else { return nil }
            var matrix = matrix
            matrix[position1.rank.value][position1.file.value] = .exist(Bishop(position: position1, user: user))
            matrix[position2.rank.value][position2.file.value] = .exist(Bishop(position: position2, user: user))
            return matrix
        }
    }

    struct WhiteRookPolicy: PiecePolicy {

        let iconString: String = "♖"

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let position1 = Position(rank: Rank(7), file: File(0)),
                  let position2 = Position(rank: Rank(7), file: File(7)) else { return nil }
            var matrix = matrix
            matrix[position1.rank.value][position1.file.value] = .exist(Rook(position: position1, user: user))
            matrix[position2.rank.value][position2.file.value] = .exist(Rook(position: position2, user: user))
            return matrix
        }
    }

    struct WhiteQueenPolicy: PiecePolicy {

        let iconString: String = "♕"

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let position1 = Position(rank: Rank(7), file: File(4)) else { return nil }
            var matrix = matrix
            matrix[position1.rank.value][position1.file.value] = .exist(Queen(position: position1, user: user))
            return matrix
        }
    }

    struct WhiteKnightPolicy: PiecePolicy {

        let iconString: String = "♘"

        func resetPiece(in matrix: [[Board.BlockState]], by user: User) -> [[Board.BlockState]]? {
            guard let position1 = Position(rank: Rank(7), file: File(1)),
                  let position2 = Position(rank: Rank(7), file: File(6)) else { return nil }
            var matrix = matrix
            matrix[position1.rank.value][position1.file.value] = .exist(Knight(position: position1, user: user))
            matrix[position2.rank.value][position2.file.value] = .exist(Knight(position: position2, user: user))
            return matrix
        }
    }

    init() {

    }
}
