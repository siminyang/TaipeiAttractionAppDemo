//
//  DetailPageViewController.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/29.
//

import Foundation
import UIKit

class DetailPageViewController: UIViewController, URLTappedDelegate {
    private let attractionData: AttractionData

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let imagesDetailView = ImagesDetailView()
    private let attractionDetailContentView = AttractionDetailContentView()

    init(attractionData: AttractionData) {
        self.attractionData = attractionData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupNavigationBar()
        setupImagesView()
        setupAttractionDetailView()
    }

    private func setupUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imagesDetailView)
        contentView.addSubview(attractionDetailContentView)

        [scrollView, contentView, imagesDetailView, attractionDetailContentView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imagesDetailView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            imagesDetailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imagesDetailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imagesDetailView.heightAnchor.constraint(equalToConstant: 300),

            attractionDetailContentView.topAnchor.constraint(equalTo: imagesDetailView.bottomAnchor, constant: 16),
            attractionDetailContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            attractionDetailContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            attractionDetailContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.title = attractionData.name
    }

    private func setupImagesView() {
        imagesDetailView.configure(with: attractionData)
    }

    private func setupAttractionDetailView() {
        attractionDetailContentView.delegate = self
        attractionDetailContentView.configure(with: attractionData)
    }

    func urlTapped() {
        let webViewController = WebViewController(urlString: attractionData.url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
