//
//  CustomDate.swift
//  Notes
//
//  Created by Artem Vorobev on 04.02.2023.
//

import UIKit

class CustomDate {
    static func dateString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func dateFromCustomString(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: string)!
    }
    
}
