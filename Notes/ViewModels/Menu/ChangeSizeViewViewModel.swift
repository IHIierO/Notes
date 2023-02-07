//
//  ChangeSizeViewViewModel.swift
//  Notes
//
//  Created by Artem Vorobev on 06.02.2023.
//

import UIKit

final class ChangeSizeViewViewModel {
    
    init() {}
    
    public func changeSize(_ sender: UISlider) {
        let step: Float = 2
        let roundedValue = round(sender.value/step) * step
        sender.setValue(roundedValue, animated: false)
    }
}
