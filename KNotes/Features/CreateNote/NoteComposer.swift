//
//  NoteComposer.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class KNoteComposerController: knController {
    let composerTextView = ComposerTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotifcationListenerForScrollView(scrollView: composerTextView)
        setupView()
    }

    override func setupView() {
        title = "New Note"
        view.backgroundColor = .white
        composerTextView.backgroundColor = .white
        composerTextView.activateTextView()

        view.addSubview(composerTextView)
        composerTextView.horizontal(toView: view)
        composerTextView.top(toAnchor: view.safeAreaLayoutGuide.topAnchor)
        composerTextView.bottom(toAnchor: view.safeAreaLayoutGuide.bottomAnchor)

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self, action: #selector(saveNote))
        navigationItem.rightBarButtonItem = saveButton
    }

    @objc func saveNote() {
        guard let text = composerTextView.text else { return }
        let jsonText = composerTextView.textAttributesJSON()
        let note = KNote(rawText: text, jsonText: jsonText)
        KCreateNoteWorker(note: note).execute()
        pop()
    }
}
