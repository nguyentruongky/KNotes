//
//  NoteEditor.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import RTViewAttachment

class KNoteEditorController: KNoteComposerController {
    var data: KNote? { didSet {
        if let json = data?.jsonText {
            composerTextView.setAttributeTextWithJSONString(json)
        } else {
            composerTextView.text = data?.rawText
        }
    }}

    override func setupView() {
        super.setupView()
        title = data?.title
        composerTextView.deactivateTextView()
    }

    override func saveNote() {
        if data == nil {
            data = KNote(rawText: composerTextView.text,
                         jsonText: composerTextView.textAttributesJSON())
        }
        data?.rawText = composerTextView.text
        data?.jsonText = composerTextView.textAttributesJSON()
        KUpdateNoteWorker(note: data!).execute()
        pop()
    }
}
