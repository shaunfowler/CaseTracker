//
//  AddNewCasePresenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation

class AddNewCasePresenter: Presenter<AddNewCaseFeatureViewAction, AddNewCaseFeatureViewState, AddNewCaseFeatureFeatureEvent> {

    init(interactor: AddNewCaseInteractor) {
        super.init(interactor: interactor) { interactor in
                .init()
        }
    }
}
