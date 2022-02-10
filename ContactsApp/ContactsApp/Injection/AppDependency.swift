//
//  AppDependency.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import Foundation
/// Top level dependency container for the entire application.
final class AppDependency: AllInjectables {
  // MARK: Singletons

  lazy var networkConnectivity: Connectivity = { NetworkConnectivity.shared }()
  lazy var viewControllerProvider: ViewControllerProvider = { ViewControllerFactory() }()
  lazy var coreDataStore: CoreDataStorage = { CoreDataStorage() }()
  lazy var networkManager: NetworkManager = { NetworkManager() }()
  lazy var contactRepository: ContactRepository = { ContactRepositoryProvider(depedency: self) }()
  lazy var contactUseCase: ContactUseCase = { ContactUseCase(depedency: self) }()
  lazy var contactLocalDataSource: ContactLocalDataSource = { ContactLocalDataSource(dependency: self) }()
  lazy var contactRemoteDataSource: ContactRemoteDataSource = { ContactRemoteDataSource(dependency: self) }()

  // MARK: Factories

  var homeViewModel: HomeViewModelType {
    HomeViewModel(depedency: self)
  }

  var contactDetailViewModel: ContactDetailViewModelType {
    ContactDetailViewModel()
  }
}
