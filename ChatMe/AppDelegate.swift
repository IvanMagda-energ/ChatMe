//
//  AppDelegate.swift
//  ChatMe
//
//  Created by Ivan Magda on 13.08.2024.
//

import Foundation
import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Your code here")
        FirebaseApp.configure()
        return true
    }
}
