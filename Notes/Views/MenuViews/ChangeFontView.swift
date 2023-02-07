//
//  ChangeFontView.swift
//  Notes
//
//  Created by Artem Vorobev on 05.02.2023.
//

import UIKit

protocol ChangeFontViewDelegate: AnyObject {
    func didChangeFont(font: String)
}

class ChangeFontView: UIView {
    
    private let viewModel: ChangeFontViewViewModel
    
    public weak var delegate: ChangeFontViewDelegate?
    
    private let fontPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    init(frame: CGRect, viewModel: ChangeFontViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubview(fontPicker)
        fontPicker.delegate = viewModel
        fontPicker.dataSource = viewModel
        viewModel.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            fontPicker.topAnchor.constraint(equalTo: topAnchor),
            fontPicker.leftAnchor.constraint(equalTo: leftAnchor),
            fontPicker.rightAnchor.constraint(equalTo: rightAnchor),
            fontPicker.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}


extension ChangeFontView: ChangeFontViewViewModelDelegate {
    func didChangeFont(font: String) {
        print("In ChangeFontView font: - \(font)")
        delegate?.didChangeFont(font: font)
    }
    
    
}
