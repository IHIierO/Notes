//
//  ChangeParametersViewViewModel.swift
//  Notes
//
//  Created by Artem Vorobev on 06.02.2023.
//

import UIKit


final class ChangeParametersViewViewModel {
    
    init() {}
    
    public func createTextObliquenessButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
         button.configuration = .filled()
         var title = AttributedString.init(" I ")
         title.obliqueness = 0.3
         title.font = UIFont(name: UIFont.nameOfFont.timesNewRoman.regularFont, size: 20)
         button.setAttributedTitle(NSAttributedString(title), for: .normal)
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
    }
    
    public func createTextUnderlineButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
         button.configuration = .filled()
         var title = AttributedString.init("A")
         title.underlineStyle = .single
         button.configuration?.attributedTitle = title
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
    }
    public func createTextWeightButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
         button.configuration = .filled()
         var title = AttributedString.init("B")
         title.font = UIFont.boldSystemFont(ofSize: 20)
         button.configuration?.attributedTitle = title
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
    }
    public func createTextStrikeButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
         button.configuration = .filled()
         var title = AttributedString.init("A")
         title.strikethroughStyle = .single
         button.configuration?.attributedTitle = title
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
    }
}
