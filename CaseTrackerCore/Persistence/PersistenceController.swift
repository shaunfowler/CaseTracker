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

        // Manually create managed object from the CaseTrackerCore bundle
        let managedObjectModelUrl = Bundle(for: PersistenceController.self)
            .url(forResource: "CaseTrackerModel",
                 withExtension: "momd")!

        container = NSPersistentCloudKitContainer(
            name: "CaseTrackerModel",
            managedObjectModel: NSManagedObjectModel(contentsOf: managedObjectModelUrl)!
        )

        #if DEBUG
        if CommandLine.arguments.contains("-uiTests") {
            print("*** Using in-memory persistence container ***")
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
        #endif

        container.loadPersistentStores(completionHandler: { _, error in
            defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "PersistenceController_init") }
            if let error = error as NSError? {
                DDLogError("Failed to load CoreData persistent stores. Error: \(error).")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
