//
//  CheckList.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class KCheckItem {
    var title: String?
    var isChecked = false
    init(title: String) {
        self.title = title
    }
}

class KCheckItemCell: knListCell<KCheckItem>, UITextFieldDelegate {
    override var data: KCheckItem? { didSet {
        titleTextField.text = data?.title
    }}

    weak var delegate: KChecklistDelegate?

    let titleTextField = UIMaker.makeTextField(font: UIFont.systemFont(ofSize: 15),
                                       color: UIColor.black)
    let checkImageView = UIMaker.makeImageView(image: UIImage(named: "not_checked"), contentMode: .scaleAspectFit)

    override func setupView() {
        checkImageView.isUserInteractionEnabled = true
        checkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleChecked)))

        titleTextField.delegate = self

        addSubview(checkImageView)
        addSubview(titleTextField)

        checkImageView.square(edge: 32)
        checkImageView.left(toView: self, space: padding)
        checkImageView.horizontalSpacing(toView: titleTextField, space: 8)
        checkImageView.centerY(toView: self)

        let tfRight = titleTextField.right(toView: self, space: -padding, isActive: false)
        tfRight.priority = UILayoutPriority.init(999)
        tfRight.isActive = true
        titleTextField.centerY(toView: self)
    }

    @objc func toggleChecked() {
        var isChecked = data?.isChecked ?? false
        isChecked = !isChecked
        data?.isChecked = isChecked
        checkImageView.image = UIImage(named: isChecked ? "checked" : "not_checked")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        data?.title = titleTextField.text
        delegate?.addNewItem()
        return true
    }
}

protocol KChecklistDelegate: class {
    func addNewItem()
}

class KChecklistView: knListView<KCheckItemCell, KCheckItem>, KChecklistDelegate {
    static var listHeight: CGFloat = 200
    weak var delegate: KComposerTextViewCheckListDelegate?

    override func setupView() {
        rowHeight = 44
        super.setupView()
        addFill(tableView)

        tableView.backgroundColor = .green
    }

    func setFocus(onIndex index: Int) {
        let ip = IndexPath(item: index, section: 0)
        guard let cell = tableView.cellForRow(at: ip) as? KCheckItemCell else { return }
        cell.titleTextField.becomeFirstResponder()
    }

    override func getCell(at index: IndexPath) -> UITableViewCell {
        let cell = super.getCell(at: index) as? KCheckItemCell
        cell?.delegate = self
        cell?.backgroundColor = .green
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

    func updateListHeight() {
        let newHeight = CGFloat(datasource.count) * rowHeight
        if newHeight > KChecklistView.listHeight {
            delegate?.updateCheckListHeight(newHeight + rowHeight / 2)
        }
    }
}
