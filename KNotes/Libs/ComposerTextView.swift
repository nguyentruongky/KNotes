//
//  ComposerTextView.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import LEOTextView

class ComposerTextView: LEOTextView, KComposerTextViewCheckListDelegate {
    private let button = UIMaker.makeButton()
    private var checkListView: KChecklistView?

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

    private let attachmentBehavior = SubviewAttachingTextViewBehavior()
    open override var textContainerInset: UIEdgeInsets {
        didSet {
            // Text container insets are used to convert coordinates between the text container and text view, so a change to these insets must trigger a layout update
            self.attachmentBehavior.layoutAttachedSubviews()
        }
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.alpha(0.5)
        button.addTarget(self, action: #selector(onActivateTextView))
        button.isHidden = true
        isEditable = true
        dataDetectorTypes = .all

        self.attachmentBehavior.textView = self
        self.layoutManager.delegate = self.attachmentBehavior
        self.textStorage.delegate = self.attachmentBehavior

        inputAccessoryView = makeToolbar()
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

    @objc func deactivateTextView() {
        resignFirstResponder()
        isActive = false
    }

    @objc private func onActivateTextView() {
        activateTextView()
    }

    var checkAttachment: SubviewTextAttachment?
    @objc func addCheckList() {
        checkListView = KChecklistView(frame: CGRect(x: 0, y: 0,
                                                 width: screenWidth,
                                                 height: KChecklistView.listHeight))
        checkListView?.delegate = self

        checkListView?.backgroundColor = .green
        let leftPara = NSMutableParagraphStyle()
        leftPara.alignment = .left
        leftPara.paragraphSpacing = 10
        leftPara.paragraphSpacingBefore = 10

        checkAttachment = SubviewTextAttachment(view: checkListView!,
                                                    size: CGSize(width: screenWidth,
                                                                 height: KChecklistView.listHeight))
        attributedText = attributedText
            .insertingAttachment(checkAttachment!, at: text.count, with: leftPara)

        checkListView?.datasource = [KCheckItem(title: "")]
        checkListView?.setFocus(onIndex: 0)
    }

    func updateCheckListHeight(_ height: CGFloat) {
        checkListView?.frame.size.height = height
        checkAttachment = SubviewTextAttachment(view: checkListView!,
                                                size: CGSize(width: screenWidth,
                                                             height: height))
        setNeedsLayout()
        layoutIfNeeded()
    }

    func makeToolbar() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 35))
        let font = UIFont.systemFont(ofSize: 15)
        let addChecklistButton = UIMaker.makeButton(title: "Add checklist",
                                            titleColor: UIColor(value: 3),
                                            font: font)
        addChecklistButton.addTarget(self, action: #selector(addCheckList), for: .touchUpInside)
        view.addSubview(addChecklistButton)
        addChecklistButton.left(toView: view, space: 30)
        addChecklistButton.centerY(toView: view)


        let doneButton = UIMaker.makeButton(title: "Done",
                                titleColor: UIColor(value: 3),
                                font: font)
        doneButton.addTarget(self, action: #selector(deactivateTextView), for: .touchUpInside)
        view.addSubview(doneButton)
        doneButton.right(toView: view, space: -30)
        doneButton.centerY(toView: view)

        view.backgroundColor = UIColor(value: 235)
        return view
    }
}

protocol KComposerTextViewCheckListDelegate: class {
    func updateCheckListHeight(_ height: CGFloat)
}
