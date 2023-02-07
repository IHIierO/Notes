//
//  NotesCollectionViewCell.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "NotesCollectionViewCell"
    
    private let noteTitle = DefaultUILabel(inputText: "Note title", fontSize: 20, fontWeight: .semibold, alingment: .left)
    private let noteBody = DefaultUILabel(inputText: "Note body", fontSize: 16, fontWeight: .regular, alingment: .left)
    private let noteDate = DefaultUILabel(inputText: "04.02.2023", fontSize: 16, fontWeight: .regular, alingment: .left)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(noteTitle, noteDate, noteBody)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        noteTitle.text = nil
        noteBody.text = nil
        noteDate.text = nil
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            noteTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            noteTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            noteTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            noteTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            noteDate.topAnchor.constraint(equalTo: noteTitle.bottomAnchor),
            noteDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            noteDate.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            noteDate.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            noteBody.topAnchor.constraint(equalTo: noteTitle.bottomAnchor),
            noteBody.leftAnchor.constraint(equalTo: noteDate.rightAnchor, constant: 4),
            noteBody.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            noteBody.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
        ])
    }
    
    func config(model: NoteTextModel){
        guard let title = model.titleText, let body = model.bodyText else {
            return
        }
        noteTitle.attributedText = NSMutableAttributedString(title)
        noteBody.attributedText = NSMutableAttributedString(body).trimWhiteSpace()
        noteDate.text = CustomDate.dateString(date: model.noteDate)
    }
}
