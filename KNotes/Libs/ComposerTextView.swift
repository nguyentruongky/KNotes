//
//  ComposerTextView.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

// dependency injection: prevent dependency on the specific library
final class ComposerTextView: LEOTextView, KComposerTextViewCheckListDelegate {
    var checkListView: KChecklistView?
    var checkAttachment: SubviewTextAttachment?

    private var isActive = false {
        didSet { isEditable = isActive }
    }

    private let attachmentBehavior = SubviewAttachingTextViewBehavior()
    override var textContainerInset: UIEdgeInsets {
        didSet {
            attachmentBehavior.layoutAttachedSubviews()
        }
    }

    override init(normalFont: UIFont, titleFont: UIFont, boldFont: UIFont, italicFont: UIFont) {
        super.init(normalFont: normalFont, titleFont: titleFont, boldFont: boldFont, italicFont: italicFont)
        setupView()
    }

    init() { self.init(frame: .zero) }

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
        isEditable = true
        dataDetectorTypes = .all

        attachmentBehavior.textView = self
        layoutManager.delegate = attachmentBehavior
        textStorage.delegate = attachmentBehavior

        inputAccessoryView = makeToolbar()
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        isActive = true
        super.becomeFirstResponder() // require to prevent tap 2 times to focus on textView
        return true
    }

    @objc func activateTextView() {
        isActive = true
        becomeFirstResponder()
    }

    @objc func deactivateTextView() {
        resignFirstResponder()
        isActive = false
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

    override func textAttributesJSON() -> String {
        var jsonString = super.textAttributesJSON()

        if let checklist = checkListView,
            var jsonObject = jsonString.toJSON() {

            let item = checklist.toJSON()
            jsonObject["checklist"] = item

            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
                let checklistString = String(data: jsonData, encoding: .utf8)
                else { return jsonString }

            jsonString = checklistString
        }

        return jsonString
    }

    override func setAttributeTextWithJSONString(_ jsonString: String) {
        guard var jsonObject = jsonString.toJSON() else { return }

        let checklist = jsonObject["checklist"] as? [AnyObject]
        jsonObject["checklist"] = nil

        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
            let otherTexts = String(data: jsonData, encoding: .utf8) else {
                super.setAttributeTextWithJSONString(jsonString)
                return
        }
        super.setAttributeTextWithJSONString(otherTexts)
        setChecklistIfExist(checklist)
    }

}

private extension String {
    func toJSON() -> [String: Any]? {
        let data = self.data(using: .utf8)!
        guard let json = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] else { return nil }
        return json
    }
}

protocol KComposerTextViewCheckListDelegate: class {
    func updateCheckListHeight(_ height: CGFloat)
}

