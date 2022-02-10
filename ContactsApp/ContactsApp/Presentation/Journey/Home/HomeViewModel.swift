//
//  HomeViewModel.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import Foundation
import UIKit
protocol HomeViewModelCoordinatorDelegate: AnyObject {
  func showDetails(for entity: ContactsEntity)
}

protocol HomeViewModelToControllerDelegate: AnyObject {
  func refreshTable()
  func refreshTable(at index: IndexPath)
  func showErrorMessage(message: String)
}

protocol HomeViewModelType {
  var coordinatorDelegate: HomeViewModelCoordinatorDelegate? { get set }
  var viewModelToControllerDelegate: HomeViewModelToControllerDelegate? { get set }
  func numberOfSections() -> Int
  func numberOfRowsInSection(section: Int) -> Int
  func getIndexTitles() -> [String]?
  func getIndex(for sectionIndexTitle: String) -> Int?
  func fetchContact()
  func getItem(at index: IndexPath) -> ContactsEntity?
  func toggleItemFavorite(at index: IndexPath)
  func getFavoriteTitle(at index: IndexPath) -> String
  func getSectionTitle(at section: Int) -> String
  func showDetails(for entity: ContactsEntity)
}

private class SectionModel {
  var header: String
  var contacts: [ContactsEntity]
  init(header: String, contacts: [ContactsEntity]) {
    self.header = header
    self.contacts = contacts
  }
}

class HomeViewModel: HomeViewModelType {
  typealias Dependency = ContactUseCaseInjectable

  init(depedency: Dependency) {
    self.contactUseCase = depedency.contactUseCase
  }

  // MARK: - private variables

  private var contactSections: [SectionModel] = []

  // MARK: - public variables

  let contactUseCase: ContactUseCase
  weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
  weak var viewModelToControllerDelegate: HomeViewModelToControllerDelegate?

  // MARK: - Methods

  func getItem(at index: IndexPath) -> ContactsEntity? {
    guard !contactSections.isEmpty, let entity = contactSections[safeIndex: index.section]?.contacts[safeIndex: index.row] else {
      return nil
    }
    return entity
  }

  func fetchContact() {
    contactUseCase.fetchContacts(isLocal: true) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let data):
        self.contactSections = Dictionary(grouping: data) { $0.firstName.first!.uppercased() }.map { element in
          SectionModel(header: element.key, contacts: element.value.sorted { $0.firstName.caseInsensitiveCompare($1.firstName) == .orderedAscending })
        }.sorted { $0.header.caseInsensitiveCompare($1.header) == .orderedAscending }
        self.viewModelToControllerDelegate?.refreshTable()
      case .failure(let error):
        print(error)
      }
    }
  }

  func getIndex(for sectionIndexTitle: String) -> Int? {
    contactSections.firstIndex { $0.header.caseInsensitiveCompare(sectionIndexTitle) == .orderedSame }
  }

  func numberOfRowsInSection(section: Int) -> Int {
    contactSections[safeIndex: section]?.contacts.count ?? 0
  }

  func getIndexTitles() -> [String]? {
    contactSections.map { $0.header }
  }

  func toggleItemFavorite(at index: IndexPath) {
    if var entity = getItem(at: index) {
      entity.setFavorite(isFavorite: !entity.isFavourite)
      contactUseCase.updateEntity(contact: entity) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success:
          if var contacts = self.contactSections[safeIndex: index.section]?.contacts {
            contacts[index.row].setFavorite(isFavorite: entity.isFavourite)
            self.contactSections[safeIndex: index.section]?.contacts = contacts
          }
          self.viewModelToControllerDelegate?.refreshTable(at: index)
        case .failure:
          print("Something went wrong")
        }
      }
    }
  }

  func getFavoriteTitle(at index: IndexPath) -> String {
    if let entity = getItem(at: index) {
      return entity.isFavourite ? "Unfavorite" : "Favorite"
    } else {
      return "Favorite"
    }
  }

  func showDetails(for entity: ContactsEntity) {
    coordinatorDelegate?.showDetails(for: entity)
  }

  func getSectionTitle(at section: Int) -> String {
    contactSections[safeIndex: section]?.header ?? ""
  }

  func numberOfSections() -> Int {
    contactSections.count
  }
}
