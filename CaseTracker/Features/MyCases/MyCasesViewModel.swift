//
//  MyCasesViewModel.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-11.
//

import Foundation
import Combine

class MyCasesViewModel: ViewModel {

    enum FeatureAction {
        case caseSelected(String)
    }

    enum ViewAction {
        case viewDidLoad
        case caseSelected(String)
    }

    enum ViewResult {
        case loading
        case loaded([String])
        case failed(Error)
    }

    private var cancellables = Set<AnyCancellable>()
    private var repository: Repository

    var viewState = CurrentValueSubject<ViewResult, Never>(.loading)

    var featureSubject = PassthroughSubject<FeatureAction, Never>()

    init(repository: Repository) {
        self.repository = repository

        repository
            .data
            .sink { [weak self] cases in
                guard let self else { return }
                self.viewState.send(.loaded(cases.map { $0.receiptNumber }))
            }
            .store(in: &cancellables)
    }

    func handle(input: AnyPublisher<ViewAction, Never>) -> AnyPublisher<ViewResult, Never> {
        input
            .sink { [weak self] viewAction in
                guard let self else { return }
                print("handle", viewAction)
                switch viewAction {
                case .viewDidLoad:
                    self.handleViewDidLoad()
                case .caseSelected(let id):
                    self.handleCaseSelected(id: id)
                }
            }
            .store(in: &cancellables)

        return viewState
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private func handleViewDidLoad() {
        Task {
            await repository.query(force: true)
        }
    }

    private func handleCaseSelected(id: String) {
        featureSubject.send(.caseSelected(id))
    }
}
