//
//  PersistenceController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import Foundation
import CoreData
import OSLog
import CocoaLumberjack

class PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "PersistenceController_init")

        // Manually create managed object from the CaseTrackerCore bundle.
        let managedObjectModelUrl = Bundle(for: PersistenceController.self)
            .url(forResource: "CaseTrackerModel",
                 withExtension: "momd")!

        container = NSPersistentContainer(
            name: "CaseTrackerModel",
            managedObjectModel: NSManagedObjectModel(contentsOf: managedObjectModelUrl)!
        )

        // Use in-memory store for UITests.
#if DEBUG
//        if CommandLine.arguments.contains("-uiTests") {
            print("*** Using in-memory persistence container ***")
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
//        }
#endif

        // Avoid read-only error on upgrade.
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        container.loadPersistentStores { _, error in
            defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "PersistenceController_init") }
            if let error = error as NSError? {
                DDLogError("Failed to load CoreData persistent stores. Error: \(error).")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            // Use test data for UITests for screenshotting.
#if DEBUG
//            if CommandLine.arguments.contains("-uiTests") && CommandLine.arguments.contains("-uiTestsScreenshots") {
                print("*** Seeding CoreData with text data ***")
                self.seedTestData()
//            }
#endif
        }
    }
}

extension PersistenceController {

    func seedTestData() {
        // Insert 4 cases.
        CaseStatusManagedObject.from(model: PreviewDataRepository.case1, context: container.viewContext)
        CaseStatusManagedObject.from(model: PreviewDataRepository.case2, context: container.viewContext)
        CaseStatusManagedObject.from(model: PreviewDataRepository.case3, context: container.viewContext)
        CaseStatusManagedObject.from(model: PreviewDataRepository.case4, context: container.viewContext)

        // Insert history for case #2.
        CaseStatusHistoricalManagedObject.from(model: PreviewDataRepository.case2History1, context: container.viewContext)
        CaseStatusHistoricalManagedObject.from(model: PreviewDataRepository.case2History2, context: container.viewContext)
        CaseStatusHistoricalManagedObject.from(model: PreviewDataRepository.case2History3, context: container.viewContext)
        CaseStatusHistoricalManagedObject.from(model: PreviewDataRepository.case2History4, context: container.viewContext)

        try? container.viewContext.save()
    }
}
