import UIKit
import Combine

// Backpressuing

[1,2,3].publisher
    .print()
    .flatMap { int in
        return Array(repeating: int, count: 2).publisher
    }
    .sink(receiveValue: { value in
        print("You got \(value)")
    })

/**
 receive subscription: ([1, 2, 3])
 request unlimited
 receive value: (1)
 You got 1
 You got 1
 receive value: (2)
 You got 2
 You got 2
 receive value: (3)
 You got 3
 You got 3
 receive finished
 **/

[1,2,3].publisher
    .print()
    .flatMap(maxPublishers: .max(1), { int in
        return Array(repeating: int, count: 2).publisher
    })
    .sink(receiveValue: { value in
        print("You got \(value)")
    })

/**
 receive subscription: ([1, 2, 3])
 request max: (1)
 receive value: (1)
 You got 1
 You got 1
 request max: (1)
 receive value: (2)
 You got 2
 You got 2
 request max: (1)
 receive value: (3)
 You got 3
 You got 3
 request max: (1)
 receive finished
 **/
