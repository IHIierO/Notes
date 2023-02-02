//
//  NoteDetailView.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

protocol NoteDetailViewDelegate: AnyObject {
    func textViewIsEditable()
}

final class NoteDetailView: UIView {
    
    public weak var delegate: NoteDetailViewDelegate?
    
    private let viewModel: NoteDetailViewViewModel
    
    public let textView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .red
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let menuContainer: UIStackView = {
       let container = UIStackView()
        container.backgroundColor = .green
        container.axis = .vertical
        container.distribution = .fillEqually
        container.alignment = .fill
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
        button.configuration?.baseBackgroundColor = .green
        button.configuration?.image = UIImage(systemName: "line.3.horizontal.decrease")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let fontName: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .blue
        var title = AttributedString.init("A")
        //attText.obliqueness = 0.2 // To set the slant of the text
        title.font = UIFont(name: UIFont.nameOf.Didot.rawValue, size: 20)
        button.configuration?.attributedTitle = title
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let fontSize: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        button.configuration?.title = "Aa"
        button.configuration?.baseBackgroundColor = .purple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let fontWeight: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .systemMint
        var title = AttributedString.init("A")
        title.font = UIFont.boldSystemFont(ofSize: 20)
        button.configuration?.attributedTitle = title
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(frame: CGRect, viewModel: NoteDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(textView, menuContainer)
        menuContainer.addArrangedSubview(menuButton)
        menuButton.addTarget(self, action: #selector(menuContainerOpenTap), for: .touchUpInside)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor),
            textView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
            
            menuContainer.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            menuContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            menuContainer.widthAnchor.constraint(equalToConstant: 50),
        ])
        menuContainerOpen = menuContainer.heightAnchor.constraint(equalToConstant: 200)
        menuContainerClosed = menuContainer.heightAnchor.constraint(equalToConstant: 50)
        menuContainerClosed?.isActive = true
        menuContainerClosed?.priority = UILayoutPriority(999)
    }
    
    @objc private func menuContainerOpenTap() {
        menuIsOpen.toggle()
        if menuIsOpen {
            guard let menuContainerOpen = menuContainerOpen, let menuContainerClosed = menuContainerClosed else {return}
            menuContainerOpen.isActive = true
            menuContainerOpen.priority = UILayoutPriority(999)
            menuContainerClosed.isActive = false
            menuContainer.addArrangedSubviews(fontName, fontSize, fontWeight)
        } else {
            guard let menuContainerOpen = menuContainerOpen, let menuContainerClosed = menuContainerClosed else {return}
            menuContainerOpen.isActive = false
            menuContainerClosed.isActive = true
            menuContainerClosed.priority = UILayoutPriority(999)
            [
                fontName, fontSize, fontWeight
            ].forEach({
                $0.removeFromSuperview()
            })
        }
    }
}
