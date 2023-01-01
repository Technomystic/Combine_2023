//: [Previous](@previous)

import Foundation
import Combine

/**
 This example uses tryMap to map over a publisher that emits integer values. If we encounter
 an integer that isn’t smaller than three, that’s considered an error and an error is thrown. Keep
 in mind that publishers can only complete or emit an error once. This means that a er an
 error is thrown, the publisher can’t emit new values. This is important to consider when you
 throw an error from an operator. Once the error is thrown, there is no going back.

*/

enum MyError: Error {
  case outOfBounds
}

[1,2,3].publisher
    .tryMap({ int in
        guard int < 3 else {
            throw MyError.outOfBounds
        }
        return int * 2
    })
    .sink(receiveCompletion: { completion in
        print(completion)
    }, receiveValue: { value in
        print(value)
    })

//: [Next](@next)
