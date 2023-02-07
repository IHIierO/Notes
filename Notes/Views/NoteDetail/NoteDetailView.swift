//
//  NoteDetailView.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

protocol NoteDetailViewDelegate: AnyObject {
    func presentFontMenu(sender: UIButton)
    func presentSizeMenu(sender: UIButton)
    func presentParametersMenu(sender: UIButton)
    func presentPhotoActionSheet()
}

final class NoteDetailView: UIView {
    
    public weak var delegate: NoteDetailViewDelegate?
    private let viewModel: NoteDetailViewViewModel
    
    public let textView: UITextView = {
       let textView = UITextView()
        textView.isEditable = false
        let attributesBold = [NSAttributedString.Key.font: UIFont(name: UIFont.nameOfFont.helveticaNeue.boldFont, size: 20)!]
        textView.attributedText = NSAttributedString(string: "")
        textView.typingAttributes = attributesBold
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let menuContainer: UIStackView = {
       let container = UIStackView()
        container.backgroundColor = .tertiarySystemBackground
        container.axis = .vertical
        container.distribution = .fillEqually
        container.spacing = 2
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    private var menuIsOpen = false
    private var menuContainerOpen: NSLayoutConstraint?
    private var menuContainerClosed: NSLayoutConstraint?
    
    private let menuButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .quaternarySystemFill
        button.configuration?.baseForegroundColor = .label
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.setImage(UIImage(systemName: "line.3.horizontal"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let fontName: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        var title = AttributedString.init("A")
        title.font = UIFont(name: UIFont.nameOfFont.didot.regularFont, size: 20)
        button.configuration?.attributedTitle = title
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let fontSize: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        button.configuration?.title = "Aa"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let fontParameters: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        var title = AttributedString.init("A")
        title.font = UIFont.boldSystemFont(ofSize: 20)
        button.configuration?.attributedTitle = title
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addImage: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        button.configuration?.image = UIImage(systemName: "plus")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(frame: CGRect, viewModel: NoteDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        textView.attributedText = viewModel.displayNote
        setupView()
        setConstraints()
        setupMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .tertiarySystemBackground
        textView.textColor = .label
        addSubviews(textView, menuContainer, addImage)
        menuContainer.addArrangedSubview(menuButton)
        menuButton.addTarget(self, action: #selector(menuContainerOpenTap), for: .touchUpInside)
        textView.delegate = self
    }
    
    // MARK: - setupMenu
    private func setupMenu() {
        [fontName, fontSize, fontParameters].forEach({
            $0.configuration?.baseForegroundColor = .label
            $0.configuration?.baseBackgroundColor = .quaternarySystemFill
        })
        fontName.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        fontSize.addTarget(self, action: #selector(changeSize), for: .touchUpInside)
        fontParameters.addTarget(self, action: #selector(changeParameters), for: .touchUpInside)
        addImage.addTarget(self, action: #selector(addImageToTextView), for: .touchUpInside)
    }
    
    @objc private func changeFont(sender: UIButton) {
        delegate?.presentFontMenu(sender: sender)
    }
    
    @objc private func changeSize(sender: UIButton) {
        delegate?.presentSizeMenu(sender: sender)
    }
    
    @objc private func changeParameters(sender: UIButton) {
        delegate?.presentParametersMenu(sender: sender)
    }
    
    @objc private func addImageToTextView() {
        delegate?.presentPhotoActionSheet()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor),
            textView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
            
            menuContainer.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            menuContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            menuContainer.widthAnchor.constraint(equalToConstant: 50),
            
            addImage.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -10),
            addImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
        menuContainerOpen = menuContainer.heightAnchor.constraint(equalToConstant: 200)
        menuContainerClosed = menuContainer.heightAnchor.constraint(equalToConstant: 50)
        menuContainerClosed?.isActive = true
        menuContainerClosed?.priority = UILayoutPriority(999)
    }
    
    @objc private func menuContainerOpenTap() {
        menuIsOpen.toggle()
        if menuIsOpen {
            menuButton.isSelected = true
            guard let menuContainerOpen = menuContainerOpen, let menuContainerClosed = menuContainerClosed else {return}
            menuContainerOpen.isActive = true
            menuContainerOpen.priority = UILayoutPriority(999)
            menuContainerClosed.isActive = false
            menuContainer.addArrangedSubviews(fontName, fontSize, fontParameters)
        } else {
            menuButton.isSelected = false
            guard let menuContainerOpen = menuContainerOpen, let menuContainerClosed = menuContainerClosed else {return}
            menuContainerOpen.isActive = false
            menuContainerClosed.isActive = true
            menuContainerClosed.priority = UILayoutPriority(999)
            [
                fontName, fontSize, fontParameters
            ].forEach({
                $0.removeFromSuperview()
            })
        }
    }
}

// MARK: - UITextViewDelegate
extension NoteDetailView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.last, character.isNewline {
            let attributesNormal = [NSAttributedString.Key.font : UIFont(name: UIFont.nameOfFont.helveticaNeue.regularFont, size: 16)!,
                                    NSAttributedString.Key.foregroundColor: UIColor.label]
            textView.typingAttributes = attributesNormal
        }
        return true
    }
}
