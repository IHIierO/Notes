//
//  ChangeParametersViewController.swift
//  Notes
//
//  Created by Artem Vorobev on 06.02.2023.
//

import UIKit

protocol ChangeParametersViewControllerDelegate: AnyObject {
    func didChangeTrait(_ trait: UIFontDescriptor.SymbolicTraits)
    func didChangeStyle(_ style: NSAttributedString.Key)
}

final class ChangeParametersViewController: UIViewController {
    
    private let viewModel: ChangeParametersViewViewModel
    private let changeParametersView: ChangeParametersView
    
    public weak var delegate: ChangeParametersViewControllerDelegate?
    
    init(viewModel: ChangeParametersViewViewModel) {
        self.viewModel = viewModel
        self.changeParametersView = ChangeParametersView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        view.addSubview(changeParametersView)
        setConstraints()
        changeParametersView.delegate = self
       //viewModel: ChangeParametersViewModel changeParametersView.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            changeParametersView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            changeParametersView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            changeParametersView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            changeParametersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ChangeParametersViewController: ChangeParametersViewDelegate {
    func didChangeTrait(_ trait: UIFontDescriptor.SymbolicTraits) {
        delegate?.didChangeTrait(trait)
    }
    
    func didChangeStyle(_ style: NSAttributedString.Key) {
        delegate?.didChangeStyle(style)
    }
    
    
}
