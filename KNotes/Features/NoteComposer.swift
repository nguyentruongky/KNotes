//
//  NoteComposer.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import SubviewAttachingTextView

class KNoteComposerController: knController {
    let composerTextView = ComposerTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func setupView() {
        title = "New Note"
        view.backgroundColor = .white
        composerTextView.backgroundColor = .white

        view.addSubview(composerTextView)
        composerTextView.setupInternalLayout()
        composerTextView.horizontal(toView: view)
        composerTextView.top(toAnchor: view.safeAreaLayoutGuide.topAnchor)
        composerTextView.bottom(toAnchor: view.safeAreaLayoutGuide.bottomAnchor)

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        navigationItem.rightBarButtonItem = saveButton

        composerTextView.activateTextView()
        composerTextView.inputAccessoryView = UIMaker.makeKeyboardDoneView(target: self, doneAction: #selector(hideKeyboard))
        setupKeyboardNotifcationListenerForScrollView(scrollView: composerTextView)
    }

    @objc func saveNote() {
        guard let text = composerTextView.text else { return }
        let jsonText = composerTextView.textAttributesJSON()
        let note = KNote(rawText: text, jsonText: jsonText)
        KDBConnector().saveNote(note)
        pop()
    }

    @objc func hideKeyboard() {
        composerTextView.deactivateTextView()
    }
}


