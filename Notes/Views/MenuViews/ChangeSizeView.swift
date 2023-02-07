//
//  ChangeSizeView.swift
//  Notes
//
//  Created by Artem Vorobev on 05.02.2023.
//

import UIKit

protocol ChangeSizeViewDelegate: AnyObject {
    func didChangeSize(size: CGFloat)
}

final class ChangeSizeView: UIView {
    
    private let viewModel: ChangeSizeViewViewModel
    public weak var delegate: ChangeSizeViewDelegate?
    
    private let fontSizeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 10
        slider.maximumValue = 30
        slider.thumbTintColor = .label
        slider.maximumTrackTintColor = .secondarySystemBackground
        slider.minimumTrackTintColor = .secondaryLabel
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    // MARK: - Init
    init(frame: CGRect, viewModel: ChangeSizeViewViewModel) {
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
        addSubview(fontSizeSlider)
        fontSizeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        fontSizeSlider.setValue(16, animated: true)
        fontSizeSlider.addTarget(self, action: #selector(changeSize), for: .valueChanged)
    }
    
    @objc private func changeSize(_ sender: UISlider) {
        let step: Float = 2
        let roundedValue = round(sender.value/step) * step
        sender.setValue(roundedValue, animated: false)
        delegate?.didChangeSize(size: CGFloat(sender.value))
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            fontSizeSlider.centerYAnchor.constraint(equalTo: centerYAnchor),
            fontSizeSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
            fontSizeSlider.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
        ])
    }
}
