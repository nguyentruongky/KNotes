//
//  CheckList.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class KChecklistView: knListView<KCheckItemCell, KCheckItem>, KChecklistDelegate {
    static var listHeight: CGFloat = 200
    weak var delegate: KComposerTextViewCheckListDelegate?

    override func setupView() {
        rowHeight = 44
        super.setupView()
        addFill(tableView)
    }

    func setFocus(onIndex index: Int) {
        let ip = IndexPath(item: index, section: 0)
        guard let cell = tableView.cellForRow(at: ip) as? KCheckItemCell else { return }
        cell.titleTextField.becomeFirstResponder()
    }

    override func getCell(at index: IndexPath) -> UITableViewCell {
        let cell = super.getCell(at: index) as? KCheckItemCell
        cell?.delegate = self
        if index.row == datasource.count - 1 {
            cell?.titleTextField.becomeFirstResponder()
        }
        return cell ?? KCheckItemCell()
    }

    func addNewItem() {
        let emptyItem = KCheckItem(title: "")
        datasource.append(emptyItem)

        updateListHeight()
    }

    // not work as expected yet
    func updateListHeight() {
        let newHeight = CGFloat(datasource.count) * rowHeight
        if newHeight > KChecklistView.listHeight {
            delegate?.updateCheckListHeight(newHeight + rowHeight / 2)
        }
    }

    func toJSON() -> [Any] {
        var dicts = [Any]()
        for i in 0 ..< datasource.count {
            guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                as? KCheckItemCell else { continue }
            cell.save()
            guard let data = cell.data else { continue }
            dicts.append(data.toJSON())
        }
        return dicts
    }
}

protocol KChecklistDelegate: class {
    func addNewItem()
}
