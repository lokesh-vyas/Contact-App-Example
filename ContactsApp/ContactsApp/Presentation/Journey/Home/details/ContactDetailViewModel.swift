//
//  ContactDetailViewModel.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 24/01/22.
//

import Foundation
protocol ContactDetailViewModelToCoordinatorDelegate: AnyObject {
  func openDialer(url: URL)
  func openMessageComposer(number: Int)
  func openMailComposer(mail: String)
}

protocol ContactDetailViewModelToControllerDelegate: AnyObject {}

protocol ContactDetailViewModelType {
  var coordinatorDelegate: ContactDetailViewModelToCoordinatorDelegate? { get set }
  var viewModelToControllerDelegate: ContactDetailViewModelToControllerDelegate? { get set }
  var selectedContact: ContactsEntity? { get set }
  func performCall(number: Int)
  func performMessage(number: Int)
  func performMail(url: String)
}

class ContactDetailViewModel: ContactDetailViewModelType {
  weak var coordinatorDelegate: ContactDetailViewModelToCoordinatorDelegate?

  weak var viewModelToControllerDelegate: ContactDetailViewModelToControllerDelegate?

  var selectedContact: ContactsEntity?

  func performCall(number: Int) {
    coordinatorDelegate?.openDialer(url: URL(string: "telprompt//:\(number)")!)
  }

  func performMessage(number: Int) {
    coordinatorDelegate?.openMessageComposer(number: number)
  }

  func performMail(url: String) {
    coordinatorDelegate?.openMailComposer(mail: url)
  }
}
