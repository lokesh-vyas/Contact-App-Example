//
//  AppDelegate.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 20/01/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private let appController = AppController()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    appController.start(with: window)
    configureAppBarAppearance()
    return true
  }

  private func configureAppBarAppearance() {
    let mainAppearance = UINavigationBar.appearance()
    if #available(iOS 15, *) {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = UIColor.systemBackground
      appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
      mainAppearance.standardAppearance = appearance
      mainAppearance.scrollEdgeAppearance = appearance
    } else {
      mainAppearance.barStyle = .default
      mainAppearance.isTranslucent = false
      mainAppearance.barTintColor = UIColor.white
      mainAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
  }
}
