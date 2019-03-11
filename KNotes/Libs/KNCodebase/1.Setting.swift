//
//  1.Setting.swift
//  knCollection
//
//  Created by Ky Nguyen Coinhako on 7/3/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

var appSetting = AppSetting()
struct AppSetting {
    var firstController: UIViewController {
        let controller = KNotesListController()
        return UINavigationController(rootViewController: controller)
    }
}

let padding: CGFloat = 24
