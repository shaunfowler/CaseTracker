//
//  CaseDetailsPresenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation

protocol CaseDetailsPresenterProtocol {
    func historyLoaded(_ history: [CaseStatusHistorical])
}

class CaseDetailsPresenter: CaseDetailsPresenterProtocol {

    weak var view: CaseDetailsViewProtocol?

    func historyLoaded(_ history: [CaseStatusHistorical]) {
        view?.historyLoaded(history)
    }
}
