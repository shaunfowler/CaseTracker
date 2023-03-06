//
//  MyCasesPresenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import Foundation

protocol CasesPresenterProtocol {
    func onCaseListUpdated(_ cases: [CaseStatus])
    func onLoadingStateChanged(_ isLoading: Bool)
}

class CasesPresenter {

    weak var view: CasesViewProtocol?
}

extension CasesPresenter: CasesPresenterProtocol {

    func onCaseListUpdated(_ cases: [CaseStatus]) {
        view?.caseListUpdated(cases)

        let lastFetch = cases
            .compactMap { $0.lastFetched }
            .sorted { lhs, rhs in lhs < rhs }
            .first // earliest date

        if let lastFetch {
            view?.fetchStatusLabelUpdated(text: "Last refreshed \(lastFetch.formatted())")
        } else {
            view?.fetchStatusLabelUpdated(text: "")
        }
    }

    func onLoadingStateChanged(_ isLoading: Bool) {
        view?.loadingStateChanged(isLoading)
        if isLoading {
            view?.fetchStatusLabelUpdated(text: "Refreshing...")
        }
    }
}
