//
//  ContactRemoteDataSource.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 21/01/22.
//

import Foundation
class ContactRemoteDataSource {
  typealias Dependency = NetworkManagerInjectable
  let networkManager: NetworkManager
  init(dependency: Dependency) {
    self.networkManager = dependency.networkManager
  }

  func fetchContact(completion: @escaping (Result<[ContactModel], Error>) -> Void) {
    networkManager.getJsonData(url: APIConstants.baseURl + APIConstants.contacts) { response in
      switch response {
      case .success(let data):
        do {
          let result = try JSONDecoder().decode([ContactModel].self, from: data)
          completion(.success(result))
        } catch {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }?.resume()
  }
}
