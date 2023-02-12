//
//  MyCasesFeature.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-11.
//

import Foundation
import Combine
import UIKit

class MyCasesFeatureFactory {

    private var cancellables = Set<AnyCancellable>()
    private let dependencies: DependencyFactory

    lazy var viewModel = MyCasesViewModel(repository: dependencies.getRepository())

    init(dependencies: DependencyFactory) {
        self.dependencies = dependencies
    }

    func build() -> UIViewController {
        viewModel
            .featureSubject
            .print()
            .sink { featureEvent in
                print(featureEvent)
            }
            .store(in: &cancellables)
        return MyCasesViewController(viewModel: viewModel)
    }
}
