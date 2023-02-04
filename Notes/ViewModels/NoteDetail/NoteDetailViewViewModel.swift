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
        let title = NSMutableAttributedString(string: titleText)
        title.addAttribute(NSAttributedString.Key.font, value: UIFont(name: UIFont.nameOf.HelveticaNeueBold.rawValue, size: 20)!, range: NSMakeRange(0, titleText.count))
        let body = NSMutableAttributedString(string: bodyText)
        body.addAttribute(NSAttributedString.Key.font, value: UIFont(name: UIFont.nameOf.HelveticaNeue.rawValue, size: 16)!, range: NSMakeRange(0, bodyText.count))
        mutableAttributedString.append(title)
        mutableAttributedString.append(NSAttributedString(string: "\n"))
        mutableAttributedString.append(body)
        return mutableAttributedString
    }
    
    public func saveNoteText(_ noteDetailView: NoteDetailView, completion: @escaping (Result<[String],Error>) -> Void) {
        guard let text = noteDetailView.textView.text else {
            return
        }
        let components = text.split(maxSplits: 1) { $0.isNewline }
        let title = components[0]
        let body = components[1]
        completion(.success([String(describing: title), String(describing: body)]))
    }
    
}
