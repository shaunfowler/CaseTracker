//
//  MyCasesFeature.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-11.
//

import Foundation
import Combine
import UIKit

enum CasesFeatureEvent {
    case addNewCaseTapped
    case caseSelected(CaseStatus)
}

enum CasesViewAction {
    case viewDidLoad
    case addCaseTapped
    case caseSelected(CaseStatus)
}

struct CasesViewState {
    var cases: [CaseStatus]
}

class CasesFeature: BaseFeature<CasesFeatureEvent> {

    let router: Router
    let repository: Repository

    public lazy var rootViewController: UIViewController = {
        let interactor = CasesInteractor(eventSubject: eventSubject, repository: repository)
        let presenter = CasesPresenter(interactor: interactor)
        return CasesViewController(presenter: presenter)
    }()

    init(repository: Repository, router: Router) {
        self.repository = repository
        self.router = router
    }

    override func handle(event: CasesFeatureEvent) {
        switch event {
        case .caseSelected(let caseStatus):
            router.route(to: .caseDetails(caseStatus))
        case .addNewCaseTapped:
            router.route(to: .addNewCase)
        }
    }
}

class CasesFeatureFactory: FeatureFactory {

    private var cancellables = Set<AnyCancellable>()
    private let dependencies: DependencyFactory

    lazy var feature = CasesFeature(
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
