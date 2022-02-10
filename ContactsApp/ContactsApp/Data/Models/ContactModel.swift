//
//  ContactModel.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 21/01/22.
//

import CoreData
import Foundation
struct ContactModel {
  var id: String = ""
  var firstName: String = ""
  var lastName: String = ""
  var email: String = ""
  var isFavourite: Bool = false
  var mobileNumber: Int = 0
  var avatarUrl: String = ""
}

extension ContactModel: Codable {
  enum ContactModel: String, CodingKey {
    case id
    case firstName
    case lastName
    case email
    case isFavourite
    case mobileNumber
    case avatarUrl
  }

  init(from decoder: Decoder) throws {
    let newsContainer = try decoder.container(keyedBy: ContactModel.self)
    self.id = try newsContainer.decode(String.self, forKey: .id)
    self.firstName = try newsContainer.decode(String.self, forKey: .firstName)
    self.lastName = try newsContainer.decode(String.self, forKey: .lastName)
    self.email = try newsContainer.decode(String.self, forKey: .email)
    self.isFavourite = try newsContainer.decode(Bool.self, forKey: .isFavourite)
    let strMobile = try newsContainer.decode(String.self, forKey: .mobileNumber)
    self.mobileNumber = Int(strMobile) ?? 0
    self.avatarUrl = try newsContainer.decode(String.self, forKey: .avatarUrl)
  }
}

extension ContactModel {
  init(from cdData: CDContact) {
    self.id = cdData.id ?? ""
    self.firstName = cdData.firstName ?? ""
    self.lastName = cdData.lastName ?? ""
    self.email = cdData.email ?? ""
    self.isFavourite = cdData.isFavourite
    self.mobileNumber = Int(cdData.mobileNumber)
    self.avatarUrl = cdData.avatarUrl ?? ""
  }

  init(from cdData: ContactsEntity) {
    self.id = cdData.id
    self.firstName = cdData.firstName
    self.lastName = cdData.lastName
    self.email = cdData.email
    self.isFavourite = cdData.isFavourite
    self.mobileNumber = Int(cdData.mobileNumber)
    self.avatarUrl = cdData.avatarUrl
  }
}

extension ContactModel {
  @discardableResult
  func toCDContact(context: NSManagedObjectContext) -> CDContact {
    let cdData = CDContact(context: context)
    cdData.id = self.id
    cdData.firstName = self.firstName
    cdData.lastName = self.lastName
    cdData.email = self.email
    cdData.isFavourite = self.isFavourite
    cdData.mobileNumber = Int64(self.mobileNumber)
    cdData.avatarUrl = self.avatarUrl
    return cdData
  }
}
