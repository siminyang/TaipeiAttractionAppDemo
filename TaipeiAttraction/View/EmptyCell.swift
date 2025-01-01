//
//  EmptyCell.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/30.
//

import Foundation
import UIKit

class EmptyCell: UICollectionViewCell {
    static let identifier = "EmptyCell"

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No data"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
