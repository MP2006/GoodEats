//
//  GoodEatsApp.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct GoodEatsApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView(userViewModel: UserViewModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options:
                     [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
          return GIDSignIn.sharedInstance.handle(url)
    }
}


