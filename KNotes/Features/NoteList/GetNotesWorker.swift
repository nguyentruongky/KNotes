//
//  GetNotesWorker.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
struct KGetNotesWorker {
    var success: (([KNote]) -> Void)?
    init(success: (([KNote]) -> Void)?) {
        self.success = success
    }

    func execute() {
        let db = KDBConnector().getNoteBucket()
        db.observeSingleEvent(of: .value) { (snapshot) in
            guard let rawNotes = snapshot.value as? [String: AnyObject] else { return }

            let rawData = Array(rawNotes.values)
            var data = rawData.map({ return KNote(rawData: $0) })
            data.sort(by: { return $0.timestamp > $1.timestamp })
            self.success?(data)
        }
    }
}
