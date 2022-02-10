//
//  ContactCell.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 22/01/22.
//

import Kingfisher
import UIKit
class ContactCell: UITableViewCell {
  @IBOutlet var favoriteMarker: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var thumbnail: UIImageView!
  override func prepareForReuse() {
    super.prepareForReuse()
    thumbnail.image = nil
    favoriteMarker.isHidden = true
  }

  func configure(contactEntity: ContactsEntity) {
    nameLabel.text = contactEntity.fullName
    favoriteMarker.isHidden = !contactEntity.isFavourite
    thumbnail.kf.indicatorType = .activity
    thumbnail.kf.setImage(with: contactEntity.getImageUrl(), options: [.transition(.fade(0.2))])
    configureFavoriteIcon()
  }

  private final func configureFavoriteIcon() {
    let image = favoriteMarker?.image?.withRenderingMode(.alwaysTemplate)
    favoriteMarker.image = image
    favoriteMarker.tintColor = favoriteMarker.isHidden ? .clear : .cyan
  }
}
