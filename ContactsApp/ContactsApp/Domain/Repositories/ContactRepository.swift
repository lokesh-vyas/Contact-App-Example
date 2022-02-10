//
//  ContactRepository.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 21/01/22.
//

import Foundation
protocol ContactRepository {
  func fetchLocalContacts(completion: @escaping (Result<[ContactsEntity], Error>) -> Void)
  func fetchContactsFromRemote(completion: @escaping (Result<[ContactsEntity], Error>) -> Void)
  func addContact(entity: ContactsEntity, completion: @escaping (Result<Bool, Error>) -> Void)
  func updateContact(entity: ContactsEntity, completion: @escaping (Result<Bool, Error>) -> Void)
}
