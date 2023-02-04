//
//  NotesViewController.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

class NotesViewController: UIViewController, NotesViewDelegate {
    
    private var viewModel: NotesViewViewModel
    
    let notesView: NotesView
    
    // MARK: - Init
    init(viewModel: NotesViewViewModel) {
        self.viewModel = viewModel
        self.notesView = NotesView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeStyle
    override func viewWillAppear(_ animated: Bool) {
        notesView.viewModel.fetchNotes()
        notesView.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
        notesView.delegate = self
    }

    private func setupController() {
        view.backgroundColor = .systemBackground
        title = "Notes"
        view.addSubview(notesView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(openNewNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteAllNotes))
    }
    
    @objc private func deleteAllNotes() {
        UserDefaultsManager.shared.resetDefaults()
    }

    @objc private func openNewNote() {
        let viewModel = NoteDetailViewViewModel(model: NoteTextModel(id: "", titleText: nil, bodyText: nil, noteDate: Date()))
        let detailVC =  NoteDetailViewController(viewModel: viewModel)
        detailVC.textViewIsEditing = true
        detailVC.noteDetailView.textView.isEditable = true
        detailVC.isNewNote = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            notesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            notesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            notesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - NotesViewDelegate
    func notesView(_ notesView: NotesView, didSelectModel model: NoteTextModel) {
        let viewModel = NoteDetailViewViewModel(model: model)
        let detailVC =  NoteDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

