//
//  EventCell.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/27.
//

import Foundation
import UIKit

class EventCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "EventCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label // 系統顏色
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let postedDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tintColor.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(postedDateLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        postedDateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            postedDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            postedDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with event: EventData) {
        titleLabel.text = "\(event.title)"
        postedDateLabel.text = "\(event.posted)"
    }
}
