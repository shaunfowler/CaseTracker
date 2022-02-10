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

    let container = NSPersistentContainer(name: "CaseTrackerModel")

    init() {
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                Logger.main.fault("Failed to load CoreData persistent stores. Error: \(error, privacy: .public).")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
