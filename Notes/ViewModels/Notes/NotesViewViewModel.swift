//
//  NotesViewViewModel.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

//MARK: - NotesViewViewModelDelegate
protocol NotesViewViewModelDelegate: AnyObject {
    func didSelectCharacter(_ model: NoteTextModel)
}

final class NotesViewViewModel: NSObject {
    
    public weak var delegate: NotesViewViewModelDelegate?
   
    
    public var models: [NoteTextModel] = []
    
    override init(){
        models = [
            .init(id: "\(Date())", titleText: "New Note with long long long long long name", bodyText: "Simple text body for note", noteDate: Date()),
            .init(id: "\(Date())", titleText: "Enother Note", bodyText: "Enother text body for note", noteDate: Date()),
        ]
    }
    
    public func createNotesSectionLayout() -> NSCollectionLayoutSection {
        let item = CreateSection.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), contentInsets: .init(top: 5, leading: 10, bottom: 0, trailing: 10))
        let group = CreateSection.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.1), item: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - CollectionView
extension NotesViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotesCollectionViewCell.cellIdentifier, for: indexPath) as? NotesCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let model = models[indexPath.row]
        cell.config(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = models[indexPath.row]
        delegate?.didSelectCharacter(model)
    }
}
