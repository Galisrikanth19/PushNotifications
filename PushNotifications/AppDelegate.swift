//
//  AppDelegate.swift
//  PushNotifications
//
//  Created by mac on 14/05/22.
//

import UIKit

import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureFireBasePushNotifications(ForUIApplication: application, WithLaunchingOptions: launchOptions)
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

// MARK: PushNotifications Setup
extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    
    private func configureFireBasePushNotifications(ForUIApplication application: UIApplication, WithLaunchingOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (authorized, errorObj) in
            guard authorized else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        // When the app launch after user tap on notification (originally was not running / not in background)
        if(launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil){
            // your code here
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { (tokenStr, errorObj) in
            guard let token = tokenStr else { return }
            print("******token******")
            print(token)
            print("******token******")
        }
    }
    
    // This function will be called when the app receive notification
      func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          
        // show the notification banner, and with sound
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.banner, .sound])
      }
     
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // tell the app that we have finished processing the user’s action
        let userInfo = response.notification.request.content.userInfo
        let title = response.notification.request.content.title
        let message = response.notification.request.content.body
        print(userInfo)
        print(title)
        print(message)
        
        let application = UIApplication.shared
        
        if(application.applicationState == .active) {
            print("user tapped the notification bar when the app is in foreground")
        }
        
        if(application.applicationState == .inactive) {
            print("user tapped the notification bar when the app is in background")
        }
        
        /* Change root view controller to a specific viewcontroller */
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // let vc = storyboard.instantiateViewController(withIdentifier: "ViewControllerStoryboardID") as? ViewController
        // self.window?.rootViewController = vc
        completionHandler()
    }
    
}
