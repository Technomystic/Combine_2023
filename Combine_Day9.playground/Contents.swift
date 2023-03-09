import Combine
import UIKit

// Collect Operator

/*
 It is a powerful operator that allows us to receive all items at once from a publisher. It collects all received elements and emits a single array of the collection when the upstream publisher finishes.
 */

[1,2,3,4].publisher
    .collect()
    .sink { output in
        print(output)
    }
