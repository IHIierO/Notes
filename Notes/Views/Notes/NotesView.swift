//
//  NotesView.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

protocol NotesViewDelegate: AnyObject {
    func notesView(
        _ notesView: NotesView,
        didSelectModel model: NoteTextModel
    )
}

final class NotesView: UIView {
    
    public weak var delegate: NotesViewDelegate?
    
    private let viewModel: NotesViewViewModel
    
    public var notesText: [String] = ["First",
                                      "Second",
                                      "Third"]
    
    private var collectionView: UICollectionView?
   
    // MARK: - Init
    init(frame: CGRect, viewModel: NotesViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubview(collectionView)
        setConstarints()
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSections(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: NotesCollectionViewCell.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        return collectionView
    }
    
    private func createSections(for sectionIndex: Int) -> NSCollectionLayoutSection {
            return viewModel.createNotesSectionLayout()
    }
    
    private func setConstarints() {
        guard let collectionView = collectionView else {
            return
        }
        NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: topAnchor),
        collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        collectionView.rightAnchor.constraint(equalTo: rightAnchor),
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Delegate
extension NotesView: NotesViewViewModelDelegate {
    func didSelectCharacter(_ model: NoteTextModel) {
        delegate?.notesView(self, didSelectModel: model)
    }
    
}
