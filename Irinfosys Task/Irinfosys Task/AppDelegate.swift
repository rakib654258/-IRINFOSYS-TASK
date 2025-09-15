//
//  AppDelegate.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

    func loadHomeScene(onCompletion completion: (()-> Void)? = nil){
        if UIApplication.shared.keyWindow != nil {
            
            UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: .transitionCrossDissolve) {
                
                UIApplication.shared.keyWindow?.rootViewController = nil
                UIApplication.shared.keyWindow?.rootViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UsersViewControllerNav") as! UINavigationController)
                
            } completion: { (ended) in
                
                if let completion = completion{
                    completion()
                }
            }
        }
    }

    func logout() {
        do {
            let tokenStore = KeychainTokenStore()
            try tokenStore.clear()
            debugPrint("Token cleared successfully")
        } catch {
            debugPrint("Failed to clear token:", error)
        }
        guard let window = UIApplication.shared.windows.first else { return }
        
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            window.rootViewController = loginVC
        },
                          completion: nil)
    }
}

