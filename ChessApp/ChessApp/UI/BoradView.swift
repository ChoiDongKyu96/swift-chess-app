//
//  BoradView.swift
//  ChessApp
//
//  Created by 최동규 on 2022/10/09.
//

import UIKit

final class BoardView: UIView {

    private let pieceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
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

    func configure() {
        addSubview(pieceLabel)
        NSLayoutConstraint.activate([pieceLabel.topAnchor.constraint(equalTo: topAnchor),
                                     pieceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     pieceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     pieceLabel.leadingAnchor.constraint(equalTo: leadingAnchor)])
    }

    func bind(to piece: Piece) {
        self.pieceLabel.text = piece.iconString
    }
}
