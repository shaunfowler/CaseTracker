//
//  CaseDetailsPresenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation

class CaseDetailsPresenter: Presenter<CaseDetailsFeatureViewAction, CaseDetailsFeatureViewState> {

    init(interactor: CaseDetailsInteractor) {
        super.init(interactor: interactor) { interactor in
            return CaseDetailsFeatureViewState(caseStatus: interactor.caseStatus)
        }
    }
}
