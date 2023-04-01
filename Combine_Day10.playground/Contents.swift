import UIKit

let remoteDataPublisher = Just(self.testURL!)
    .flatMap { url in
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw TestFailureCondition.invalidServerResponse
                }
                return data
            }
            .decode(type: PostmanEchoTimeStampCheckResponse.self, decoder: JSONDecoder())
            .catch {_ in
                return Just(PostmanEchoTimeStampCheckResponse(valid: false))
            }
    }
    .eraseToAnyPublisher()

