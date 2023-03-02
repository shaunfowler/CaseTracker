//
//  AddNewCasePresenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Combine

protocol AddNewCasePresenterProtocol {
    func setLoading(_ isLoading: Bool)
    func showError(_ error: Error)
}

class AddNewCasePresenter: AddNewCasePresenterProtocol {

    weak var view: AddNewCaseViewProtocol?

    func setLoading(_ isLoading: Bool) {
        view?.loadingStateChanged(isLoading)
    }

    func showError(_ error: Error) {
        view?.didReceive(error: error)
    }
}
