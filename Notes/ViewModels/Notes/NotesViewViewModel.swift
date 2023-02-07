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
    
    // MARK: - Init
    override init(){
        let readmeNote = ReadmeNote()
        models = [
            .init(id: "2023-02-03 13:39:57 +0000", titleText: AttributedString(readmeNote.createTitle()), bodyText: AttributedString(readmeNote.createBody()), noteDate: CustomDate.dateFromCustomString(string: "01.02.2023"))
        ]
    }
    
    public func createNotesSectionLayout() -> NSCollectionLayoutSection {
        let item = CreateSection.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), contentInsets: .init(top: 5, leading: 10, bottom: 0, trailing: 10))
        let group = CreateSection.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.1), item: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func fetchNotes() {
        UserDefaultsManager.shared.getData(models: models) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let note):
                
                if !strongSelf.models.contains(where: { model in
                    model.id == note.id
                }) {
                    self?.models.append(note)
                } else {
                    for model in strongSelf.models where model.bodyText != note.bodyText {
                        self?.models.removeAll(where: { model in
                            model.id == note.id
                        })
                        self?.models.append(note)
                    }
                }
            case .failure:
                break
            }
        }
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
        let model = models.sorted(by: {$0.noteDate > $1.noteDate})[indexPath.row]
        cell.config(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = models.sorted(by: {$0.noteDate > $1.noteDate})[indexPath.row]
        delegate?.didSelectCharacter(model)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(indexPath: indexPath, collectionView: collectionView)
    }
    
    func configureContextMenu(indexPath: IndexPath,collectionView:UICollectionView) -> UIContextMenuConfiguration{
        let note = models[indexPath.row]
        
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                UserDefaultsManager.shared.deleteNote(model: note)
                self.models.removeAll { model in
                    model.id == note.id
                }
                self.fetchNotes()
                collectionView.reloadData()
            }
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline,
                              children: [delete]);
            return menu
        }
        return context
    }
}
