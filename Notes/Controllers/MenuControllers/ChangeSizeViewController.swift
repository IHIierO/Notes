//
//  ChangeSizeViewController.swift
//  Notes
//
//  Created by Artem Vorobev on 05.02.2023.
//

import UIKit

protocol ChangeSizeViewControllerDelegate: AnyObject {
    func didChangeSize(size: CGFloat)
}

final class ChangeSizeViewController: UIViewController {
    
    private let viewModel: ChangeSizeViewViewModel
    private let changeSizeView: ChangeSizeView
    
    public weak var delegate: ChangeSizeViewControllerDelegate?
    
    init(viewModel: ChangeSizeViewViewModel) {
        self.viewModel = viewModel
        self.changeSizeView = ChangeSizeView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        view.addSubview(changeSizeView)
        setConstraints()
        changeSizeView.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            changeSizeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            changeSizeView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            changeSizeView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            changeSizeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ChangeSizeViewController: ChangeSizeViewDelegate {
    func didChangeSize(size: CGFloat) {
        //print("Size from slider: - \(size)")
        delegate?.didChangeSize(size: size)
    }
}
