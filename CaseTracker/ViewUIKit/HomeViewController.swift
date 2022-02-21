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
        static var cellReuseId = "cv-id1"
        static var headerReuseId = "table-header-cell"
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "CaseTableViewRow", bundle: nil), forCellReuseIdentifier: Constants.cellReuseId)
        tableView.register(HeaderTableCell.self, forHeaderFooterViewReuseIdentifier: Constants.headerReuseId)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "HomeBackgroundColor")

        setupNavigationBar()
        setupCollectionView()
        setupRefreshControl()
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

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func loadData() {
        viewModel
            .$cases
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("Reload - $cases")
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)

        viewModel
            .$loading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("Reload - $loading")
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

    @objc func refreshPulled() {
        print("Refresh")
        Task {
            await viewModel.refresh()
            refreshControl.endRefreshing()
        }
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath)

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
        let vc = DetailsViewController(caseStatus: viewModel.cases[indexPath.row], onRemove: onCaseRemove)
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCase(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerReuseId)
        if let cell = cell as? HeaderTableCell {
            cell.label.text = viewModel.lastUpdatedLoadingMessage
        }
        return cell
    }

    private func onCaseRemove(_ caseStatus: CaseStatus) {
        viewModel.removeCase(receiptNumber: caseStatus.receiptNumber)
    }
}

class HeaderTableCell: UITableViewHeaderFooterView {

    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()

    override func layoutSubviews() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
