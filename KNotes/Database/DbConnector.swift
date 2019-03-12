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
    // dependency injection: do not depend on Firebase or something
    func getNoteBucket() -> DatabaseReference {
        return Database.database().reference()
            .child(KBucket.notes.rawValue)
    }
}
