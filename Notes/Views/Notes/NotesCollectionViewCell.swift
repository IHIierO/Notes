//
//  NotesCollectionViewCell.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "NotesCollectionViewCell"
    
    private let noteLabel = DefaultUILabel(inputText: "New Note", fontSize: 16, fontWeight: .regular, alingment: .natural)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(noteLabel)
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
        noteLabel.text = nil
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            noteLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            noteLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
}
