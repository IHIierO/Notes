//
//  DefaultUIClasses.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

//MARK: - DefaultUILabel
class DefaultUILabel: UILabel {
    
    let inputText: String
    let fontSize: CGFloat
    let fontWeight: UIFont.Weight
    let alingment: NSTextAlignment
    
    init(inputText: String, fontSize: CGFloat, fontWeight: UIFont.Weight, alingment: NSTextAlignment){
        self.inputText = inputText
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.alingment = alingment
        super.init(frame: .zero)
        self.text = inputText
        self.textAlignment = alingment
        self.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
