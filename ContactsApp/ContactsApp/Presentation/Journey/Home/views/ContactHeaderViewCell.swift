//
//  ContactHeaderViewCell.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 24/01/22.
//

import UIKit

class ContactHeaderViewCell: UITableViewHeaderFooterView {
  @IBOutlet var header: UILabel!
  override func prepareForReuse() {
    super.prepareForReuse()
    header.text = ""
  }

  func setHeader(title: String) {
    header.text = title
  }
}
