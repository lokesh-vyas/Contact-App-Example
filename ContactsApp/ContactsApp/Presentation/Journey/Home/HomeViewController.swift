//
//  HomeViewController.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import UIKit

class HomeViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  var homeViewModel: HomeViewModelType?
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUi()
    showHUD(progressLabel: "Loading...")
    homeViewModel?.fetchContact()
  }

  private final func setupUi() {
    configureTableView()
  }

  private final func configureTableView() {
    tableView.backgroundColor = .clear
    tableView.register(UINib(nibName: "ContactCell", bundle: nil),
                       forCellReuseIdentifier: "ContactCell")
    tableView.register(UINib(nibName: "ContactHeaderViewCell", bundle: nil),
                       forHeaderFooterViewReuseIdentifier: "ContactHeaderViewCell")
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 72
    tableView.sectionHeaderHeight = UITableView.automaticDimension
    tableView.estimatedSectionHeaderHeight = 44
    tableView.dataSource = self
    tableView.delegate = self
    tableView.sectionIndexBackgroundColor = .clear
    tableView.sectionIndexColor = .cyan
    tableView.tableFooterView = UIView()
    var frame = CGRect.zero
    frame.size.height = .leastNormalMagnitude
    tableView.tableHeaderView = UIView(frame: frame)
  }
}

extension HomeViewController: HomeViewModelToControllerDelegate {
  func refreshTable(at index: IndexPath) {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadRows(at: [index], with: .automatic)
    }
  }

  func showErrorMessage(message: String) {}

  func refreshTable() {
    dismissHUD()
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadData()
    }
  }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    homeViewModel?.numberOfSections() ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    homeViewModel?.numberOfRowsInSection(section: section) ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
    if let cell = cell as? ContactCell, let model = homeViewModel, let entity = model.getItem(at: indexPath) {
      cell.configure(contactEntity: entity)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    .none
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let label = homeViewModel?.getFavoriteTitle(at: indexPath) ?? "Favorite"
    let action = UIContextualAction(style: .normal, title: label) { [weak self] _, _, completionHandler in
      self?.handleMarkAsFavourite(at: indexPath)
      completionHandler(true)
    }
    action.backgroundColor = .systemBlue
    let config = UISwipeActionsConfiguration(actions: [action])
    config.performsFirstActionWithFullSwipe = true
    return config
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let header = homeViewModel?.getSectionTitle(at: section), let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContactHeaderViewCell") as? ContactHeaderViewCell {
      headerCell.setHeader(title: header)
      return headerCell
    }
    return nil
  }

  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at section: Int) -> Int {
    guard let i = homeViewModel?.getIndex(for: title) else { return 0 }
    DispatchQueue.main.async {
      let indexPath = IndexPath(row: 0, section: i)
      tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    return i
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let model = homeViewModel, let entity = model.getItem(at: indexPath) {
      homeViewModel?.showDetails(for: entity)
    }
    tableView.deselectRow(at: indexPath, animated: false)
  }

  func sectionIndexTitles(for _: UITableView) -> [String]? {
    homeViewModel?.getIndexTitles()
  }

  private func handleMarkAsFavourite(at index: IndexPath) {
    homeViewModel?.toggleItemFavorite(at: index)
  }
}
