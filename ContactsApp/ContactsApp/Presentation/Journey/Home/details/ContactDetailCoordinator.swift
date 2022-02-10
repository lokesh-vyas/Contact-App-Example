//
//  ContactDetailCoordinator.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 24/01/22.
//

import Foundation
import MessageUI
import UIKit

protocol ContactDetailCoordinatorDelegate: AnyObject {}

extension ContactDetailCoordinatorDelegate {}

class ContactDetailCoordinator: BaseCoordinator {
  // MARK: - Properties

  typealias Dependency = AllInjectables
  let navigationController: UINavigationController?
  weak var homeCoordinatorDelegate: ContactDetailCoordinatorDelegate?
  private weak var contactEditViewController: ContactEditViewController?
  private let dependency: Dependency
  private let viewControllerProvider: ViewControllerProvider
  var selectedContact: ContactsEntity?

  // MARK: - Coordinator life cycle

  init(navigationController: UINavigationController?, dependency: Dependency) {
    self.navigationController = navigationController
    self.dependency = dependency
    self.viewControllerProvider = dependency.viewControllerProvider
  }

  override func start() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self, let navigationController = self.navigationController else {
        return
      }
      self.makeContactDetailViewController()
      if let homeVC = self.contactEditViewController {
        navigationController.pushViewController(homeVC, animated: true)
      }
    }
  }

  private final func makeContactDetailViewController() {
    let contactEditViewController = viewControllerProvider.provideContactEditViewController()
    var viewModel = dependency.contactDetailViewModel
    viewModel.coordinatorDelegate = self
    viewModel.viewModelToControllerDelegate = contactEditViewController
    viewModel.selectedContact = selectedContact
    contactEditViewController.viewModel = viewModel
    self.contactEditViewController = contactEditViewController
  }
}

extension ContactDetailCoordinator: ContactDetailViewModelToCoordinatorDelegate {
  func openMessageComposer(number: Int) {
    if MFMessageComposeViewController.canSendText() {
      let controller = MFMessageComposeViewController()
      controller.recipients = ["\(number)"]
      controller.messageComposeDelegate = self
      navigationController?.present(controller, animated: true, completion: nil)
    }
  }

  func openMailComposer(mail: String) {
    if MFMailComposeViewController.canSendMail() {
      let mailComposer = MFMailComposeViewController()
      mailComposer.mailComposeDelegate = self
      mailComposer.setToRecipients([mail])
      navigationController?.present(mailComposer, animated: true)
    }
  }

  func openDialer(url: URL) {
    UIApplication.shared.open(url)
  }
}

extension ContactDetailCoordinator: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true)
  }

  func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    switch result {
      case .cancelled:
        print("Message was cancelled")
        controller.dismiss(animated: true, completion: nil)
      case .failed:
        print("Message failed")
        controller.dismiss(animated: true, completion: nil)
      case .sent:
        print("Message was sent")
        controller.dismiss(animated: true, completion: nil)
      default:
        break
    }
  }
}
