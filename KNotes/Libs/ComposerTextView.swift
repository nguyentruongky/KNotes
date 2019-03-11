//
//  ComposerTextView.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import LEOTextView

class ComposerTextView: LEOTextView {
    private let button = UIMaker.makeButton()
    var isActive = false {
        didSet {
            if isActive {
                isEditable = true
                button.isHidden = true
            } else {
                isEditable = false
                button.isHidden = false
            }
        }
    }

    override init(normalFont: UIFont, titleFont: UIFont, boldFont: UIFont, italicFont: UIFont) {
        super.init(normalFont: normalFont, titleFont: titleFont, boldFont: boldFont, italicFont: italicFont)
        setupView()
    }

    init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.alpha(0.5)
        button.addTarget(self, action: #selector(onActivateTextView))
        button.isHidden = true
        isEditable = true
        dataDetectorTypes = .all
    }

    func setupInternalLayout() {
//        superview?.addFill(button)
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        isActive = true
        super.becomeFirstResponder()
        return true
    }

    func activateTextView() {
        isActive = true
        becomeFirstResponder()
    }

    func deactivateTextView() {
        resignFirstResponder()
        isActive = false
    }

    @objc private func onActivateTextView() {
        activateTextView()
    }
}
