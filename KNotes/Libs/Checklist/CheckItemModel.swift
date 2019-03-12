//
//  CheckModel.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
class KCheckItem {
    var title: String?
    var isChecked = false
    init(title: String) {
        self.title = title
    }

    init(rawData: AnyObject) {
        title = rawData["title"] as? String
        isChecked = rawData["isChecked"] as? Bool ?? false
    }

    func toJSON() -> Any {
        var dict = [String: Any]()
        dict["title"] = title ?? ""
        dict["isChecked"] = isChecked
        return dict
    }
}
