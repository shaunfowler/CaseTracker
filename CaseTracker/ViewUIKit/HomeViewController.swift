//
//  HomeViewController.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/20/22.
//

import UIKit
import SwiftUI
import Combine
import CaseTrackerCore

class HomeViewController: UIViewController {

    var subscriptions = Set<AnyCancellable>()
    let repository = CaseStatusRepository()
    lazy var viewModel = HomeViewModel(repository: CaseStatusRepository())

    private enum Constants {
        static var reuseId = "cv-id1"
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "CaseTableViewRow", bundle: nil), forCellReuseIdentifier: Constants.reuseId)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "HomeBackgroundColor")

        setupNavigationBar()
        setupCollectionView()
        loadData()
    }

    private func setupNavigationBar() {
        title = "My Cases"
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [addButton]
    }

    private func setupCollectionView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func loadData() {
        viewModel
            .$cases
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)

        Task {
            await viewModel.fetch()
        }
    }

    @objc func addTapped() {
        let vc = AddCaseViewController(viewModel: AddCaseViewModel(repository: repository)) {
            Task {  [weak self] in await self?.viewModel.fetch() }
        }
        navigationController?.present(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseId, for: indexPath)

        if let cell = cell as? CaseTableViewRow {
            let data = viewModel.cases[indexPath.row]
            cell.formType.text = data.formType
            cell.receiptNumber.text = data.receiptNumber
            cell.status.text = data.status
            cell.lastUpdated.text = "\(data.lastUpdatedFormatted) • \(data.lastUpdatedRelativeDaysFormatted)"
            cell.indicator.backgroundColor = UIColor(data.color)
        }

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(DetailsViewController(caseStatus: viewModel.cases[indexPath.row]), animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCase(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
}
