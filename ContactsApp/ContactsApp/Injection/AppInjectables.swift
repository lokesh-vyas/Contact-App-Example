//
//  AppInjectables.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import Foundation
protocol NetworkConnectivityInjectable { var networkConnectivity: Connectivity { get } }
protocol ViewControllerProviderInjectable { var viewControllerProvider: ViewControllerProvider { get } }
protocol CoreDataStoreInjectable { var coreDataStore: CoreDataStorage { get }}
protocol NetworkManagerInjectable { var networkManager: NetworkManager { get }}
