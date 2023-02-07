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
                return "Save"
            } else {
                return "Change"
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
    }
    
    private func setupController() {
        view.backgroundColor = .systemBackground
        view.addSubview(noteDetailView)
        noteDetailView.delegate = self
        viewModel.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightButtonTitle, style: .plain, target: self, action: #selector(isEditingTap))
    }
    
    @objc private func isEditingTap() {
        textViewIsEditing.toggle()
        navigationItem.rightBarButtonItem?.title = rightButtonTitle
        noteDetailView.textView.isEditable.toggle()
        
        /// Save logic
        if isNewNote {
            if rightButtonTitle == "Change" {
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
            /// Change logic
            if rightButtonTitle == "Change" {
                viewModel.saveNoteAttributedText(noteDetailView) { [weak self] result in
                    guard let strongSelf = self else {
                        return
                    }
                    switch result {
                    case .success(let noteText):
                        let newNote = NoteTextModel(id: strongSelf.viewModel.currentModel.id, titleText: noteText[0] , bodyText: noteText[1], noteDate: Date())
                        UserDefaultsManager.shared.deleteNote(model: newNote)
                        UserDefaultsManager.shared.saveData(newNote)
                    case .failure:
                        break
                    }
                }
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
extension NoteDetailViewController: NoteDetailViewDelegate, NoteDetailViewViewModelDelegate {
    func didFinishPicking(_ image: UIImage) {
        #warning("sent fun to view model")
        //create and NSTextAttachment and add your image to it.
        let attachment = NSTextAttachment()
        attachment.image = image
        //calculate new size.  (-20 because I want to have a litle space on the right of picture)
        let newImageWidth = (noteDetailView.textView.bounds.size.width - 20 )
        let scale = newImageWidth/image.size.width
        let newImageHeight = image.size.height * scale
        //resize this
        attachment.bounds = CGRect.init(x: 0, y: 0, width: newImageWidth, height: newImageHeight)
        //put your NSTextAttachment into and attributedString
        let attString = NSAttributedString(attachment: attachment)
        //add this attributed string to the current position.
        noteDetailView.textView.textStorage.insert(attString, at: noteDetailView.textView.selectedRange.location)
    }
    
    func presentPhotoActionSheet() {
        viewModel.presentPhotoActionSheet(self)
    }
    
    func presentParametersMenu(sender: UIButton) {
        viewModel.openMenuController(self, self, viewController: ChangeParametersViewController(viewModel: ChangeParametersViewViewModel()), sender: sender)
    }
    
    func presentSizeMenu(sender: UIButton) {
        viewModel.openMenuController(self, self, viewController: ChangeSizeViewController(viewModel: ChangeSizeViewViewModel()), sender: sender)
    }
    
    func presentFontMenu(sender: UIButton) {
        viewModel.openMenuController(self, self, viewController: ChangeFontViewController(viewModel: ChangeFontViewViewModel()), sender: sender)
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
            viewModel.changeTrait(textView: noteDetailView.textView, trait: .traitBold)
        } else if trait == .traitItalic {
            viewModel.changeTrait(textView: noteDetailView.textView, trait: .traitItalic)
        }
    }
    
    func didChangeStyle(_ style: NSAttributedString.Key) {
        if style == .strikethroughStyle {
            viewModel.changeStyle(textView: noteDetailView.textView, style: .strikethroughStyle)
        } else if style == .underlineStyle {
            viewModel.changeStyle(textView: noteDetailView.textView, style: .underlineStyle)
        }
    }
    
    func didChangeFont(font: String) {
        viewModel.changeFont(textView: noteDetailView.textView, font: font)
    }
    
    func didChangeSize(size: CGFloat) {
        viewModel.changeSize(textView: noteDetailView.textView, size: size)
    }
}
