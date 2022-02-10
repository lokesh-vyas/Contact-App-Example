//
//  ContactEditViewController.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 24/01/22.
//

import Kingfisher
import UIKit
class ContactEditViewController: UIViewController {
  // MARK: - OUTLETS

  @IBOutlet var email: UILabel!
  @IBOutlet var mobileNumber: UILabel!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var name: PaddingLabel!
  @IBOutlet var favorite: UIButton!

  // MARK: -  properties

  var viewModel: ContactDetailViewModelType?
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  // MARK: - ACTIONS

  @IBAction func onFavoriteTap(_ sender: UIButton) {}

  @IBAction func onMessageTap(_ sender: UIButton) {
    if let contact = viewModel?.selectedContact {
      viewModel?.performMessage(number: contact.mobileNumber)
    }
  }

  @IBAction func onEmailTap(_ sender: UIButton) {
    if let contact = viewModel?.selectedContact {
      viewModel?.performMail(url: contact.email)
    }
  }

  @IBAction func onCallTap(_ sender: UIButton) {
    if let contact = viewModel?.selectedContact {
      viewModel?.performCall(number: contact.mobileNumber)
    }
  }

  // MARK: - Methods

  func setupUI() {
    if let contact = viewModel?.selectedContact {
      name.text = contact.fullName
      email.text = contact.email
      mobileNumber.text = "\(contact.mobileNumber)"
      favorite.setImage(contact.isFavourite ? AppImages.favorite : AppImages.unfavorite, for: .normal)
      imageView.kf.setImage(with: contact.getImageUrl(), options: [.transition(.fade(0.2))])
    }
  }
}

extension ContactEditViewController: ContactDetailViewModelToControllerDelegate {}
