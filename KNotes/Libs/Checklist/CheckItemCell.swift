//
//  CheckItemCell.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class KCheckItemCell: knListCell<KCheckItem>, UITextFieldDelegate {
    override var data: KCheckItem? { didSet {
        titleTextField.text = data?.title
        setCheckBox(data?.isChecked ?? false)
        }}

    weak var delegate: KChecklistDelegate?
    let titleTextField = UIMaker.makeTextField(font: UIFont.systemFont(ofSize: 15),
                                               color: UIColor.black)
    let checkImageView = UIMaker.makeImageView(image: UIImage(named: "not_checked"), contentMode: .scaleAspectFit)

    func save() {
        data?.title = titleTextField.text
    }

    private func setCheckBox(_ isChecked: Bool) {
        checkImageView.image = UIImage(named: isChecked ? "checked" : "not_checked")
    }

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
        setCheckBox(isChecked)
    }

    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        data?.title = titleTextField.text
        delegate?.addNewItem()
        return true
    }
}

