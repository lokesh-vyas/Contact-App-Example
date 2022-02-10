//
//  BaseCoordinator.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import Foundation

open class BaseCoordinator: NSObject {
  public private(set) var childCoordinators: [BaseCoordinator] = []
  
  open func start() {
    preconditionFailure("This method needs to be overriden by concrete subclass.")
  }
  
  open func finish() {
    preconditionFailure("This method needs to be overriden by concrete subclass.")
  }
  
  public func addChildCoordinator(_ coordinator: BaseCoordinator) {
    childCoordinators.append(coordinator)
  }
  
  public func removeChildCoordinator(_ coordinator: BaseCoordinator) {
    if let index = childCoordinators.firstIndex(of: coordinator) {
      childCoordinators.remove(at: index)
    } else {
      print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
    }
  }
  
  public func removeAllChildCoordinatorsWith<T>(type: T.Type) {
    childCoordinators = childCoordinators.filter { $0 is T == false }
  }
  
  public func removeAllChildCoordinators() {
    childCoordinators.removeAll()
  }
  
  public func contains<T>(_ coordinatorType: T.Type) -> Bool {
    let coordinators = childCoordinators.filter { $0 is T == true }
    return coordinators.count > 0
  }
}
