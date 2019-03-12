//
//  Attachment.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

public extension NSTextAttachment {

    convenience init(image: UIImage, size: CGSize? = nil) {
        self.init(data: nil, ofType: nil)

        self.image = image
        if let size = size {
            self.bounds = CGRect(origin: .zero, size: size)
        }
    }

}

public extension NSAttributedString {

    func insertingAttachment(_ attachment: NSTextAttachment, at index: Int, with paragraphStyle: NSParagraphStyle? = nil) -> NSAttributedString {
        let copy = self.mutableCopy() as! NSMutableAttributedString
        copy.insertAttachment(attachment, at: index, with: paragraphStyle)

        return copy.copy() as! NSAttributedString
    }

    func addingAttributes(_ attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let copy = self.mutableCopy() as! NSMutableAttributedString
        copy.addAttributes(attributes)

        return copy.copy() as! NSAttributedString
    }

}

public extension NSMutableAttributedString {

    func insertAttachment(_ attachment: NSTextAttachment, at index: Int, with paragraphStyle: NSParagraphStyle? = nil) {
        let plainAttachmentString = NSAttributedString(attachment: attachment)

        if let paragraphStyle = paragraphStyle {
            let attachmentString = plainAttachmentString
                .addingAttributes([ .paragraphStyle : paragraphStyle ])
            let separatorString = NSAttributedString(string: .paragraphSeparator)

            // Surround the attachment string with paragraph separators, so that the paragraph style is only applied to it
            let insertion = NSMutableAttributedString()
            insertion.append(separatorString)
            insertion.append(attachmentString)
            insertion.append(separatorString)

            self.insert(insertion, at: index)
        } else {
            self.insert(plainAttachmentString, at: index)
        }
    }

    func addAttributes(_ attributes: [NSAttributedString.Key : Any]) {
        self.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
    }

}

public extension String {

    static let paragraphSeparator = "\u{2029}"

}

//
//  SubviewTextAttachment.swift
//  SubviewAttachingTextView
//
//  Created by Vlas Voloshin on 29/1/17.
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

/**
 Describes a custom text attachment object containing a view. SubviewAttachingTextViewBehavior tracks attachments of this class and automatically manages adding and removing subviews in its text view.
 */
@objc(VVSubviewTextAttachment)
open class SubviewTextAttachment: NSTextAttachment {

    @objc
    public let viewProvider: TextAttachedViewProvider

    /**
     Initialize the attachment with a view provider.
     */
    @objc
    public init(viewProvider: TextAttachedViewProvider) {
        self.viewProvider = viewProvider
        super.init(data: nil, ofType: nil)
    }

    /**
     Initialize the attachment with a view and an explicit size.
     - Warning: If an attributed string that includes the returned attachment is used in more than one text view at a time, the behavior is not defined.
     */
    @objc
    public convenience init(view: UIView, size: CGSize) {
        let provider = DirectTextAttachedViewProvider(view: view)
        self.init(viewProvider: provider)
        self.bounds = CGRect(origin: .zero, size: size)
    }

    /**
     Initialize the attachment with a view and use its current fitting size as the attachment size.
     - Note: If the view does not define a fitting size, its current bounds size is used.
     - Warning: If an attributed string that includes the returned attachment is used in more than one text view at a time, the behavior is not defined.
     */
    @objc
    public convenience init(view: UIView) {
        self.init(view: view, size: view.textAttachmentFittingSize)
    }

    // MARK: - NSTextAttachmentContainer

    open override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        return self.viewProvider.bounds(for: self, textContainer: textContainer, proposedLineFragment: lineFrag, glyphPosition: position)
    }

    // MARK: NSCoding

    public required init?(coder aDecoder: NSCoder) {
        fatalError("SubviewTextAttachment cannot be decoded.")
    }

}

// MARK: - Internal view provider

final internal class DirectTextAttachedViewProvider: TextAttachedViewProvider {

    let view: UIView

    init(view: UIView) {
        self.view = view
    }

    func instantiateView(for attachment: SubviewTextAttachment, in behavior: SubviewAttachingTextViewBehavior) -> UIView {
        return self.view
    }

    func bounds(for attachment: SubviewTextAttachment, textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint) -> CGRect {
        return attachment.bounds
    }

}

// MARK: - Extensions

private extension UIView {

    @objc(vv_attachmentFittingSize)
    var textAttachmentFittingSize: CGSize {
        let fittingSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if fittingSize.width > 1e-3 && fittingSize.height > 1e-3 {
            return fittingSize
        } else {
            return self.bounds.size
        }
    }

}

