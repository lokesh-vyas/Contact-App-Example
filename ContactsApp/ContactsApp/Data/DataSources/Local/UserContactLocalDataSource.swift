//
//  UserContactLocalDataSource.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 21/01/22.
//

import CoreData
import Foundation
class ContactLocalDataSource {
  typealias Dependecy = CoreDataStoreInjectable
  let coreDataSore: CoreDataStorage
  init(dependency: Dependecy) {
    self.coreDataSore = dependency.coreDataStore
  }

  func fetchCount(completion: @escaping (Result<Int, Error>) -> Void) {
    coreDataSore.readContext.perform { [weak self] in
      guard let self = self else {
        completion(.failure(CoreDataError.cannotPerform))
        return
      }
      do {
        let context = self.coreDataSore.readContext
        let request = CDContact.fetchRequest()
        let count = try context.count(for: request)
        completion(.success(count))
      } catch {
        completion(.failure(error))
      }
    }
  }

  func fetchAll(completion: @escaping (Result<[ContactModel], Error>) -> Void) {
    coreDataSore.readContext.perform { [weak self] in
      guard let self = self else {
        completion(.failure(CoreDataError.cannotPerform))
        return
      }
      do {
        let context = self.coreDataSore.readContext
        let request = CDContact.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        let cdResults = try context.fetch(request)
        let results = cdResults.compactMap { ContactModel(from: $0) }
        completion(.success(results))
      } catch {
        completion(.failure(error))
      }
    }
  }

  func saveContact(contact: ContactModel, completion: @escaping (Result<Bool, Error>) -> Void) {
    let context = coreDataSore.writeContext()
    context.perform { [weak self] in
      guard let self = self else { return }
      do {
        let complete = try self.saveContact(contacts: [contact], context: context)
        if complete {
          completion(.success(true))
        } else {
          completion(.success(false))
        }
      } catch {
        completion(.failure(error))
      }
    }
  }

  func saveAllContacts(contacts: [ContactModel], completion: ((Result<Bool, Error>) -> Void)?) {
    let context = coreDataSore.writeContext()
    context.perform { [weak self] in
      guard let self = self else { return }
      do {
        let complete = try self.saveContact(contacts: contacts, context: context)
        if complete {
          completion?(.success(true))
        } else {
          completion?(.success(false))
        }
      } catch {
        print(error)
        completion?(.failure(error))
      }
    }
  }

  func updateContact(contact: ContactModel, completion: @escaping (Result<Bool, Error>) -> Void) {
    saveContact(contact: contact, completion: completion)
  }

  private final func saveContact(contacts: [ContactModel], context: NSManagedObjectContext) throws -> Bool {
    autoreleasepool {
      for contact in contacts {
        contact.toCDContact(context: context)
      }
    }
    if context.hasChanges {
      try context.save()
      return true
    } else {
      return false
    }
  }

  private final func getContact(id: String, context: NSManagedObjectContext) -> CDContact? {
    let fetchRequest = CDContact.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    var results: [CDContact] = []
    do {
      results = try context.fetch(fetchRequest)
      return results.count > 0 ? results[0] : nil
    } catch {
      return nil
    }
  }
}
