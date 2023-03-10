//
//  DiffableSectionItem.swift
//  DiffableTableView
//
//  Created by Niraj on 04/01/2023.
//

import Foundation

enum DiffableSection {
    case main
}

struct DiffableItem: Hashable {
    let id = UUID()
    let title: Int
}

struct CardModel: Hashable, Decodable {
    let title: String
    let subTitle: String
    let imageName: String
}