//
//  TextAttachedViewProvider.swift
//  SubviewAttachingTextView
//
//  Created by Vlas Voloshin on 25/3/17.
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

/**
 Describes a protocol that provides views inserted as subviews into text views that render a `SubviewTextAttachment`, and customizes their layout.
 - Note: Implementing this protocol is encouraged over providing a single view in a `SubviewTextAttachment`, because it allows attributed strings with subview attachments to be rendered in multiple text views at the same time: each text view would get its own subview that corresponds to the attachment.
 */
@objc(VVTextAttachedViewProvider)
public protocol TextAttachedViewProvider: class {

    /**
     Returns a view that corresponds to the specified attachment.
     - Note: Each `SubviewAttachingTextViewBehavior` caches instantiated views until the attachment leaves the text container.
     */
    @objc(instantiateViewForAttachment:inBehavior:)
    func instantiateView(for attachment: SubviewTextAttachment, in behavior: SubviewAttachingTextViewBehavior) -> UIView

    /**
     Returns the layout bounds of the view that corresponds to the specified attachment.
     - Note: Return `attachment.bounds` for default behavior. See `NSTextAttachmentContainer.attachmentBounds(for:, proposedLineFragment:, glyphPosition:, characterIndex:)` method for more details.
     */
    @objc(boundsForAttachment:textContainer:proposedLineFragment:glyphPosition:)
    func bounds(for attachment: SubviewTextAttachment, textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint) -> CGRect

}

//
//  SubviewAttachingTextViewBehavior.swift
//  SubviewAttachingTextView
//
//  Created by Vlas Voloshin on 29/1/17.
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

/**
 Component class managing a text view behaviour that tracks all text attachments of SubviewTextAttachment class, automatically inserts/removes their views as text view subviews, and updates their layout according to the text view's layout manager.
 - Note: Follow the implementation of `SubviewAttachingTextView` for an example of adopting this behavior in your custom text view subclass.
 */
@objc(VVSubviewAttachingTextViewBehavior)
open class SubviewAttachingTextViewBehavior: NSObject, NSLayoutManagerDelegate, NSTextStorageDelegate {

    @objc
    open weak var textView: UITextView? {
        willSet {
            // Remove all managed subviews from the text view being disconnected
            self.removeAttachedSubviews()
        }
        didSet {
            // Synchronize managed subviews to the new text view
            self.updateAttachedSubviews()
            self.layoutAttachedSubviews()
        }
    }

    // MARK: Subview tracking

    private let attachedViews = NSMapTable<TextAttachedViewProvider, UIView>.strongToStrongObjects()
    private var attachedProviders: Array<TextAttachedViewProvider> {
        return Array(self.attachedViews.keyEnumerator()) as! Array<TextAttachedViewProvider>
    }

    /**
     Adds attached views as subviews and removes subviews that are no longer attached. This method is called automatically when text view's text attributes change. Calling this method does not automatically perform a layout of attached subviews.
     */
    @objc
    open func updateAttachedSubviews() {
        guard let textView = self.textView else {
            return
        }

        // Collect all SubviewTextAttachment attachments
        let subviewAttachments = textView.textStorage.subviewAttachmentRanges.map { $0.attachment }

        // Remove views whose providers are no longer attached
        for provider in self.attachedProviders {
            if (subviewAttachments.contains { $0.viewProvider === provider } == false) {
                self.attachedViews.object(forKey: provider)?.removeFromSuperview()
                self.attachedViews.removeObject(forKey: provider)
            }
        }

        // Insert views that became attached
        let attachmentsToAdd = subviewAttachments.filter {
            self.attachedViews.object(forKey: $0.viewProvider) == nil
        }
        for attachment in attachmentsToAdd {
            let provider = attachment.viewProvider
            let view = provider.instantiateView(for: attachment, in: self)
            view.translatesAutoresizingMaskIntoConstraints = true
            view.autoresizingMask = [ ]

            textView.addSubview(view)
            self.attachedViews.setObject(view, forKey: provider)
        }
    }

    private func removeAttachedSubviews() {
        for provider in self.attachedProviders {
            self.attachedViews.object(forKey: provider)?.removeFromSuperview()
        }
        self.attachedViews.removeAllObjects()
    }

    // MARK: Layout

