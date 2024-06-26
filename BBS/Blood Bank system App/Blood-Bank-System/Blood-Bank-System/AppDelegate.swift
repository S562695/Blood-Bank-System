 

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        sleep(2)
        
        // Set navigation bar tint color
               UINavigationBar.appearance().barTintColor = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0)
               UINavigationBar.appearance().tintColor = UIColor.appColor
               UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

              UINavigationBar.appearance().isTranslucent = true
        
               // Set tab bar tint color
               UITabBar.appearance().barTintColor = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0)
               UITabBar.appearance().tintColor = UIColor.appColor

        
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





