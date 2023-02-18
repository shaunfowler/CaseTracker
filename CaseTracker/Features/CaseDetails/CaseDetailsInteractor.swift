//
//  CaseDetailsInteractor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine

class CaseDetailsInteractor: Interactor<CaseDetailsFeatureViewAction, CaseDetailsFeatureFeatureEvent>, ObservableObject {

    let caseStatus: CaseStatus
    let repository: Repository

    init(eventSubject: PassthroughSubject<CaseDetailsFeatureFeatureEvent, Never>, repository: Repository, caseStatus: CaseStatus) {
        self.repository = repository
        self.caseStatus = caseStatus
        super.init(eventSubject: eventSubject)
    }
}
