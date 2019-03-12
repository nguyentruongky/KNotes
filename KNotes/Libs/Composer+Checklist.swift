//
//  Composer+Checklist.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension ComposerTextView {
    @objc func addCheckList() {
        checkListView = KChecklistView(frame: CGRect(x: 0, y: 0,
                                                     width: screenWidth,
                                                     height: KChecklistView.listHeight))
        checkListView?.delegate = self

        let leftPara = NSMutableParagraphStyle()
        leftPara.alignment = .left
        leftPara.paragraphSpacing = 4
        leftPara.paragraphSpacingBefore = 4

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

    func setChecklistIfExist(_ checklist: [AnyObject]?) {
        guard let checklistRaw = checklist else { return }
        let items = checklistRaw.map({ return KCheckItem(rawData: $0) })
        addCheckList()
        checkListView?.datasource = items
    }
}
