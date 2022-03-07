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
    lazy var viewModel = HomeViewModel(repository: repository)

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            UINib(nibName: CaseTableCellView.Constants.nibName, bundle: nil),
            forCellReuseIdentifier: CaseTableCellView.Constants.reuseId)
        tableView.register(
            CaseTableHeaderView.self,
            forHeaderFooterViewReuseIdentifier: CaseTableHeaderView.Constants.reuseId)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    lazy var addButtonProminent: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .borderedProminent()
        button.configuration?.title = "Add Your First Case"
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()

    lazy var addButtonConstraints = [
        addButtonProminent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        addButtonProminent.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]

    lazy var addButtonNavBar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

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
    }

    private func setupCollectionView() {
        view.addSubview(tableView)
        view.addSubview(addButtonProminent)

        addButtonConstraints = [
            addButtonProminent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButtonProminent.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func hideEmptyViewState() {
        addButtonProminent.removeFromSuperview()
        NSLayoutConstraint.deactivate(addButtonConstraints)
        navigationItem.rightBarButtonItems = [addButtonNavBar]
    }

    private func showEmptyViewState() {
        view.addSubview(addButtonProminent)
        NSLayoutConstraint.activate(addButtonConstraints)
        navigationItem.rightBarButtonItems = []
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        // tableView.refreshControl = refreshControl
        tableView.insertSubview(refreshControl, at: 0)
    }

    private func loadData() {
        viewModel
            .$cases
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cases in
                guard let self = self else { return }
                self.tableView.reloadData()

                if cases.isEmpty {
                    self.showEmptyViewState()
                } else {
                    self.hideEmptyViewState()
                }
            }
            .store(in: &subscriptions)

        viewModel
            .$loading
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

    @objc func refreshPulled() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CaseTableCellView.Constants.reuseId, for: indexPath)

        if let cell = cell as? CaseTableCellView {
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
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CaseTableHeaderView.Constants.reuseId)
        (cell as? CaseTableHeaderView)?.label.text = viewModel.lastUpdatedLoadingMessage
        return cell
    }

    private func onCaseRemove(_ caseStatus: CaseStatus) {
        viewModel.removeCase(receiptNumber: caseStatus.receiptNumber)
    }
}
