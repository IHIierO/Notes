//
//  ChangeFontViewController.swift
//  Notes
//
//  Created by Artem Vorobev on 05.02.2023.
//

import UIKit

protocol ChangeFontViewControllerDelegate: AnyObject {
    func didChangeFont(font: String)
}

final class ChangeFontViewController: UIViewController {
    
    private let viewModel: ChangeFontViewViewModel
    private let changeFontView: ChangeFontView
    
    public weak var delegate: ChangeFontViewControllerDelegate?
    
    init(viewModel: ChangeFontViewViewModel) {
        self.viewModel = viewModel
        self.changeFontView = ChangeFontView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(changeFontView)
        setConstraints()
        changeFontView.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            changeFontView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            changeFontView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            changeFontView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            changeFontView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ChangeFontViewController: ChangeFontViewDelegate {
    func didChangeFont(font: String) {
        print("In ChangeFontViewController font: - \(font)")
        delegate?.didChangeFont(font: font)
    }
}
