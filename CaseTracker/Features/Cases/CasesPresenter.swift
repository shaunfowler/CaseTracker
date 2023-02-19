//
//  MyCasesPresenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import Foundation

class CasesPresenter: Presenter<CasesViewAction, CasesViewState, CasesFeatureEvent> {

    init(interactor: CasesInteractor) {
        super.init(interactor: interactor) { interactor in
            return CasesViewState(cases: interactor.casesPublisher ?? [])
        }
    }
}