    /**
     Lays out all attached subviews according to the layout manager. This method is called automatically when layout manager finishes updating its layout.
     */
    @objc
    open func layoutAttachedSubviews() {
        guard let textView = self.textView else {
            return
        }

        let layoutManager = textView.layoutManager
        let scaleFactor = textView.window?.screen.scale ?? UIScreen.main.scale

        // For each attached subview, find its associated attachment and position it according to its text layout
        let attachmentRanges = textView.textStorage.subviewAttachmentRanges
        for (attachment, range) in attachmentRanges {
            guard let view = self.attachedViews.object(forKey: attachment.viewProvider) else {
                // A view for this provider is not attached yet??
                continue
            }
            guard view.superview === textView else {
                // Skip views which are not inside the text view for some reason
                continue
            }
            guard let attachmentRect = SubviewAttachingTextViewBehavior.boundingRect(forAttachmentCharacterAt: range.location, layoutManager: layoutManager) else {
                // Can't determine the rectangle for the attachment: just hide it
                view.isHidden = true
                continue
            }

            let convertedRect = textView.convertRectFromTextContainer(attachmentRect)
            let integralRect = CGRect(origin: convertedRect.origin.integral(withScaleFactor: scaleFactor),
                                      size: convertedRect.size)

            UIView.performWithoutAnimation {
                view.frame = integralRect
                view.isHidden = false
            }
        }
    }

    private static func boundingRect(forAttachmentCharacterAt characterIndex: Int, layoutManager: NSLayoutManager) -> CGRect? {
        let glyphRange = layoutManager.glyphRange(forCharacterRange: NSMakeRange(characterIndex, 1), actualCharacterRange: nil)
        let glyphIndex = glyphRange.location
        guard glyphIndex != NSNotFound && glyphRange.length == 1 else {
            return nil
        }

        let attachmentSize = layoutManager.attachmentSize(forGlyphAt: glyphIndex)
        guard attachmentSize.width > 0.0 && attachmentSize.height > 0.0 else {
            return nil
        }

        let lineFragmentRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: nil)
        let glyphLocation = layoutManager.location(forGlyphAt: glyphIndex)
        guard lineFragmentRect.width > 0.0 && lineFragmentRect.height > 0.0 else {
            return nil
        }

        return CGRect(origin: CGPoint(x: lineFragmentRect.minX + glyphLocation.x,
                                      y: lineFragmentRect.minY + glyphLocation.y - attachmentSize.height),
                      size: attachmentSize)
    }

    // MARK: NSLayoutManagerDelegate

    public func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        if layoutFinishedFlag {
            self.layoutAttachedSubviews()
        }
    }

    // MARK: NSTextStorageDelegate

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedAttributes) {
            self.updateAttachedSubviews()
        }
    }

}

// MARK: - Extensions

public extension UITextView {

    @objc(vv_convertPointToTextContainer:)
    func convertPointToTextContainer(_ point: CGPoint) -> CGPoint {
        let insets = self.textContainerInset
        return CGPoint(x: point.x - insets.left, y: point.y - insets.top)
    }

    @objc(vv_convertPointFromTextContainer:)
    func convertPointFromTextContainer(_ point: CGPoint) -> CGPoint {
        let insets = self.textContainerInset
        return CGPoint(x: point.x + insets.left, y: point.y + insets.top)
    }

    @objc(vv_convertRectToTextContainer:)
    func convertRectToTextContainer(_ rect: CGRect) -> CGRect {
        let insets = self.textContainerInset
        return rect.offsetBy(dx: -insets.left, dy: -insets.top)
    }

    @objc(vv_convertRectFromTextContainer:)
    func convertRectFromTextContainer(_ rect: CGRect) -> CGRect {
        let insets = self.textContainerInset
        return rect.offsetBy(dx: insets.left, dy: insets.top)
    }

}

private extension CGPoint {

    func integral(withScaleFactor scaleFactor: CGFloat) -> CGPoint {
        guard scaleFactor > 0.0 else {
            return self
        }

        return CGPoint(x: round(self.x * scaleFactor) / scaleFactor,
                       y: round(self.y * scaleFactor) / scaleFactor)
    }

}

private extension NSAttributedString {

    var subviewAttachmentRanges: [(attachment: SubviewTextAttachment, range: NSRange)] {
        var ranges = [(SubviewTextAttachment, NSRange)]()

        let fullRange = NSRange(location: 0, length: self.length)
        self.enumerateAttribute(NSAttributedString.Key.attachment, in: fullRange) { value, range, _ in
            if let attachment = value as? SubviewTextAttachment {
                ranges.append((attachment, range))
            }
        }

        return ranges
    }

}
