//
//  MyCasesViewController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/28/23.
//

import UIKit
import Combine

protocol CasesViewProtocol: AnyObject {
    func caseListUpdated(_ cases: [CaseStatus])
}

class CasesViewController: UIViewController {

    var interactor: CasesInteracterProtocol

    var cases: [CaseStatus] = []

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
        interactor.deleteCase(receiptNumber: cases[indexPath.row].receiptNumber)
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

    private lazy var ftueChildVc = FTUEViewController {
        self.interactor.addNewCase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationItems()
        setupCollectionView()

        interactor.loadCases()
    }

    init(interactor: CasesInteracterProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
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
        interactor.addNewCase()
    }
}

extension CasesViewController: CasesViewProtocol {
    func caseListUpdated(_ cases: [CaseStatus]) {
        if cases.isEmpty {
            add(ftueChildVc)
        } else {
            ftueChildVc.remove()
        }
        self.cases = cases
        collectionView.reloadData()
    }
}

extension CasesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.caseSelected(cases[indexPath.row])
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension CasesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaseListCell.reuseId, for: indexPath) as! CaseListCell
        cell.caseStatus = cases[indexPath.row]
        return cell
    }
}

