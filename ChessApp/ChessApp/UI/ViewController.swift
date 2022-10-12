//
//  ViewController.swift
//  ChessApp
//
//  Created by 최동규 on 2022/09/26.
//

import UIKit

final class ViewController: UIViewController {

    private var stackView: UIStackView?
    private var focusedPiece: Piece?
    private let chessGame: ChessGame = {
        let users: [User] = [BlackUser(), WhiteUser()]
        let game = ChessGame(users: users)
        return game
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        chessGame.board.delegate = self
        configureView()
    }
}

extension ViewController: BoardDelegate {

    func didChangeBoardMatrix(_ board: Board, matrix: [[Board.BlockState]]) {
        configureView()
    }
}

extension ViewController: BoardViewDelegate {

    func didTapBoardView(_ boardView: BoardView) {

        switch boardView.state {
        case .focused:
            focusedPiece = nil
            boardView.state = .normal
            break
        case .normal:
            configureView()
            if let position = boardView.position {
                switch chessGame.matrix[position] {
                case .empty:
                    break
                case .exist(let piece):
                    piece.nextPossiblePositions.forEach { position in
                        let nextPossibleBoardView = self.boardView(from: position)
                        nextPossibleBoardView?.state = .movingSpace
                    }
                    focusedPiece = nil
                    if !piece.nextPossiblePositions.isEmpty {
                        boardView.state = .focused
                        focusedPiece = piece
                    }
                }
            }
        case .movingSpace:
            if let position = boardView.position, let currentPosition = focusedPiece?.position {
                switch chessGame.board.move(currentPosition: currentPosition, to: position) {
                case .failure(let error):
                    print(error)
                case .success:
                    break
                }
                focusedPiece = nil
                configureView()
            }
        }


    }
}

private extension ViewController {

    func boardView(from position: Position) -> BoardView? {
        guard let stackView = stackView else { return nil }

        for view in stackView.arrangedSubviews {
            let hstackView = view as? UIStackView
            if let hstackView = hstackView {
                for view in hstackView.arrangedSubviews {
                    if let boardView = view as? BoardView {
                        if boardView.position == position {
                            return boardView
                        }
                    }
                }
            }
        }

        return nil
    }

    func configureView() {
        let vStackView = UIStackView()
        stackView?.removeFromSuperview()
        stackView = vStackView
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.alignment = .fill
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStackView)
        NSLayoutConstraint.activate([vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                                     vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     vStackView.heightAnchor.constraint(equalTo: vStackView.widthAnchor)])

        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.alignment = .fill

        hStackView.addArrangedSubview(BoardView())

        (0..<(chessGame.matrix.first?.count ?? 0))
            .compactMap { column in
                File(column)
            }.forEach { file in
                let boardView = BoardView()
                boardView.bind(to: file.valueName )
                hStackView.addArrangedSubview(boardView)
            }


        vStackView.addArrangedSubview(hStackView)


        chessGame.matrix.enumerated().forEach { (rankValue, row)  in
            let hStackView = UIStackView()
            hStackView.axis = .horizontal
            hStackView.distribution = .fillEqually
            hStackView.alignment = .fill

            let boardView = BoardView()
            boardView.bind(to: Rank(rankValue)?.valueName ?? "?" )
            hStackView.addArrangedSubview(boardView)
            row.enumerated().forEach { (fileValue, state) in
                let boardView = BoardView()
                boardView.delegate = self
                switch state {
                case .exist(let piece):
                    boardView.bind(to: piece)
                    boardView.bind(to: piece.position)
                case .empty:
                    boardView.bind(to: Position(rank: Rank(rankValue), file: File(fileValue)))
                    break
                }
                hStackView.addArrangedSubview(boardView)
            }
            vStackView.addArrangedSubview(hStackView)
        }
    }
}

