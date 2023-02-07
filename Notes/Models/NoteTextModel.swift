//
//  NoteTextModel.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

struct NoteTextModel: Codable {
    var id: String
    var titleText: AttributedString?
    var bodyText: AttributedString?
    let noteDate: Date
}


struct ReadmeNote {
    let titleString = "Readme"
    let bodyString = """

Основные возможности этого приложения:

1) Создание нескольких заметок
2) Сохранение и чтение заметок при помощи UserDefaults (Есть возможность добавить Realm, если нужно)
3) Вывод списка существующих заметок
4) Удаление заметок (Нужно нажать на заметку для отображения меню удаления)
5) Возможность редактировать любую заметку
6) Возможность выделять текст курсивом, жирным и т. п.
7) Возможность менять шрифт и размер текста
8) Возможность вставлять картинки в TextView

Что не успел сделать:

1) Сохранение и чтение картинок при помощи UserDefaults
2) Пока изменения шривта, размера и т.д. возможно только для выделенного текста
"""
    func createTitle() -> NSMutableAttributedString {
        let title = NSMutableAttributedString(string: titleString)
        let titleAttribute = [NSAttributedString.Key.font: UIFont(name: UIFont.nameOfFont.helveticaNeue.boldFont, size: 20)!]
        title.addAttributes(titleAttribute, range: NSMakeRange(0, titleString.count))
        return title
    }
    
    func createBody() -> NSMutableAttributedString {
        let body = NSMutableAttributedString(string: bodyString)
        body.addAttribute(NSAttributedString.Key.font, value: UIFont(name: UIFont.nameOfFont.helveticaNeue.regularFont, size: 16)!, range: NSMakeRange(0, bodyString.count))
        return body
    }
}
