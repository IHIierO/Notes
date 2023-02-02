//
//  NoteTextModel.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import Foundation

struct NoteTextModel: Codable {
    let id: String
    let titleText: String?
    let bodyText: String?
    let noteDate: Date
}
