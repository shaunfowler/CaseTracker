//
//  Feature.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import Combine
import Foundation
import UIKit

open class ViewController<Action, State, Event>: UIViewController {

    public let presenter: Presenter<Action, State, Event>
    public var cancellables = Set<AnyCancellable>()
    private var previousViewState: State?

    public init(presenter: Presenter<Action, State, Event>) {
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

protocol FeatureFactory {
    func build() -> UIViewController
}

open class BaseFeature<Event> {

    public let eventSubject = PassthroughSubject<Event, Never>()
    public var cancellables = Set<AnyCancellable>()

    init() {
        eventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (event) in
                self?.handle(event: event)
            }.store(in: &cancellables)
    }

    open func handle(event: Event) {
         // no-op
     }
}

open class Presenter<Action, State, Event> {

    @Published public private(set) var viewState: State

    public var cancellables = Set<AnyCancellable>()
    public let interactor: Interactor<Action, Event>

    public init<I: Interactor<Action, Event>>(
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

open class Interactor<Action, Event> {

    public let eventSubject: any Subject<Event, Never>
    public var cancellables = Set<AnyCancellable>()

    public init(eventSubject: some Subject<Event, Never>) {
        self.eventSubject = eventSubject
    }

    open func handle(action: Action) {
        assertionFailure("Failed to implement `handle(action:)`")
    }
}
