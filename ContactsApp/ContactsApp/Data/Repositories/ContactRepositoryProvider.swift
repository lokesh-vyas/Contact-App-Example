//
//  ContactRepositoryProvider.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 21/01/22.
//

import Foundation
import Network
class ContactRepositoryProvider: ContactRepository {
  typealias Dependency =
    ContactLocalDataSourceInjectable
      & ContactRemoteDataSourceInjectable

  let localDataSource: ContactLocalDataSource
  let remoteDataSource: ContactRemoteDataSource

  init(depedency: Dependency) {
    self.localDataSource = depedency.contactLocalDataSource
    self.remoteDataSource = depedency.contactRemoteDataSource
  }

  fileprivate func extractEntityFromList(_ result: Result<[ContactModel], Error>, _ completion: @escaping (Result<[ContactsEntity], Error>) -> Void) {
    switch result {
    case .success(let data):
      let results = data.map { ContactsEntity(from: $0) }
      completion(.success(results))
    case .failure(let error):
      print(error)
      completion(.failure(error))
    }
  }

  func fetchLocalContacts(completion: @escaping (Result<[ContactsEntity], Error>) -> Void) {
    localDataSource.fetchAll { [weak self] result in
      guard let self = self else {
        return
      }
      self.extractEntityFromList(result, completion)
    }
  }

  func fetchContactsFromRemote(completion: @escaping (Result<[ContactsEntity], Error>) -> Void) {
    remoteDataSource.fetchContact { [weak self] result in
      guard let self = self else {
        return
      }
      if case Result.success(let data) = result {
        self.localDataSource.saveAllContacts(contacts: data, completion: nil)
        self.extractEntityFromList(result, completion)
      } else if case Result.failure(let error) = result {
        completion(.failure(error))
      }
    }
  }

  func addContact(entity: ContactsEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
    localDataSource.saveContact(contact: ContactModel(from: entity), completion: completion)
  }

  func updateContact(entity: ContactsEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
    localDataSource.updateContact(contact: ContactModel(from: entity), completion: completion)
  }
}
