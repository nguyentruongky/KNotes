//
//  AppDelegate.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        setupApp()
        return true
    }

    func setupApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = appSetting.firstController
        window!.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
    }

    @objc func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }

}

