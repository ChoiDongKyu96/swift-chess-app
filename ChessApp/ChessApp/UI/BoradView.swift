//
//  BoradView.swift
//  ChessApp
//
//  Created by 최동규 on 2022/10/09.
//

import UIKit

protocol BoardViewDelegate: AnyObject {
    func didTapBoardView(_ boardView: BoardView)
}

final class BoardView: UIView {

    weak var delegate: BoardViewDelegate?
    private(set) var position: Position?

    private let pieceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        addSubview(pieceLabel)
        NSLayoutConstraint.activate([pieceLabel.topAnchor.constraint(equalTo: topAnchor),
                                     pieceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     pieceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     pieceLabel.leadingAnchor.constraint(equalTo: leadingAnchor)])
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor

        let tapgGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(tapgGesture)
    }

    @objc private func handleTap(sender: UITapGestureRecognizer) {
        delegate?.didTapBoardView(self)
    }

    func bind(to piece: Piece) {
        self.pieceLabel.text = piece.iconString
        self.pieceLabel.sizeToFit()
    }

    func bind(to text: String) {
        self.pieceLabel.text = text
        self.pieceLabel.sizeToFit()
    }

    func bind(to position: Position?) {
        self.position = position
    }
}
