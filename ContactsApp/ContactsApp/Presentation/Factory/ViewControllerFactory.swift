//
//  ViewControllerFactory.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import Foundation
import UIKit

protocol ViewControllerProvider {
  func provideHomeViewController() -> HomeViewController
  func provideContactEditViewController() -> ContactEditViewController
}

struct ViewControllerFactory: ViewControllerProvider {
  func provideHomeViewController() -> HomeViewController {
    let uiStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    return uiStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
  }

  func provideContactEditViewController() -> ContactEditViewController {
    let uiStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    return uiStoryBoard.instantiateViewController(withIdentifier: "ContactEditViewController") as! ContactEditViewController
  }
}
