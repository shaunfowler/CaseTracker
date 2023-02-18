//
//  AddNewCaseFeature.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import Combine
import UIKit

enum AddNewCaseFeatureFeatureEvent {
    case confirm(String)
    case cancel
}

enum AddNewCaseFeatureViewAction {
    case addCaseTapped(String)
    case closeTapped
}

struct AddNewCaseFeatureViewState {
    var error: Error?
    var loading: Bool
}

class AddNewCaseFeature: BaseFeature<AddNewCaseFeatureFeatureEvent> {

    let router: Router
    let repository: Repository

    public lazy var rootViewController: UIViewController = {
        let interactor = AddNewCaseInteractor(eventSubject: eventSubject, repository: repository)
        let presenter = AddNewCasePresenter(interactor: interactor)
        return AddNewCaseViewController(presenter: presenter)
    }()

    init(repository: Repository, router: Router) {
        self.repository = repository
        self.router = router
    }

    override func handle(event: AddNewCaseFeatureFeatureEvent) {
        switch event {
        case .confirm(let receiptNumber):
            router.route(to: .myCases)
        case .cancel:
            router.route(to: .myCases)
        }
    }
}

class AddNewCaseFeatureFeatureFactory: FeatureFactory {

    private var cancellables = Set<AnyCancellable>()
    private let dependencies: DependencyFactory

    lazy var feature = AddNewCaseFeature(
        repository: dependencies.getRepository(),
        router: dependencies.getRouter()
    )

    init(dependencies: DependencyFactory) {
        self.dependencies = dependencies
    }

    func build() -> UIViewController {
        feature.rootViewController
    }
}
