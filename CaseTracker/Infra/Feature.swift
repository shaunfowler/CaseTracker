//
//  Feature.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import Combine
import Foundation
import UIKit

open class ViewController<Action, State>: UIViewController {

    public let presenter: Presenter<Action, State>
    public var cancellables = Set<AnyCancellable>()
    private var previousViewState: State?

    public init(presenter: Presenter<Action, State>) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        presenter.$viewState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] output in
                self?.handle(viewState: output)
            })
            .store(in: &cancellables)
        handle(viewState: presenter.viewState, previousViewState: nil)
        previousViewState = presenter.viewState
    }

    private func handle(viewState: State) {
        self.handle(
            viewState: viewState,
            previousViewState: self.previousViewState
        )
        self.previousViewState = viewState
    }

    open func handle(viewState: State, previousViewState: State?) {
         assertionFailure("implement handle(viewState:)")
     }
}

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

open class Interactor<Action> {

    public var cancellables = Set<AnyCancellable>()

    open func handle(action: Action) {
        assertionFailure("Failed to implement `handle(action:)`")
    }
}
