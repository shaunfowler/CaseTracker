//
//  Presenter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-24.
//

import Foundation
import UIKit
import Combine

open class Presenter<Action, State> {

    @Published public private(set) var viewState: State

    public var cancellables = Set<AnyCancellable>()
    public let interactor: Interactor<Action>

    public init<I: Interactor<Action>>(
        interactor: I,
        initialViewState: State? = nil,
        mapToViewState: @escaping (I) -> State
    ) where I: ObservableObject, I.ObjectWillChangePublisher.Output == Void {
        self.interactor = interactor
        self.viewState = initialViewState ?? mapToViewState(interactor)

        interactor
            .objectWillChange
            .compactMap { [weak interactor] in
                guard let interactor else { return nil }
                return mapToViewState(interactor)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$viewState)
    }
}

