//
//  NotesList.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

final class KNotesListController: knListController<KNoteItem, KNote> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    override func setupView() {
        title = "KNotes"
        contentInset = UIEdgeInsets(top: 8)
        rowHeight = 64
        super.setupView()
        view.addFill(tableView)

        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
        navigationItem.rightBarButtonItem = createButton
    }

    @objc func createNote() {
        push(KNoteComposerController())
    }

    override func fetchData() {
        KGetNotesWorker(success: { [weak self] data in self?.didGetNotes(data) })
            .execute()
    }

    func didGetNotes(_ data: [KNote]) {
        datasource = data
    }

    override func didSelectRow(at indexPath: IndexPath) {
        let controller = KNoteEditorController()
        controller.data = datasource[indexPath.row]
        push(controller)
    }
}
