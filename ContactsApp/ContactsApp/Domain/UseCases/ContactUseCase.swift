//
//  ContactUseCase.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 21/01/22.
//

import Foundation
class ContactUseCase {
  typealias Dependency = ContactRepositoryInjectable & NetworkConnectivityInjectable
  private let contactRepository: ContactRepository
  private let connectivity: Connectivity
  init(depedency: Dependency) {
    self.contactRepository = depedency.contactRepository
    self.connectivity = depedency.networkConnectivity
  }

  func fetchContacts(isLocal: Bool = false, completion: @escaping (Result<[ContactsEntity], Error>) -> Void) {
    if isLocal || connectivity.currentStatus.status == .notConnected {
      contactRepository.fetchLocalContacts { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let data):
          if data.isEmpty {
            self.contactRepository.fetchContactsFromRemote(completion: completion)
          } else {
            completion(result)
          }
        case .failure:
          self.contactRepository.fetchContactsFromRemote(completion: completion)
        }
      }
    } else {
      contactRepository.fetchContactsFromRemote(completion: completion)
    }
  }

  func updateEntity(contact: ContactsEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
    contactRepository.updateContact(entity: contact, completion: completion)
  }
}
