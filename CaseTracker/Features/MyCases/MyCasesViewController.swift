//
//  MyCasesViewController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/28/23.
//

import UIKit
import Combine

class CaseListCell: UICollectionViewListCell {
    static let reuseId = "CaseListCell"

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

class MyCasesViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    private let viewModel: MyCasesViewModel

    init(viewModel: MyCasesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewEventPublisher = PassthroughSubject<MyCasesViewModel.ViewAction, Never>()
    var items = [String]()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CaseListCell.self, forCellWithReuseIdentifier: CaseListCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()

        viewEventPublisher
            .send(.viewDidLoad)

        setupCollectionView()
    }

    private func bind() {
        viewModel
            .handle(input: viewEventPublisher.eraseToAnyPublisher())
            .sink { [weak self] viewResult in
                guard let self else { return }
                switch viewResult {
                case .loaded(let items):
                    self.items = items
                    self.collectionView.reloadData()
                case .loading:
                    break
                case .failed(_):
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func setupCollectionView() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

extension MyCasesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewEventPublisher.send(.caseSelected(items[indexPath.row]))
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MyCasesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension MyCasesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection", items.count, items)
        return items.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaseListCell.reuseId, for: indexPath) as? CaseListCell else {
            return UICollectionViewCell()
        }

        var configuration = cell.defaultContentConfiguration()
        configuration.text = items[indexPath.row]
        cell.contentConfiguration = configuration
        cell.backgroundColor = .systemBackground
        return cell
    }
}

