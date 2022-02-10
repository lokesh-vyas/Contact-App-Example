//
//  AllInjectables.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import Foundation

// MARK: -  Type alias for all types of injectables in the entire application

typealias AllInjectables =
  NetworkConnectivityInjectable
    & ViewControllerProviderInjectable
    & CoreDataStoreInjectable
    & NetworkManagerInjectable
    & HomeViewModelInjectable
    & ContactRepositoryInjectable
    & ContactLocalDataSourceInjectable
    & ContactRemoteDataSourceInjectable
    & ContactUseCaseInjectable
    & ContactDetailViewModelInjectable
