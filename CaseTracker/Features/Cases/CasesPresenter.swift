//
//  MyCasesPresenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import Foundation

protocol CasesPresenterProtocol {
    func onCaseListUpdated(_ cases: [CaseStatus])
}

class CasesPresenter {

    weak var view: CasesViewProtocol?
}

extension CasesPresenter: CasesPresenterProtocol {

    func onCaseListUpdated(_ cases: [CaseStatus]) {
        view?.caseListUpdated(cases)
    }
}
