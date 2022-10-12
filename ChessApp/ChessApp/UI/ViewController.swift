//
//  ViewController.swift
//  ChessApp
//
//  Created by 최동규 on 2022/09/26.
//

import UIKit

final class ViewController: UIViewController {

    let chessGame: ChessGame = {
        let users: [User] = [BlackUser(), WhiteUser()]
        return ChessGame(users: users)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()



    }
}

