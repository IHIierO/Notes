//
//  Extensions.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

// MARK: - addSubviews for UIView
extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

// MARK: - addSubviews for UIStackView
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

// MARK: - nameOfFont, nameOfBoldFont
extension UIFont {
    
    public enum nameOfFont: String, CaseIterable {
        case arial = "Arial"
        case avenir = "Avenir-Book"
        case baskerville = "Baskerville"
        case didot = "Didot"
        case georgia = "Georgia"
        case helveticaNeue = "HelveticaNeue"
        case timesNewRoman = "TimesNewRomanPS"
        
        
        var font: String {
            switch self {
            case .arial, .baskerville, .didot, .georgia, .helveticaNeue:
                return rawValue
            case .avenir:
                return "Avenir"
            case .timesNewRoman:
                return "TimesNewRoman"
            }
        }
        
        var regularFont: String {
            switch self {
            case .avenir, .baskerville, .didot, .georgia, .helveticaNeue:
                return rawValue
            case .arial:
                return rawValue + "MT"
            case .timesNewRoman:
                return rawValue + "MT"
            }
        }
        
        var boldFont: String {
            switch self {
            case .baskerville, .didot, .georgia, .helveticaNeue:
                return rawValue + "-" + "Bold"
            case .arial:
                return "Arial-BoldMT"
            case .avenir:
                return "Avenir-Black"
            case .timesNewRoman:
                return "TimesNewRomanPS-BoldMT"
            }
        }
        
        var italicFont: String {
            switch self {
            case .baskerville, .didot, .georgia, .helveticaNeue:
                return rawValue + "-" + "Italic"
            case .arial:
                return "Arial-ItalicMT"
            case .avenir:
                return "Avenir-BookOblique"
            case .timesNewRoman:
                return "TimesNewRomanPS-ItalicMT"
            }
        }
    }
    
    public enum nameOfBoldFont: String, CaseIterable {
        case bold = "Bold"
        case italic = "Italic"
        
        var font: String {
            switch self {
            case .bold:
                return "-" + rawValue
            case .italic:
                return "-" + rawValue
            }
        }
    }
}

// MARK: - components(separatedBy: ), trimWhiteSpace
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

extension UISlider {

    func setThumbValueWithLabel() -> CGPoint {
    
        let slidertTrack : CGRect = self.trackRect(forBounds: self.bounds)
        let sliderFrm : CGRect = self.thumbRect(forBounds: self.bounds, trackRect: slidertTrack, value: self.value)
        return CGPoint(x: sliderFrm.origin.x + self.frame.origin.x + 8, y: self.frame.origin.y - 20)
    }
}
