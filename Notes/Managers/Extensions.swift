//
//  Extensions.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach({
            addArrangedSubview($0)
        })
    }
    
    func removeArrangedSubviews(_ views: UIView...) {
        views.forEach({
            removeArrangedSubview($0)
        })
    }
}

extension UIFont {
    public enum nameOfFont: String, CaseIterable {
        case didot = "Didot"
        case helveticaNeue = "HelveticaNeue"
        
        var font: String {
            switch self {
            case .didot, .helveticaNeue:
                return rawValue
            }
        }
    }
    
    public enum nameOfBoldFont: String, CaseIterable {
        case helveticaNeueBold = "HelveticaNeue-Bold"
        
        var font: String {
            switch self {
            case .helveticaNeueBold:
                return rawValue
            }
        }
    }
}


