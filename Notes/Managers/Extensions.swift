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

extension NSAttributedString {
    func components(separatedBy separator: String) -> [NSAttributedString] {
        var result = [NSAttributedString]()
        let separatedStrings = string.components(separatedBy: separator)
        var range = NSRange(location: 0, length: 0)
        for string in separatedStrings {
            range.length = string.count
            let attributedString = attributedSubstring(from: range)
            result.append(attributedString)
            range.location += range.length + separator.count
        }
        return result
    }
    
    public func trimWhiteSpace() -> NSAttributedString {
           let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
           let startRange = string.utf16.description.rangeOfCharacter(from: invertedSet)
           let endRange = string.utf16.description.rangeOfCharacter(from: invertedSet, options: .backwards)
           guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
               return NSAttributedString(string: string)
           }

           let location = string.utf16.distance(from: string.startIndex, to: startLocation) - 1
           let length = string.utf16.distance(from: startLocation, to: endLocation) + 2
           let range = NSRange(location: location, length: length)
           return attributedSubstring(from: range)
       }
}


