//
//  Extensions.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 22/01/22.
//

import Foundation
import MBProgressHUD
import UIKit
public extension Array {
  subscript(safeIndex index: Int) -> Element? {
    guard index >= 0, index < endIndex else {
      return nil
    }

    return self[index]
  }
}

public extension UIViewController {
  func showHUD(progressLabel: String) {
    DispatchQueue.main.async {
      let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
      progressHUD.label.text = progressLabel
    }
  }

  func dismissHUD() {
    DispatchQueue.main.async {
      MBProgressHUD.hide(for: self.view, animated: true)
    }
  }
}
