//
//  ChessGame.swift
//  ChessApp
//
//  Created by 최동규 on 2022/09/27.
//

import Foundation

final class ChessGame {

    var matrix: [[Board.BlockState]] { board.matrix }
    let board = Board()
    private let users: [User]

    init(users: [User]) {
        self.users = users
        reset()
    }
    
    func reset() {
        board.clearAll()
        users.forEach { user in
            board.resetPiece(user: user)
            user.score = 0
        }
    }
}
