//
//  AppController.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import Foundation
import UIKit

class AppController {
  private var appCoordinator: AppCoordinator!
  private let appDependency = AppDependency()

  func start(with window: UIWindow?) {
    appCoordinator = AppCoordinator(window: window, dependencies: appDependency)
    appDependency.networkConnectivity.startMonitoring()
    appCoordinator.start()
  }
}
