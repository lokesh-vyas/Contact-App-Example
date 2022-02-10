//
//  CoreDataStorage.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import CoreData
import Foundation
import UIKit
enum CoreDataError: Error {
  case cannotPerform
}

class CoreDataStorage: NSObject {
  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
    var modelURL = Bundle(for: type(of: self)).url(forResource: "ContactsApp", withExtension: "momd")!
    modelURL.appendPathComponent("ContactsApp.mom")
    let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
    let container = NSPersistentContainer(name: "ContactsApp", managedObjectModel: managedObjectModel!)
    container.loadPersistentStores(completionHandler: { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  public lazy var readContext: NSManagedObjectContext = {
    let context = persistentContainer.viewContext
    return context
  }()

  public func writeContext() -> NSManagedObjectContext {
    let context = persistentContainer.newBackgroundContext()
    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return context
  }

  // MARK: - Core Data Saving support

  public func saveContext() {
    let context = writeContext()
    context.perform {
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }

  func clearStorage(forEntity entity: String) {
    let managedObjectContext = persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
      try managedObjectContext.execute(batchDeleteRequest)
    } catch let error as NSError {
      print(error)
    }
  }
}
