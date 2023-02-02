//
//  NotesViewViewModel.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

//MARK: - NotesViewViewModelDelegate
protocol NotesViewViewModelDelegate: AnyObject {
    func didSelectCharacter()
}

final class NotesViewViewModel: NSObject {
    
    public weak var delegate: NotesViewViewModelDelegate?
    
    enum SectionType {
        case notes(count: Int)
    }
    
    public var sections: [SectionType] = []
    
    override init(){
        sections = [
            .notes(count: 10)
        ]
    }
    
    public func createNotesSectionLayout() -> NSCollectionLayoutSection {
        let item = CreateSection.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), contentInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10))
        let group = CreateSection.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.1), item: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - CollectionView
extension NotesViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotesCollectionViewCell.cellIdentifier, for: indexPath) as? NotesCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectCharacter()
    }
}
