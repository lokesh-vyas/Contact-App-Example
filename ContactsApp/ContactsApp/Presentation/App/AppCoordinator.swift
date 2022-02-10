//
//  AppCoordinator.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import Foundation
import UIKit

@objc class AppCoordinator: BaseCoordinator {
  // MARK: - Properties

  let window: UIWindow?
  private let dependency: AllInjectables
  private lazy var rootNavigationViewController: UINavigationController = {
    UINavigationController()
  }()

  // MARK: - Coordinator life cycle

  init(window: UIWindow?, dependencies: AllInjectables) {
    self.window = window
    self.dependency = dependencies
  }

  @objc override func start() {
    guard let _ = window else {
      return
    }
    self.window?.rootViewController = self.rootNavigationViewController
    self.window?.makeKeyAndVisible()
    self.showMainFlow()
  }

  @objc override func finish() {
    self.reset()
  }

  private final func showMainFlow() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else {
        return
      }
      let homeCoordinator =
        HomeCoordinator(navigationController: self.rootNavigationViewController, dependency: self.dependency)
      self.addChildCoordinator(homeCoordinator)
      homeCoordinator.homeCoordinatorDelegate = self
      homeCoordinator.start()
    }
  }

  private final func reset() {
    // Remove all the childViewCoordinators recursively
    self.removeAllChildCoordinators()
  }
}

extension AppCoordinator: HomeCoordinatorDelegate {}
