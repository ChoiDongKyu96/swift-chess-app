//
//  Board.swift
//  ChessApp
//
//  Created by 최동규 on 2022/09/26.
//

import Foundation

enum BoardMoveError: LocalizedError {
    case emptyBlock(postion: Position)
    case myPieceExist(piece: Piece)
    case undefinedMove

    var errorDescription: String {
        switch self {
        case .emptyBlock(let postion):
            return "There is no piece where to start position: \(postion)"
        case .myPieceExist(let piece):
            return "There is my piece where to end position: \(piece.iconString) \(piece.position)"
        case .undefinedMove:
            return ""
        }
    }
}


final class Board {

    private(set) var matrix: [[BlockState]] = [[.empty]]
    
    enum BlockState {
        case exist(_ value: Piece)
        case empty
    }

    init() {
        clearAll()
    }


    func clearAll() {
        matrix = [[BlockState]](repeating: [BlockState](repeating: .empty, count: File.Config.size), count: Rank.Config.size)
    }

    func resetPiece(user: User) {
        guard let newMatrix = user.resetPiece(in: matrix) else { return }
        matrix = newMatrix
    }

    func move(currentPosition: Position, to position :Position) -> Result<Piece, BoardMoveError> {
        let fromBlockState = matrix[currentPosition]
        switch fromBlockState {
        case .empty:
                return .failure(.emptyBlock(postion: currentPosition))
        case .exist(let fromPiece):
            guard fromPiece.move(to: position) else {
                return .failure(.undefinedMove)
            }
            let toBlockState = matrix[position]
            switch toBlockState {
            case .empty:
                return .success(fromPiece)
            case .exist(let toPiece):
                guard type(of: fromPiece.user) != type(of: toPiece.user) else { return .failure(.myPieceExist(piece: toPiece)) }
                fromPiece.user.score += toPiece.score
                return .success(fromPiece)
            }

        }
    }

    func description() -> String {
        var columnDescription = (0..<(matrix.first?.count ?? 0))
            .compactMap { column in
                File(column)
            }
            .reduce(" ", { partialResult, file in
            return partialResult.appending(file.valueName)
        })

        columnDescription.append(contentsOf: "\n")
        var totalString = columnDescription
        matrix.enumerated().forEach { (index, row)  in
            var rowString = Rank(index)?.valueName ?? "?"
            row.forEach { state in
                switch state {
                case .exist(let piece):
                    rowString.append(contentsOf: piece.iconString)
                case .empty:
                    rowString.append(contentsOf: ".")
                }
            }
            totalString.append(contentsOf: rowString)
            totalString.append(contentsOf: "\n")
        }
        totalString.append(columnDescription)
        return totalString
    }
}

extension Array where Element == Array<Board.BlockState> {

    subscript(position: Position) -> Board.BlockState {
        get {
            self[position.rank.value][position.file.value]
        }
        set {
            self[position.rank.value][position.file.value] = newValue
        }
    }
}
