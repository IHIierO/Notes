//
//  NoteTextModel.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import Foundation

struct NoteTextModel: Codable {
    var id: String
    var titleText: String?
    var bodyText: String?
    let noteDate: Date
}
