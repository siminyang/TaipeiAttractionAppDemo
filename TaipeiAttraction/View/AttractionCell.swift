//
//  AttractionCell.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/27.
//

import Foundation
import UIKit
import Kingfisher

class AttractionCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "AttractionCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let attractionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let districtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tintColor
        label.font = .systemFont(ofSize: 12)
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
        contentView.addSubview(imageView)
        contentView.addSubview(attractionNameLabel)
        contentView.addSubview(districtLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        attractionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        districtLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),

            attractionNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            attractionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            attractionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            districtLabel.topAnchor.constraint(equalTo: attractionNameLabel.bottomAnchor, constant: 8),
            districtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            districtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(with attraction: AttractionData) {
        imageView.tintColor = .tintColor
        imageView.kf.setImage(
            with: URL(string: attraction.images.first?.src ?? ""),
            placeholder: UIImage(systemName: "photo")
        )
        attractionNameLabel.text = "\(attraction.name)"
        districtLabel.text = "\(attraction.distric)"
    }
}
