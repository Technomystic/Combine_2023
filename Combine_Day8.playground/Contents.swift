import Combine
import UIKit


// Map
let intPublisher = [1,2,3,4].publisher

intPublisher
    .map { " Stringed \($0)" }
    .sink { value in
        print(value)
    }

// Compact Map
let optionalPublisher = [1,2,nil, 3, nil, 4, nil, 5].publisher
    .compactMap { $0 }
    .sink { value in
       // print(value)
    }

// Flat Map
// Converts Object into another Publisher

[1,2,3].publisher.flatMap { value in
    return (0..<value).publisher
}
.sink { value in
    //print("Value \(value)")
}


struct User {
    let name: CurrentValueSubject<String, Never>
}

let userSubject = PassthroughSubject<User, Never>()

userSubject
    .map { $0.name }
    .switchToLatest()
    .sink { print($0) }

let user = User(name: .init("Niraj"))
userSubject.send(user)
user.name.send("Joshi")

let anotherUser = User(name: .init("Siddhi"))
userSubject.send(anotherUser)
anotherUser.name.send("Joshi")
