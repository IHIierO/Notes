//
//  NoteDetailViewViewModel.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit
import Photos
import PhotosUI

protocol NoteDetailViewViewModelDelegate: AnyObject {
    func didFinishPicking(_ image: UIImage)
}

final class NoteDetailViewViewModel: NSObject {
    
    private var model: NoteTextModel
    public weak var delegate: NoteDetailViewViewModelDelegate?
    
    // MARK: - Init
    init(model: NoteTextModel) {
        self.model = model
    }
    
    public var currentModel: NoteTextModel {
        return model
    }
    
    // MARK: - displayNote
    public var displayNote: NSMutableAttributedString {
        guard model.titleText != nil, model.bodyText != nil else {
            return NSMutableAttributedString(string: "")
        }
        let mutableAttributedString = NSMutableAttributedString()
        let titleText = model.titleText!
        let bodyText = model.bodyText!
        let title = NSMutableAttributedString(titleText)
        let body = NSMutableAttributedString(bodyText)
        mutableAttributedString.append(title)
        mutableAttributedString.append(NSAttributedString(string: "\n"))
        mutableAttributedString.append(body)
        return mutableAttributedString
    }
    
    // MARK: - Save Note AttributedText
    /// - Parameters:
    ///   - noteDetailView: NoteDetailView TextView
    ///   - completion: Create Title and Body
    public func saveNoteAttributedText(_ noteDetailView: NoteDetailView, completion: @escaping (Result<[AttributedString],Error>) -> Void) {
        guard let text = noteDetailView.textView.attributedText else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        let components = text.components(separatedBy: "\n")
        let title = components[0]
        let body = NSMutableAttributedString()
        for i in 1...components.count-1  {
            var bodyString = components[i]
            if bodyString.containsAttachments(in: NSRange(location: 0, length: bodyString.length)) {
                #warning("Create save logic to save attachment.image to UserDefaults")
                bodyString = NSAttributedString(string: "")
            }
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
        #warning("Add rang + location")
        let range = textView.selectedRange
         let string = NSMutableAttributedString(attributedString:
                                                    textView.attributedText)
        let attributes = [NSAttributedString.Key.font: UIFont(name: UIFont.nameOfFont(rawValue: font)!.regularFont, size: 16)!]
        string.addAttributes(attributes, range: textView.selectedRange)
        textView.attributedText = string
        textView.selectedRange = range
        #warning("Change all !")
    }
    
    // MARK: - Change size
    /// - Parameters:
    ///   - textView: NoteDetailView textView
    ///   - size: font size
    public func changeSize(textView: UITextView, size: CGFloat) {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        var fontName = ""
        string.enumerateAttribute(.font, in: range) { font, _, _ in
            if let font = font as? UIFont {
                fontName = font.fontName
                let attributes = [NSAttributedString.Key.font: UIFont(name: fontName, size: size)!]
                string.addAttributes(attributes, range: textView.selectedRange)
                textView.attributedText = string
                textView.selectedRange = range
            } else {
                fatalError("No range from textView")
            }
        }
    }
    
    // MARK: - Change Trait
    /// - Parameters:
    ///   - textView: NoteDetailView textView
    ///   - trait: choose between .traitBold, .traitItalic
    public func changeTrait(textView: UITextView, trait: UIFontDescriptor.SymbolicTraits) {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        
        string.enumerateAttribute(.font, in: range) { font, _, _ in
            if let font = font as? UIFont {
                if font.fontDescriptor.symbolicTraits.contains(trait) {
                    let components = font.fontName.split(separator: "-")
                    var regularFont = String(components[0])
                    if regularFont == "Avenir" {
                        regularFont = regularFont + "-" + "Book"
                    }
                    let attributes = [NSAttributedString.Key.font: UIFont(name: UIFont.nameOfFont(rawValue: regularFont)!.regularFont, size: font.pointSize)!]
                    string.addAttributes(attributes, range: textView.selectedRange)
                    textView.attributedText = string
                    textView.selectedRange = range
                } else {
                    var traitFont = UIFont()
                    if trait == .traitBold {
                        let components = font.fontName.split(separator: "M")
                        let regularFont = String(components[0]).split(separator: "-")
                        traitFont = UIFont(name: UIFont.nameOfFont(rawValue: String(regularFont[0]))!.boldFont, size: font.pointSize)!
                    } else if trait == .traitItalic {
                        let components = font.fontName.split(separator: "M")
                        let regularFont = String(components[0]).split(separator: "-")
                        traitFont = UIFont(name: UIFont.nameOfFont(rawValue: String(regularFont[0]))!.italicFont, size: font.pointSize)!
                    }
                    let attributes = [NSAttributedString.Key.font: traitFont]
                    string.addAttributes(attributes, range: textView.selectedRange)
                    textView.attributedText = string
                    textView.selectedRange = range
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
                string.removeAttribute(style, range: range)
                textView.attributedText = string
                textView.selectedRange = range
            } else {
                let attributes = [style: NSUnderlineStyle.single.rawValue]
                string.addAttributes(attributes, range: range)
                textView.attributedText = string
                textView.selectedRange = range
            }
        }
    }
}

// MARK: - add Image to TextView
extension NoteDetailViewViewModel: UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    public func presentPhotoActionSheet(_ rootViewController: UIViewController){
        let actionSheet = UIAlertController(title: "Add Image", message: "Choose a method", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            self?.presentCamera(rootViewController)
        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker(rootViewController)
        }))
        rootViewController.present(actionSheet, animated: true)
    }
    
    private func presentCamera(_ rootViewController: UIViewController){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        rootViewController.present(vc, animated: true)
    }
    
    private func presentPhotoPicker(_ rootViewController: UIViewController){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        rootViewController.present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didFinishPicking(image)
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else {return}
                DispatchQueue.main.async {
                    self?.delegate?.didFinishPicking(image)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
