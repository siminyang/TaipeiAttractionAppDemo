//
//  SectionTabView.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/28.
//

import Foundation
import UIKit

class SectionTabView: UIView {
    private var sections: [Section] = Section.allCases
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        return stack
    }()

    private let sliderView: UIView = {
        let view = UIView()
        view.backgroundColor = .tintColor
        return view
    }()

    private let newsButton: UIButton = {
        let button = UIButton()
        button.setTitle("最新消息", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = Section.events.rawValue
        return button
    }()

    private let attractionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("旅遊景點", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = Section.attractions.rawValue
        return button
    }()

    var didSelectTab: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stackView)
        addSubview(sliderView)

        stackView.addArrangedSubview(newsButton)
        stackView.addArrangedSubview(attractionsButton)

        newsButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        attractionsButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44),

            sliderView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            sliderView.heightAnchor.constraint(equalToConstant: 2),
            sliderView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        ])
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        guard let section = Section(rawValue: sender.tag) else { return }
        updateSlider(toIndex: section.rawValue)
        didSelectTab?(section.rawValue)
    }

    func updateSlider(toIndex index: Int) {
        guard let section = Section(rawValue: index) else { return }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.sliderView.transform = CGAffineTransform(translationX: CGFloat(section.rawValue) *  self.bounds.width / CGFloat(Section.allCases.count), y: 0)
        }
    }
}
