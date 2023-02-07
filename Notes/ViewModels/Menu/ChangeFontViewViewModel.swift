//
//  ChangeFontViewViewModel.swift
//  Notes
//
//  Created by Artem Vorobev on 05.02.2023.
//

import UIKit

protocol ChangeFontViewViewModelDelegate: AnyObject {
    func didChangeFont(font: String)
}

final class ChangeFontViewViewModel: NSObject {
    
    public var fonts: [UIFont.nameOfFont] = []
    
    public weak var delegate: ChangeFontViewViewModelDelegate?
    
    // MARK: - Init
    override init() {
        fonts = UIFont.nameOfFont.allCases
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ChangeFontViewViewModel: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fonts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: fonts[row].font, size: 12)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = fonts[row].font
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let font = fonts[row].rawValue
        delegate?.didChangeFont(font: font)
    }
}
