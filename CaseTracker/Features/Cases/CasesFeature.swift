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
    case caseSelected(CaseStatus)
}

enum CasesViewAction {
    case viewDidLoad
    case caseSelected(CaseStatus)
}

struct CasesViewState {
    var cases: [CaseStatus]
}

class CasesFeature: BaseFeature<CasesFeatureEvent> {

    let repository: Repository

    public lazy var rootViewController: UIViewController = {
        let interactor = CasesInteractor(eventSubject: eventSubject, repository: repository)
        let presenter = CasesPresenter(interactor: interactor) { interactor in
            return .init(cases: interactor.casesPublisher ?? [])
        }
        return CasesViewController(presenter: presenter)
    }()

    init(repository: Repository) {
        self.repository = repository
    }

    override func handle(event: CasesFeatureEvent) {
        print("feature event", event)
    }
}

class CasesFeatureFactory {

    private var cancellables = Set<AnyCancellable>()
    private let dependencies: DependencyFactory

    lazy var feature = CasesFeature(repository: dependencies.getRepository())

    init(dependencies: DependencyFactory) {
        self.dependencies = dependencies
    }

    func build() -> UIViewController {
        feature.rootViewController
    }

    deinit {
        print("deinit MyCasesFeatureFactory")
    }
}
