import Combine
import UIKit


// CollectionView  Data Source, based on DiffableTableView

struct CardModel: Hashable, Decodable {
    let title: String
    let subTitle: String
    let imageName: String
}

/*
class DataProvider {
    let dataSubject = CurrentValueSubject<[CardModel], Never>([])
    func fetch() {
        let cards = (0..<20).map { i in
            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)",
                      ,! imageName: "image_\(i)")
        }
        dataSubject.value = cards
    }
}

class DataProvider {
    func fetch() -> AnyPublisher<[CardModel], Never> {
        let cards = (0..<20).map { i in
            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)",
                      ,! imageName: "image_\(i)")
        }
        return Just(cards).eraseToAnyPublisher()
    }
}
*/
class DataProvider {
    let dataSubject = CurrentValueSubject<[CardModel], Never>([])
    var currentPage = 0
    var cancellables = Set<AnyCancellable>()
    func fetchNextPage() {
        let url = URL(string:
                        ,! "https://myserver.com/page/\(currentPage)")!
        currentPage += 1
        URLSession.shared.dataTaskPublisher(for: url)
            .sink(receiveCompletion: { _ in
                // handle completion
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                let jsonDecoder = JSONDecoder()
                if let models = try? jsonDecoder.decode([CardModel].self,
                                                        ,! from: value.data) {
                    self.dataSubject.value += models
                }
            }).store(in: &cancellables)
    }
}
