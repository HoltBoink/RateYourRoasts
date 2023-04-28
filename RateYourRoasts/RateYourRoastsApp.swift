//
//  RateYourRoastsApp.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/25/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct RateYourRoastsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var reviewVM = ReviewViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(reviewVM)
        }
    }
}
