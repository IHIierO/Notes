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
    var isNewNote = false
    
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
        //print("Current model: - \(viewModel.currentModel)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print("Current model: - \(viewModel.currentModel)")
    }
    
    private func setupController() {
        view.backgroundColor = .systemBackground
        title = "Single Note"
        view.addSubview(noteDetailView)
        noteDetailView.delegate = self
        let editingButton = UIBarButtonItem(title: rightButtonTitle, style: .plain, target: self, action: #selector(isEditingTap))
        //MARK: - test split text
        // MARK: - delete
        let splitButton = UIBarButtonItem(title: "Split", style: .plain, target: self, action: #selector(splitText))
        navigationItem.rightBarButtonItems = [editingButton, splitButton]
    }
    
    // MARK: - delete
    @objc private func splitText() {
        viewModel.changeStyle(textView: noteDetailView.textView, style: .strikethroughStyle)
    }
    
    @objc private func isEditingTap() {
        textViewIsEditing.toggle()
        navigationItem.rightBarButtonItem?.title = rightButtonTitle
        noteDetailView.textView.isEditable.toggle()
        
        /// Save logic
        if isNewNote {
            print("Save new note")
            if rightButtonTitle == "Редактировать" {
                viewModel.saveNoteAttributedText(noteDetailView) { [weak self] result in
                    switch result {
                    case .success(let noteText):
                        let newNote = NoteTextModel(id: "\(Date())", titleText: noteText[0], bodyText: noteText[1], noteDate: Date())
                        UserDefaultsManager.shared.saveData(newNote)
                        self?.isNewNote = false
                    case .failure:
                        break
                    }
                }
            }
        } else {
            /// Remade logic
            if rightButtonTitle == "Редактировать" {
                print("Remade current note")
                viewModel.saveNoteAttributedText(noteDetailView) { [weak self] result in
                    guard let strongSelf = self else {
                        return
                    }
                    print("Current ID: - \(strongSelf.viewModel.currentModel.id)")
                    switch result {
                    case .success(let noteText):
                        
                        let newNote = NoteTextModel(id: strongSelf.viewModel.currentModel.id, titleText: noteText[0] , bodyText: noteText[1], noteDate: Date())
                        UserDefaultsManager.shared.deleteNote(model: newNote)
                        UserDefaultsManager.shared.saveData(newNote)
                        
                        
                        if let data = UserDefaultsManager.shared.defaults.object(forKey: strongSelf.viewModel.currentModel.id) as? Data, let currentNote = try? JSONDecoder().decode(NoteTextModel.self, from: data) {
                            print("Updated Current Note: - \(currentNote)")
                        }
                        print("Remade complite")
                    case .failure:
                        break
                    }
                }
                print("The note has been edited")
            }
        }
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

// MARK: - NoteDetailViewDelegate
extension NoteDetailViewController: NoteDetailViewDelegate {
    func presentParametersMenu(sender: UIButton) {
        viewModel.openMenuController(self, self, viewController: ChangeParametersViewController(viewModel: ChangeParametersViewViewModel()), sender: sender)
        print("Parameters menu open")
    }
    
    func presentSizeMenu(sender: UIButton) {
        viewModel.openMenuController(self, self, viewController: ChangeSizeViewController(viewModel: ChangeSizeViewViewModel()), sender: sender)
        print("Size menu open")
    }
    
    func presentFontMenu(sender: UIButton) {
        viewModel.openMenuController(self, self, viewController: ChangeFontViewController(viewModel: ChangeFontViewViewModel()), sender: sender)
        print("Text menu open")
    }
    
    
    func textViewIsEditable() {
        
    }
}

extension NoteDetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - Delegates for change: Font, Size
extension NoteDetailViewController: ChangeFontViewControllerDelegate, ChangeSizeViewControllerDelegate, ChangeParametersViewControllerDelegate {
    func didChangeTrait(_ trait: UIFontDescriptor.SymbolicTraits) {
        if trait == .traitBold {
            print("In NoteDetailViewController bold button tap: - true")
            viewModel.changeTrait(textView: noteDetailView.textView, trait: .traitBold)
        } else if trait == .traitItalic {
            print("In NoteDetailViewController italic button tap: - true")
            viewModel.changeTrait(textView: noteDetailView.textView, trait: .traitItalic)
        }
    }
    
    func didChangeStyle(_ style: NSAttributedString.Key) {
        if style == .strikethroughStyle {
            print("In NoteDetailViewController strike button tap: - true")
            viewModel.changeStyle(textView: noteDetailView.textView, style: .strikethroughStyle)
        } else if style == .underlineStyle {
            print("In NoteDetailViewController underLine button tap: - true")
            viewModel.changeStyle(textView: noteDetailView.textView, style: .underlineStyle)
        }
    }
    
    func didChangeFont(font: String) {
        print("In NoteDetailViewController font: - \(font)")
        viewModel.changeFont(textView: noteDetailView.textView, font: font)
    }
    
    func didChangeSize(size: CGFloat) {
        print("In NoteDetailViewController size: - \(size)")
        viewModel.changeSize(textView: noteDetailView.textView, size: size)
    }
}
