//
//  AddNewCasePresenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Combine

class AddNewCasePresenter: Presenter<AddNewCaseFeatureViewAction, AddNewCaseFeatureViewState, AddNewCaseFeatureFeatureEvent> {

    init(interactor: AddNewCaseInteractor) {
        super.init(interactor: interactor) { interactor in
            print("interactor update", interactor.error, interactor.loading)
            return AddNewCaseFeatureViewState(error: interactor.error, loading: interactor.loading)
        }
    }
}
