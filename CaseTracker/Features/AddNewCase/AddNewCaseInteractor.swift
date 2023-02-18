//
//  AddNewCaseInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine

class AddNewCaseInteractor: Interactor<AddNewCaseFeatureViewAction, AddNewCaseFeatureFeatureEvent>, ObservableObject {

    let repository: Repository

    init(eventSubject: PassthroughSubject<AddNewCaseFeatureFeatureEvent, Never>, repository: Repository) {
        self.repository = repository
        super.init(eventSubject: eventSubject)

        bind()
    }

    private func bind() {

    }

    override func handle(action: AddNewCaseFeatureViewAction) {
        switch action {
        case .closeTapped:
            eventSubject.send(.cancel)
        case .addCaseTapped(let receiptNumber):
            eventSubject.send(.confirm(receiptNumber))
        }
    }
}
