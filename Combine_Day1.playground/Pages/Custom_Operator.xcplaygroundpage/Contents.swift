//: [Previous](@previous)

import Foundation
import Combine

var cancellable = Set<AnyCancellable>()

var baseURL = URL(string: "https://www.donnywals.com")!

["/", "/the-blog", "/speaking", "/newsletter"].publisher
    .setFailureType(to: URLError.self)
    .flatMap({ path -> URLSession.DataTaskPublisher in
        let url = baseURL?.appendingPathComponent(path)
        return URLSession.shared.dataTaskPublisher(for: url)
    })
    .sink(receiveCompletion: { completion in
        print(completion)
    }
    , receiveValue: { value in
        print(value)
    }).store(in: &cancellable)



extension Publisher where Output == String, Failure == Never {

    func toURLSessionDataTask(baseURL: URL) ->
    AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        if #available(iOS 14, *) {
            return self
                .flatMap({path -> URLSession.DataTaskPublisher in
                    let url = baseURL.appendingPathComponent(path)
                    return URLSession.shared.dataTaskPublisher(for: url)
                })
                .eraseToAnyPublisher()
        } else {
            return self
                .setFailureType(to: URLError.self)
                .flatMap({path -> URLSession.DataTaskPublisher in
                    let url = baseURL.appendingPathComponent(path)
                    return URLSession.shared.dataTaskPublisher(for: url)
                })
                .eraseToAnyPublisher()
        }
    }
}

//: [Next](@next)
