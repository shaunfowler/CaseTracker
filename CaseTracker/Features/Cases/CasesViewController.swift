//
//  MyCasesViewController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/28/23.
//

import UIKit
import Combine

class CasesViewController: ViewController<CasesViewAction, CasesViewState> {

    private lazy var layout: UICollectionViewCompositionalLayout = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, completion in
                self.handleDeleteAction(forIndexPath: indexPath)
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return UICollectionViewCompositionalLayout.list(using: config)
    }()

    private func handleDeleteAction(forIndexPath indexPath: IndexPath) {
        let caseStatus = presenter.viewState.cases[indexPath.row]
        presenter.interactor.handle(action: .deleteCase(caseStatus.receiptNumber))
        collectionView.deleteItems(at: [indexPath])
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CaseListCell.self, forCellWithReuseIdentifier: CaseListCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationItems()
        setupCollectionView()
        
        presenter.interactor.handle(action: .viewDidLoad)
    }

    override func handle(viewState: CasesViewState, previousViewState: CasesViewState?) {
        if viewState.cases != previousViewState?.cases {
            collectionView.reloadData()
        }
    }

    private func setupNavigationItems() {
        title = "My Cases"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTapped))
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    @objc private func onAddButtonTapped(_ sender: UIBarButtonItem) {
        presenter.interactor.handle(action: .addCaseTapped)
    }
}

extension CasesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.interactor.handle(action: .caseSelected(presenter.viewState.cases[indexPath.row]))
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension CasesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.viewState.cases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaseListCell.reuseId, for: indexPath) as! CaseListCell
        cell.caseStatus = presenter.viewState.cases[indexPath.row]
        return cell
    }
}

