//
//  CreateNoteWorker.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
struct KCreateNoteWorker {
    var note: KNote
    init(note: KNote) {
        self.note = note
    }

    func execute() {
        let db = KDBConnector().getNoteBucket()
        db.child(note.id).setValue(note.toDict())
    }
}
