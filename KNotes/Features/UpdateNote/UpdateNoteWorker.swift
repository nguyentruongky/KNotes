//
//  UpdateNoteWorker.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
struct KUpdateNoteWorker {
    var note: KNote
    init(note: KNote) {
        self.note = note
        self.note.timestamp = Date().timeIntervalSince1970
    }

    func execute() {
        let db = KDBConnector().getNoteBucket()
        db.child(note.id).setValue(note.toDict())
    }
}
