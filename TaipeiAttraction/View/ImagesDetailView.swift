//
//  ImagesDetailView.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/29.
//

import Foundation
import UIKit

class ImagesDetailView: UIView {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .tintColor
        pageControl.pageIndicatorTintColor = .systemGray3
        return pageControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        addSubview(pageControl)

        [scrollView, stackView, pageControl].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func configure(with attractionData: AttractionData) {
        setupImages(with: attractionData.images)
        pageControl.numberOfPages = attractionData.images.count
    }

    private func setupImages(with images: [Image]) {
        if images.isEmpty {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false

            let placeholderImage = UIImage(systemName: "photo.fill")
            imageView.image = placeholderImage
            imageView.tintColor = .tintColor

            stackView.addArrangedSubview(imageView)
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        } else {

            for image in images {
                guard let urlString = image.src,
                      let url = URL(string: urlString) else { continue }

                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 10
                imageView.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(imageView)

                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
                imageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "photo")
                )
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImagesDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.bounds.width)
        if !page.isNaN && !page.isInfinite {
            pageControl.currentPage = Int(page)
        }
    }
}
