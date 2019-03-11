//
//  NotesList.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class KNoteItem: knListCell<KNote> {
    override var data: KNote? {
        didSet {
            titleLabel.text = data?.title
            firstLineLabel.text = data?.firstLine
            if let timestamp = data?.timestamp {
                let date = Date(timeIntervalSince1970: timestamp)
                let format = date.isToday ? "hh:mm a" : "MM/dd/yyyy"
                timeLabel.text = date.toString(format)
            }
        }
    }

    let titleLabel = UIMaker.makeLabel(font: UIFont.boldSystemFont(ofSize: 15),
                                       color: .black)
    let timeLabel = UIMaker.makeLabel(font: UIFont.systemFont(ofSize: 13),
                                           color: .lightGray)
    let firstLineLabel = UIMaker.makeLabel(font: UIFont.systemFont(ofSize: 13),
                                       color: .lightGray)

    override func setupView() {
        addSubviews(views: titleLabel, timeLabel, firstLineLabel)

        titleLabel.horizontal(toView: self, space: padding)
        titleLabel.bottom(toAnchor: centerYAnchor, space: -2)

        timeLabel.left(toView: titleLabel)
        timeLabel.horizontalSpacing(toView: firstLineLabel, space: padding)
        timeLabel.verticalSpacing(toView: titleLabel, space: 4)

        firstLineLabel.right(toView: self, space: -padding)
        firstLineLabel.centerY(toView: timeLabel)
    }
    
}

class KNotesListController: knListController<KNoteItem, KNote> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }

    override func setupView() {
        super.setupView()
        view.addFill(tableView)
    }

    override func fetchData() {
        KDBConnector().getNotes(success: didGetNotes)
    }

    func didGetNotes(_ data: [KNote]) {
        datasource = data
    }
}


