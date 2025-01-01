//
//  AttractionDetailContentView.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/29.
//

import Foundation
import UIKit

protocol URLTappedDelegate: AnyObject {
    func urlTapped()
}

class AttractionDetailContentView: UIView {
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        return stack
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private lazy var telLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private lazy var ticketLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private lazy var remindLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private lazy var urlButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "點擊查看更多資訊\nLearn more"
        configuration.baseBackgroundColor = .tintColor
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        configuration.titleAlignment = .center

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(urlTapped), for: .touchUpInside)
        return button
    }()

    weak var delegate: URLTappedDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        [addressLabel, telLabel, ticketLabel, remindLabel, categoryLabel, urlButton].forEach { label in
            stackView.addArrangedSubview(label)
        }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    private func createAttributedString(title: String, content: String, systemImage: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.paragraphSpacing = 4

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.tintColor,
            .paragraphStyle: paragraphStyle,
        ]

        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ]

        let imageIcon = NSTextAttachment()
        imageIcon.image = UIImage(systemName: systemImage)?.withTintColor(.tintColor)
        imageIcon.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
        let imageIconString = NSAttributedString(attachment: imageIcon)

        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: content, attributes: contentAttributes))
        attributedString.insert(imageIconString, at: 0)

        return attributedString
    }

    func configure(with attraction: AttractionData) {
        addressLabel.attributedText = createAttributedString(title: " 地址 address: ", content: attraction.address, systemImage: "location.fill")
        telLabel.attributedText = createAttributedString(title: " 電話 tel: ", content: attraction.tel, systemImage: "phone.fill")
        ticketLabel.attributedText = createAttributedString(title: " 票價 ticket: ", content: (attraction.ticket?.isEmpty == true ? "NA" : attraction.ticket) ?? "NA", systemImage: "ticket.fill")
        remindLabel.attributedText = createAttributedString(title: " 提醒 remind: ", content: (attraction.remind?.isEmpty == true ? "NA" : attraction.remind) ?? "NA", systemImage: "bell.fill")

        let categories = attraction.category.map { $0.name ?? "" }.joined(separator: "、")
        categoryLabel.attributedText = createAttributedString(title: " 分類 category: ", content: categories, systemImage: "tag.fill")
    }

    @objc private func urlTapped() {
        delegate?.urlTapped()
    }
}
