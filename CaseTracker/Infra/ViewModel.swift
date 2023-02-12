//
//  ViewModel.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-11.
//

import Foundation
import Combine

protocol ViewModel<ViewAction, Output> {

    associatedtype ViewAction
    associatedtype Output

    func handle(input: AnyPublisher<ViewAction, Never>) -> AnyPublisher<Output, Never>
}
