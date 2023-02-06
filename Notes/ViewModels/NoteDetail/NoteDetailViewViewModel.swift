//
//  NoteDetailViewViewModel.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

final class NoteDetailViewViewModel {
    private var model: NoteTextModel
    
    init(model: NoteTextModel) {
        self.model = model
    }
    
    public var currentModel: NoteTextModel {
        return model
    }
    
    public var displayNote: NSMutableAttributedString {
        guard model.titleText != nil, model.bodyText != nil else {
            return NSMutableAttributedString(string: "")
        }
        let mutableAttributedString = NSMutableAttributedString()
        let titleText = model.titleText!
        let bodyText = model.bodyText!
        let title = NSMutableAttributedString(titleText)
        let body = NSMutableAttributedString(bodyText)
//        let title = NSMutableAttributedString(string: titleText)
//        title.addAttribute(NSAttributedString.Key.font, value: UIFont(name: UIFont.nameOfBoldFont.helveticaNeueBold.rawValue, size: 20)!, range: NSMakeRange(0, titleText.count))
//        let body = NSMutableAttributedString(string: bodyText)
//        body.addAttribute(NSAttributedString.Key.font, value: UIFont(name: UIFont.nameOfFont.helveticaNeue.rawValue, size: 16)!, range: NSMakeRange(0, bodyText.count))
        mutableAttributedString.append(title)
        mutableAttributedString.append(NSAttributedString(string: "\n"))
        mutableAttributedString.append(body)
        return mutableAttributedString
    }
    
    // MARK: - delete
//    public func saveNoteText(_ noteDetailView: NoteDetailView, completion: @escaping (Result<[String],Error>) -> Void) {
//        guard let text = noteDetailView.textView.text else {
//            return
//        }
//        let components = text.split(maxSplits: 1) { $0.isNewline }
//        let title = components[0]
//        let body = components[1]
//        completion(.success([String(describing: title), String(describing: body)]))
//    }
    
    public func saveNoteAttributedText(_ noteDetailView: NoteDetailView, completion: @escaping (Result<[AttributedString],Error>) -> Void) {
        guard let text = noteDetailView.textView.attributedText else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        let components = text.components(separatedBy: "\n")
        let title = components[0]
        let body = NSMutableAttributedString()
        for i in 1...components.count-1  {
            let bodyString = components[i]
            body.append(bodyString)
            body.append(NSAttributedString(string: "\n"))
        }
        
        completion(.success([AttributedString(title), AttributedString(body)]))
    }
    
    // MARK: - Open menu controller
    /// - Parameters:
    ///   - sourceController: controller with menu
    ///   - delegate: popover delegate
    ///   - viewController: the right menu controller
    ///   - sender: he right menu button
    public func openMenuController(_ sourceController: UIViewController, _ delegate: UIPopoverPresentationControllerDelegate, viewController: UIViewController, sender: UIButton) {
        let viewController = viewController
        viewController.modalPresentationStyle = .popover
        viewController.navigationItem.largeTitleDisplayMode = .never
        if let vc = viewController as? ChangeFontViewController {
            vc.delegate = (sourceController as! any ChangeFontViewControllerDelegate)
            vc.preferredContentSize = CGSize(width: 150, height: 200)
        } else if let vc = viewController as? ChangeSizeViewController {
            vc.delegate = (sourceController as! any ChangeSizeViewControllerDelegate)
            vc.preferredContentSize = CGSize(width: 80, height: 200)
        } else if let vc = viewController as? ChangeParametersViewController {
            vc.delegate = (sourceController as! any ChangeParametersViewControllerDelegate)
            vc.preferredContentSize = CGSize(width: 50, height: 200)
        }
        
        if let popoverPresentationController = viewController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .right
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = sender.bounds
            popoverPresentationController.delegate = delegate
        }
            sourceController.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Change font
    /// - Parameters:
    ///   - textView: NoteDetailView textView
    ///   - font: font name
    public func changeFont(textView: UITextView, font: String) {
        let range = textView.selectedRange
         let string = NSMutableAttributedString(attributedString:
                                                    textView.attributedText)
        let attributes = [NSAttributedString.Key.font: UIFont(name: font, size: 16)!]
        string.addAttributes(attributes, range: textView.selectedRange)
        textView.attributedText = string
        textView.selectedRange = range
    }
    
    
    // MARK: - Change size
    /// - Parameters:
    ///   - textView: NoteDetailView textView
    ///   - size: font size
    public func changeSize(textView: UITextView, size: CGFloat) {
        let range = textView.selectedRange
         let string = NSMutableAttributedString(attributedString:
                                                    textView.attributedText)
        var fontName = ""
        string.enumerateAttribute(.font, in: range) { font, _, _ in
            if let font = font as? UIFont {
                fontName = font.fontName
            }
        }
        let attributes = [NSAttributedString.Key.font: UIFont(name: fontName, size: size)!]
        string.addAttributes(attributes, range: textView.selectedRange)
        textView.attributedText = string
        textView.selectedRange = range
        
    }
    
    // MARK: - Change weight
    /// - Parameters:
    ///   - textView: NoteDetailView textView
    ///   - weight: font weight
    public func changeWeight(textView: UITextView, weight: UIFont.nameOfBoldFont) {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString:
                                                textView.attributedText)
        
        var fontName = ""
        string.enumerateAttribute(.font, in: range) { font, _, _ in
            if let font = font as? UIFont {
                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    let components = font.fontName.split(separator: "-")
                    print("Components: - \(components)")
                    let regularFont = String(components[0])
                    let attributes = [NSAttributedString.Key.font: UIFont(name: regularFont, size: font.pointSize)!]
                    string.addAttributes(attributes, range: textView.selectedRange)
                    textView.attributedText = string
                    textView.selectedRange = range
                    print("Font from textView: - \(regularFont) = bold")
                } else {
                    let components = font.fontName.split(separator: "M")
                    if components.count == 1 {
                        fontName = font.fontName
                        let attributes = [NSAttributedString.Key.font: UIFont(name: fontName + weight.font, size: font.pointSize)!]
                        string.addAttributes(attributes, range: textView.selectedRange)
                        textView.attributedText = string
                        textView.selectedRange = range
                        print("Font from textView: - \(fontName)")
                    } else {
                        print("Bad font")
                        let goodFont = String(components[0])
                        let attributes = [NSAttributedString.Key.font: UIFont(name: goodFont + weight.font + "MT", size: font.pointSize)!]
                        string.addAttributes(attributes, range: textView.selectedRange)
                        textView.attributedText = string
                        textView.selectedRange = range
                        print("Font from textView: - \(goodFont + weight.font + "MT")")
                    }
                }
            }
        }
    }
    
    // MARK: - Change style
    /// - Parameters:
    ///   - textView: NoteDetailView textView
    ///   - style: choose between .strikethroughStyle, .underlineStyle
    public func changeStyle(textView: UITextView, style: NSAttributedString.Key) {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        string.enumerateAttribute(style, in: range) { currentStyle, _, _ in
            if currentStyle != nil {
                print("Strike line = \(currentStyle.debugDescription)")
                string.removeAttribute(style, range: range)
                textView.attributedText = string
                textView.selectedRange = range
            } else {
                print("No Strike line = \(currentStyle.debugDescription)")
                let attributes = [style: NSUnderlineStyle.single.rawValue]
                string.addAttributes(attributes, range: range)
                textView.attributedText = string
                textView.selectedRange = range
            }
        }
    }
}
