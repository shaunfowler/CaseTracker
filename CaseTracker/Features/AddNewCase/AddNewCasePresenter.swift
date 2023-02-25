//
//  AddNewCasePresenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Combine

class AddNewCasePresenter: Presenter<AddNewCaseFeatureViewAction, AddNewCaseFeatureViewState> {

    init(interactor: AddNewCaseInteractor) {
        super.init(interactor: interactor) { interactor in
            return AddNewCaseFeatureViewState(error: interactor.error, loading: interactor.loading)
        }
    }
}
