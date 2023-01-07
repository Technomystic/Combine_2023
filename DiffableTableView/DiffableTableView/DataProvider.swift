//
//  DataProvider.swift
//  DiffableTableView
//
//  Created by Niraj on 06/01/2023.
//

import Combine

class DataProvider {
    let dataSubject = CurrentValueSubject<[CardModel], Never>([])

    func fetch() {
        let cards = (0..<29).map { i in
            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)", imageName: "Name \(i)")
        }
        dataSubject.value = cards
    }
}

class DataProvider2 {

    func fetch() -> AnyPublisher<[CardModel], Never> {
        let cards = (0..<29).map { i in
            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)", imageName: "Name \(i)")
        }
        return Just(cards).eraseToAnyPublisher()
    }
}
