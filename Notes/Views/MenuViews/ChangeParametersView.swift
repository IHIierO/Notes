//
//  ChangeParametersView.swift
//  Notes
//
//  Created by Artem Vorobev on 06.02.2023.
//

import UIKit

protocol ChangeParametersViewDelegate: AnyObject {
    func didChangeTrait(_ trait: UIFontDescriptor.SymbolicTraits)
    func didChangeStyle(_ style: NSAttributedString.Key)
}

final class ChangeParametersView: UIView {
    
    private let viewModel: ChangeParametersViewViewModel
    
    public weak var delegate: ChangeParametersViewDelegate?
    
    private let menuContainer: UIStackView = {
       let container = UIStackView()
        container.axis = .vertical
        container.distribution = .fillEqually
        container.backgroundColor = .systemBackground
        container.spacing = 2
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let textObliqueness: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        var title = AttributedString.init(" I ")
        title.obliqueness = 0.3
        title.font = UIFont(name: UIFont.nameOfFont.timesNewRoman.regularFont, size: 20)
        button.setAttributedTitle(NSAttributedString(title), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let textUnderline: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        var title = AttributedString.init("A")
        title.underlineStyle = .single
        button.configuration?.attributedTitle = title
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let textWeight: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        var title = AttributedString.init("B")
        title.font = UIFont.boldSystemFont(ofSize: 20)
        button.configuration?.attributedTitle = title
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let textStrike: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.configuration = .filled()
        var title = AttributedString.init("A")
        title.strikethroughStyle = .single
        button.configuration?.attributedTitle = title
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var buttonTap = false
    
    // MARK: -Init
    init(frame: CGRect, viewModel: ChangeParametersViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuContainer)
        setConstraints()
        setupMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            menuContainer.topAnchor.constraint(equalTo: topAnchor),
            menuContainer.leftAnchor.constraint(equalTo: leftAnchor),
            menuContainer.rightAnchor.constraint(equalTo: rightAnchor),
            menuContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupMenu() {
        [textWeight, textObliqueness, textStrike, textUnderline].forEach({
            $0.configuration?.baseForegroundColor = .label
            $0.configuration?.baseBackgroundColor = .quaternarySystemFill
        })
        menuContainer.addArrangedSubviews(textWeight, textObliqueness, textUnderline, textStrike)
        textWeight.addTarget(self, action: #selector(changeWeight), for: .touchUpInside)
        textObliqueness.addTarget(self, action: #selector(changeObliqueness), for: .touchUpInside)
        textUnderline.addTarget(self, action: #selector(changeUnderline), for: .touchUpInside)
        textStrike.addTarget(self, action: #selector(changeStrike), for: .touchUpInside)
    }
    
    @objc private func changeWeight(sender: UIButton) {
        delegate?.didChangeTrait(.traitBold)
    }
    @objc private func changeObliqueness() {
        delegate?.didChangeTrait(.traitItalic)
    }
    @objc private func changeUnderline() {
        delegate?.didChangeStyle(.underlineStyle)
    }
    @objc private func changeStrike() {
        delegate?.didChangeStyle(.strikethroughStyle)
    }
}

