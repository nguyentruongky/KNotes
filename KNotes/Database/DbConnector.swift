//
//  DbConnector.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import FirebaseDatabase

enum KBucket: String {
    case notes
}

struct KDBConnector {
    func saveNote(_ note: KNote) {
        let data = note.toDict()
        Database.database().reference()
            .child(KBucket.notes.rawValue)
            .child(note.id).setValue(data)
    }

    func getNotes(success: (([KNote]) -> Void)?) {
        Database.database().reference()
            .child(KBucket.notes.rawValue)
            .observeSingleEvent(of: .value) { (snapshot) in
                guard let rawNotes = snapshot.value as? [String: AnyObject] else { return }
                let rawData = Array(rawNotes.values)
                var data = rawData.map({ return KNote(rawData: $0) })
                data.sort(by: { return $0.timestamp > $1.timestamp })
                success?(data)
        }
    }

    func getNoteBucket() -> DatabaseReference {
        return Database.database().reference()
            .child(KBucket.notes.rawValue)
    }
}
