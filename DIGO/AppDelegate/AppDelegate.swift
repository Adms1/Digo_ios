//
//  AppDelegate.swift
//  DIGO
//
//  Created by ADMS on 20/10/21.
//

import UIKit
import IQKeyboardManager
import SwiftyJSON
import Firebase
import GoogleSignIn
import FacebookCore
import FBSDKCoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootVC:UITabBarController!

   // var googleSignIn = GIDSignIn.sharedInstance


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        // Override point for customization after application launch.
//        GIDSignIn.sharedInstance.clientID = "XXXXXXXXXX-5meoeobXXXXXXXglsin1u01XXXXXX8.apps.googleusercontent.com"
//        
        FirebaseApp.configure()


        if let result  = UserDefaults.standard.value(forKey: "isLogin"){
//            let json = JSON(result)
            if (result as! String == "1")
            {
                PushTLoginViewController()
            }else
            {
                PushToRootViewController()
            }

        }else
        {
            PushToRootViewController()
        }
        return true
    }

    func application(_ application: UIApplication,
                  open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if GIDSignIn.sharedInstance.handle(url) {
         return true
     } else if ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
         return true
     }

     return false
 }

 @available(iOS 9.0, *)
 func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    if GIDSignIn.sharedInstance.handle(url) {
         return true
     } else if ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]
         ) {
         return true
     }
     return false
 }

//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//            return GIDSignIn.sharedInstance.handle(url)
//        }
    func PushToRootViewController()
    {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = mainStoryBoard.instantiateViewController(withIdentifier: "SelectLanguageVC") as! SelectLanguageVC
        let frontNavigationController = UINavigationController(rootViewController: rootVC)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = frontNavigationController
        self.window?.makeKeyAndVisible()
    }
    func PushTLoginViewController()
    {

        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController

//                    let rootVC = storyboard.instantiateViewController(withIdentifier: select_CV) as UIViewController


        let frontNavigationController = UINavigationController(rootViewController: rootVC)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = frontNavigationController
        self.window?.makeKeyAndVisible()


//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        rootVC = mainStoryBoard.instantiateViewController(withIdentifier: "tabbarControl") as? UITabBarController
//        let frontNavigationController = UINavigationController(rootViewController: rootVC)
//        rootVC.tabBar.backgroundColor = .white
//        rootVC.tabBar.barTintColor = .white
//
//        print("tabBar frame",rootVC.tabBar.frame)
//
//        let tabbar = rootVC.tabBar
//        tabbar.barTintColor = UIColor.white
//        tabbar.unselectedItemTintColor = UIColor.black
//        tabbar.tintColor = UIColor.black
//
//
//        let tabHome = tabbar.items![0]
//        tabHome.title = "Home" // tabbar titlee
//        tabHome.image=UIImage(named: "home")?.withRenderingMode(.alwaysOriginal) // deselect image
//        tabHome.selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal) // select image
//
//        let tabFoll = tabbar.items![1]
//        tabFoll.title = "Coins"
//        tabFoll.image=UIImage(named: "coin_tab")?.withRenderingMode(.alwaysOriginal)
//        tabFoll.selectedImage=UIImage(named: "coin_tab")?.withRenderingMode(.alwaysOriginal)
//
//        let tabMsg = tabbar.items![2]
//        tabMsg.title = "Bars"
//        tabMsg.image=UIImage(named: "tab_bars")?.withRenderingMode(.alwaysOriginal)
//        tabMsg.selectedImage=UIImage(named: "tab_bars")?.withRenderingMode(.alwaysOriginal)
//
//        let tabAccounts = tabbar.items![3]
//        tabAccounts.title = "Accounts"
//        tabAccounts.image=UIImage(named: "user")?.withRenderingMode(.alwaysOriginal)
//        tabAccounts.selectedImage=UIImage(named: "user")?.withRenderingMode(.alwaysOriginal)
//
//        frontNavigationController.navigationBar.isHidden = true
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = frontNavigationController
//        self.window?.makeKeyAndVisible()
    }
//    func application(_ application: UIApplication,
//                  open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if GIDSignIn.sharedInstance.handle(url) {
//         return true
//     } else if ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
//         return true
//     }
//
//     return false
// }
//
// @available(iOS 9.0, *)
// func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//    if GIDSignIn.sharedInstance.handle(url) {
//         return true
//     } else if ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//         ) {
//         return true
//     }
//     return false
// }
}

