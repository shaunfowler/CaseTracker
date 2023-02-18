//
//  DependencyFactory.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/28/23.
//

import Foundation

class DependencyFactory {

    private var sharedRouter: Router?
    var router: Router {
        if let sharedRouter { return sharedRouter }
        let router = FeatureRouter(dependencies: self)
        sharedRouter = router
        return router
    }

    private var sharedRepository: Repository?
    func getRepository() -> Repository {

        if let sharedRepository { return sharedRepository }

        let notificationService = NotificationService()

        var repository: CaseStatusRepository
#if DEBUG
        if CommandLine.arguments.contains("-uiTests") {
            print("*** Using mocked remote API ***")
            repository = CaseStatusRepository(
                local: LocalCaseStatusPersistence(),
                remote: UITestsRemoteCaseStatusAPI(),
                notificationService: notificationService
            )
        } else {
            repository = CaseStatusRepository(notificationService: notificationService)
        }
#else
        repository = CaseStatusRepository(notificationService: notificationService)
#endif

        sharedRepository = repository
        return repository
    }

    func getRouter() -> Router {
        return router
    }
}
