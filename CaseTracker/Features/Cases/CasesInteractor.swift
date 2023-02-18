//
//  MyCasesInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import Foundation
import Combine

class CasesInteractor: Interactor<CasesViewAction, CasesFeatureEvent>, ObservableObject {

    let repository: Repository

    var casesPublisher: [CaseStatus]? = nil {
        didSet {
            print("CP")
            objectWillChange.send()
        }
    }

    init(eventSubject: PassthroughSubject<CasesFeatureEvent, Never>, repository: Repository) {
        self.repository = repository
        super.init(eventSubject: eventSubject)

        bind()
    }

    deinit {
        print("LIN21 DEINIT")
    }

    private func bind() {
        repository
            .data
            .print("RD")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cases in
                guard let self else { return }
                self.casesPublisher = cases
            }
            .store(in: &cancellables)
    }

    override func handle(action: CasesViewAction) {
        switch action {
        case .viewDidLoad:
            Task {
                await repository.query(force: true)
            }
        case .caseSelected(let caseStatus):
            eventSubject.send(.caseSelected(caseStatus))
        case .addCaseTapped:
            eventSubject.send(.addNewCaseTapped)
        case .deleteCase(let caseId):
            Task {
                await repository.removeCase(receiptNumber: caseId)
            }
        }
    }
}
