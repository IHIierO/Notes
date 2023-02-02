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
    func notesView(_ notesView: NotesView) {
        let viewModel = NoteDetailViewViewModel()
        let detailVC =  NoteDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

