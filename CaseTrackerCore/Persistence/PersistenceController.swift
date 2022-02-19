//
//  PersistenceController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import Foundation
import CoreData
import OSLog

class PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        // Manually create managed object from the CaseTrackerCore bundle
        let managedObjectModelUrl = Bundle(for: PersistenceController.self)
            .url(forResource: "CaseTrackerModel",
                 withExtension: "momd")!

        container = NSPersistentContainer(
            name: "CaseTrackerModel",
            managedObjectModel: NSManagedObjectModel(contentsOf: managedObjectModelUrl)!
        )

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                Logger.main.fault("Failed to load CoreData persistent stores. Error: \(error, privacy: .public).")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
