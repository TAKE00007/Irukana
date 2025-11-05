//
//  IrukanaApp.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

import SwiftUI
import FirebaseCore

#if DEBUG
@main
struct IrukanaApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
#else
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct IrukanaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
#endif
