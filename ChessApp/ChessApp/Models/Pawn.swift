//
//  Pawn.swift
//  ChessApp
//
//  Created by 최동규 on 2022/09/26.
//

import Foundation

protocol PawnPolicy: PiecePolicy {
    func possiblePositions(from position: Position) -> [Position]
}

final class Pawn: Piece {

    var position: Position
    var iconString: String {
        user.pawnPolicy.iconString
    }
    var nextPossiblePositions: [Position] {
        return user.pawnPolicy.possiblePositions(from: position)

    }
    let user: User
    let score: Int = 1

    init(position: Position, user: User) {
        self.position = position
        self.user = user
    }

    @discardableResult
    func move(to position: Position) -> Bool {
        guard nextPossiblePositions.contains(position) else { return false }

        self.position = position
        return true
    }
}
