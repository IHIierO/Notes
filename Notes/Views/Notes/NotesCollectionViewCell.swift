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
    private let noteSubTitle = DefaultUILabel(inputText: "Note body", fontSize: 16, fontWeight: .regular, alingment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(noteTitle, noteSubTitle)
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
        noteSubTitle.text = nil
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            noteTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            noteTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            noteTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            noteTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            noteSubTitle.topAnchor.constraint(equalTo: noteTitle.bottomAnchor),
            noteSubTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            noteSubTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            noteSubTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
        ])
    }
    
    func config(model: NoteTextModel){
        noteTitle.text = model.titleText
        noteSubTitle.text = model.bodyText
    }
    
}
