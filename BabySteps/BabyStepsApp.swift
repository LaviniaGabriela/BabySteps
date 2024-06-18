//
//  BabyStepsApp.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI
import CoreData
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SchoolAppApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firebaseManager = FirebaseManager()
    @StateObject var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseManager)
                .environmentObject(userManager)
        }
    }
}
