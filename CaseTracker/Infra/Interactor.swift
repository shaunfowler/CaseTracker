//
//  Interactor.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-24.
//

import Foundation
import Combine

open class Interactor<Action> {

    public var cancellables = Set<AnyCancellable>()

    open func handle(action: Action) {
        assertionFailure("Failed to implement `handle(action:)`")
    }
}
