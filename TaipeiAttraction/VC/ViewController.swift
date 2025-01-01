//
//  ViewController.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/27.
//

import UIKit
import Alamofire
import Combine

enum Section: Int, CaseIterable {
    case events = 0
    case attractions = 1
}

class ViewController: UIViewController {
    private let eventViewModel = EventViewModel()
    private let attractionViewModel = AttractionViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let tabView = SectionTabView()
    private var currentSection: Section = .events
    private var currentLanguage: String = "zh-tw"

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, item in
            guard let self = self else { return nil }
            return self.createSectionLayout(for: self.currentSection)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.identifier)
        collectionView.register(AttractionCell.self, forCellWithReuseIdentifier: AttractionCell.identifier)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.identifier)
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var languageButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "globe"),
            style: .plain,
            target: self,
            action: #selector(changeLanguage)
        )
        button.tintColor = .white
        return button
    }()

    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupNavigationBar()
        setupBindings()
        setupGestures()
        fetchData()
        updateLanguageLabel()

        tabView.didSelectTab = { [weak self] index in
            guard let self = self else { return }
            guard let section = Section(rawValue: index) else { return }
            self.switchToSection(section: section)
        }
    }

    private func setupUI() {
        [tabView, collectionView, activityIndicator].forEach { subView in
            view.addSubview(subView)
        }

        [tabView, collectionView, activityIndicator].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabView.heightAnchor.constraint(equalToConstant: 46),

            collectionView.topAnchor.constraint(equalTo: tabView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createSectionLayout(for section: Section) -> NSCollectionLayoutSection {
        return LayoutFactory.createSectionLayout(for: section)
    }

    private func setupNavigationBar() {
        let barLanguageLabel = UIBarButtonItem(customView: languageLabel)
        navigationItem.rightBarButtonItems = [languageButton, barLanguageLabel]
    }

    @objc private func changeLanguage() {
        let alert = UIAlertController(title: "選擇語言", message: nil, preferredStyle: .actionSheet)
        let languages = [
            ("zh-tw", "繁體中文"),
            ("zh-cn", "简体中文"),
            ("en", "English"),
            ("ja", "日本語"),
            ("ko", "한국어"),
            ("es", "Español"),
            ("id", "Bahasa Indonesia"),
            ("th", "ภาษาไทย"),
            ("vi", "Tiếng Việt")
        ]

        for (langCode, language) in languages {
            alert.addAction(UIAlertAction(title: language, style: .default){ [weak self] _ in
                guard let self = self else { return }
                self.currentLanguage = langCode
                self.updateLanguageLabel()
                self.fetchData()
            })
        }

        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }

    private func updateLanguageLabel() {
        let languages = [
            "zh-tw": "繁體中文",
            "zh-cn": "简体中文",
            "en": "English",
            "ja": "日本語",
            "ko": "한국어",
            "es": "Español",
            "id": "Bahasa Indonesia",
            "th": "ภาษาไทย",
            "vi": "Tiếng Việt"
        ]

        languageLabel.text = languages[currentLanguage] ?? currentLanguage
        languageLabel.sizeToFit()
    }

    private func fetchData() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }

        eventViewModel.fetchEvent(language: currentLanguage)
        attractionViewModel.fetchAttractions(language: currentLanguage)
    }

    private func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left where currentSection == .events:
            switchToSection(section: .attractions)
        case .right where currentSection == .attractions:
            switchToSection(section: .events)
        default:
            break
        }
    }

    private func switchToSection(section: Section) {
        currentSection = section
        tabView.updateSlider(toIndex: section.rawValue)
        collectionView.reloadData()
    }

    private func setupBindings() {
        eventViewModel.$events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        eventViewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showErrorAlert()
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        attractionViewModel.$attractions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        attractionViewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showErrorAlert()
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "連線失敗", message: "請檢查網路後重試", preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
        activityIndicator.stopAnimating()
    }
}

// MARK: - CollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentSection {
        case .events:
            return eventViewModel.events.isEmpty ? 1 : eventViewModel.events.count
        case .attractions:
            return attractionViewModel.attractions.isEmpty ? 1 : attractionViewModel.attractions.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch currentSection {
        case .events:
            if eventViewModel.events.isEmpty {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.identifier, for: indexPath) as? EmptyCell else {
                    return UICollectionViewCell()
                }

                return cell
            } else {

                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.identifier, for: indexPath) as? EventCell else {
                    return UICollectionViewCell()
                }
                let event = eventViewModel.events[indexPath.item]
                cell.configure(with: event)

                return cell
            }

        case .attractions:
            if attractionViewModel.attractions.isEmpty {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.identifier, for: indexPath) as? EmptyCell else {
                    return UICollectionViewCell()
                }

                return cell
            } else {

                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttractionCell.identifier, for: indexPath) as? AttractionCell else {
                    return UICollectionViewCell()
                }
                let attraction = attractionViewModel.attractions[indexPath.item]
                cell.configure(with: attraction)
                
                return cell
            }
        }
    }
}

// MARK: - CollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentSection {
        case .events:
            let event = eventViewModel.events[indexPath.item]
            let webViewController = WebViewController(urlString: event.url)
            navigationController?.pushViewController(webViewController, animated: true)

        case .attractions:
            let attraction = attractionViewModel.attractions[indexPath.item]
            let detailPageViewController = DetailPageViewController(attractionData: attraction)
            navigationController?.pushViewController(detailPageViewController, animated: true)
        }
    }
}
