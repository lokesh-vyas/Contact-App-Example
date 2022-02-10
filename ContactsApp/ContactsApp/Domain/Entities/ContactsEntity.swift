//
//  ContactsEntity.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 21/01/22.
//

import Foundation
struct ContactsEntity: Equatable {
  var id: String = ""
  var firstName: String = ""
  var lastName: String = ""
  var email: String = ""
  var isFavourite: Bool = false
  var mobileNumber: Int = 0
  var avatarUrl: String = ""

  var fullName: String {
    "\(firstName.capitalized) \(lastName.capitalized)".trimmingCharacters(in: .whitespacesAndNewlines)
  }

  func getImageUrl() -> URL {
    URL(string: avatarUrl) ?? URL(string: "")!
  }

  mutating func setFavorite(isFavorite: Bool) {
    isFavourite = isFavorite
  }
}

extension ContactsEntity {
  init(from: ContactModel) {
    self.id = from.id
    self.firstName = from.firstName
    self.lastName = from.lastName
    self.email = from.email
    self.isFavourite = from.isFavourite
    self.mobileNumber = from.mobileNumber
    self.avatarUrl = from.avatarUrl
  }
}
