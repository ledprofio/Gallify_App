//
//  AppDelegate.swift
//  Spotify
//
//  Created by Tejvir Mann on 2/15/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //configure firebase
        FirebaseApp.configure()
        
        // Override point for customization after application launch.Done. 17 App delegate.
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        //home screen if signed in, else login
        if(AuthManager.shared.isSignedIn){
            window.rootViewController = TabBarViewController()
        }
        else{
            let navVC = UINavigationController(rootViewController: WelcomeViewController())
            navVC.navigationBar.prefersLargeTitles = true //make login title larger.
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = navVC
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

