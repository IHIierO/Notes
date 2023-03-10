//
//  CompositionalLayoutHelpers.swift
//  Notes
//
//  Created by Artem Vorobev on 02.02.2023.
//

import UIKit

enum GroupAlignment {
    case vertical
    case horizontal
}

struct CreateSection {
    
    static func createItem (width: NSCollectionLayoutDimension,
                            height: NSCollectionLayoutDimension,
                            contentInsets: NSDirectionalEdgeInsets
    ) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height))
        item.contentInsets = contentInsets
        return item
    }
    
    static func createGroup (alignment: GroupAlignment,
                             width: NSCollectionLayoutDimension,
                             height: NSCollectionLayoutDimension,
                             item: NSCollectionLayoutItem,
                             count: Int
    ) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitem: item, count: count)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitem: item, count: count)
        }
    }
    
    static func createGroup (alignment: GroupAlignment,
                             width: NSCollectionLayoutDimension,
                             height: NSCollectionLayoutDimension,
                             item: [NSCollectionLayoutItem]
    ) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: item)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: item)
        }
    }
}

