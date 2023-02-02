//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

class NoteDetailViewController: UIViewController{
   
    private var viewModel: NoteDetailViewViewModel
    
    public var textViewIsEditing = false
    private var rightButtonTitle: String {
        get {
            if textViewIsEditing {
                return "Сохранить"
            } else {
                return "Редактировать"
            }
        }
    }
    
    let noteDetailView: NoteDetailView
    
    // MARK: - Init
    init(viewModel: NoteDetailViewViewModel) {
        self.viewModel = viewModel
        self.noteDetailView = NoteDetailView(frame: .zero, viewModel: viewModel)
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
    }
    
    private func setupController() {
        view.backgroundColor = .systemBackground
        title = "Single Note"
        view.addSubview(noteDetailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightButtonTitle, style: .plain, target: self, action: #selector(isEditingTap))
    }
    
    @objc private func isEditingTap() {
        textViewIsEditing.toggle()
        navigationItem.rightBarButtonItem?.title = rightButtonTitle
        noteDetailView.textView.isEditable.toggle()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            noteDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteDetailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            noteDetailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            noteDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}
