//
//  TestCoreDataStack.swift
//  CaseTrackerTests
//
//  Created by Shaun Fowler on 3/24/22.
//

import Foundation
import CoreData

class TestCoreDataStack: NSObject {

    lazy var persistentContainer: NSPersistentContainer = {

        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")

        let container = NSPersistentContainer(name: "CaseTrackerModel")
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()
}
