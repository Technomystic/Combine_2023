import Combine
import UIKit


print("Hello World")

// • Creating publishers for your models and data.
// • Directly assigning the output of a publisher with //assign(to:on:).
// • Using Combine to drive Collection Views.
// • Assigning the output of a publisher to an //@Published property with assign(to:).
// • Creating a simple theming system with Combine.


///• Using a PassthroughSubject to send a stream of values. (Publisher that injects value in stream)
/// (which values are published and when) (events)

var cancellables = Set<AnyCancellable>()

let notificationCenter = NotificationCenter.default
let notificationName = UIResponder.keyboardWillShowNotification
let publisher = notificationCenter.publisher(for: notificationName)

publisher
    .sink(receiveValue: { notification in
        print(notification)
    })
    .store(in: &cancellables)

notificationCenter.post(Notification(name: notificationName))

// reimplement NotificationCenter.Publisher using PassthroughSubject

let notificationSubject = PassthroughSubject<Notification, Never>()

notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
    notificationSubject.send(notification)
}

notificationSubject
    .sink(receiveValue: { notification in
        print(notification)
    })
    .store(in: &cancellables)

notificationCenter.post(Notification(name: notificationName))


///• Using a CurrentValueSubject to represent a stateful stream of values.
///(Represents stateful stream of values)
/*
(If you do need to have a sense of state for a property, like when you have a model with mutable
 values, you need the second type of Subject publisher that’s provided by Combine, the
 CurrentValueSubject)
*/

// Example
class Car {
    var onBatteryChargeChanged: ((Double) -> Void)?
    var kwhInBattery = 50.0 {
        didSet {
            onBatteryChargeChanged?(kwhInBattery)
        }
    }

    let kwhPerKilometer = 0.14

    func drive(kilometer: Double) {
        let kwhNeeded = kilometer * kwhPerKilometer

        assert(kwhNeeded <= kwhInBattery, "Can't make trip, not enough charge in Battery")

        kwhInBattery -= kwhNeeded
    }
}
/*The preceding code is relatively simple, and the part that Iwant you to focus on is the didSet.
 Whenever the car’s kwhInBattery is updated, an optional closure is called. This closure
 can be set by the owner of this car model as follows:*/

let car = Car()

// someLabel.text = "The car now has \(car.kwhInBattery) kwh in its battery "
car.onBatteryChargeChanged = { newCharge in
  //  someLabel.text = "The car now has \(car.kwhInBattery) kwh in its battery "
}

// Example using Combine CurrentValueSubject

class Car_Combine {
    var kwhInBattery = CurrentValueSubject<Double, Never>(50.0)

    let kwhPerKilometer = 0.14

    func drive(kilometer: Double) {
        let kwhNeeded = kilometer * kwhPerKilometer

        assert(kwhNeeded <= kwhInBattery.value, "Can't make trip, not enough charge in Battery")

        kwhInBattery.value -= kwhNeeded
    }
}

let car_C = Car_Combine()
car_C.kwhInBattery
    .sink(receiveValue: { newCharge in
        // Update
    })

/**
 Notice that there is no explicit call to send(_:) in this example. When you change a CurrentValueSubject’s
 value property, it automatically sends this new value downstream
 to its subscribers.


 Also, note that we don’t read the
 initial value of kwhInBattery to configure the label. That’s not a mistake.
 */


///• Wrapping properties with the @Published property wrapper to turn them into publishers.
///

class Car_AtPub {
    @Published var kwhInBattery = 50.0
    let kwhPerKilometer = 0.14

    func drive(kilometer: Double) {
        let kwhNeeded = kilometer * kwhPerKilometer

        assert(kwhNeeded <= kwhInBattery, "Can't make trip, not enough charge in Battery")

        kwhInBattery -= kwhNeeded
    }
}

let car_P = Car_AtPub()

car_P.$kwhInBattery
    .sink(receiveValue: { newCharge in

    })

/*
 When you use @Published, you can access and modify the value of kwhInBattery directly.
 This is really convenient and makes the code look nice and clean. However, because
 kwhInBattery now refers to the underlying Double value, we can’t subscribe to it directly.

 To subscribe to a @Published property’s changes, you need to use a $ prefix on the property
 name. This is a special convention for property wrappers that allows you to access the
 wrapper itself, also known as a projected value rather than the value that is wrapped by the
 property. In this case, the wrapper’s projected value is a publisher, so we can subscribe to the
 $kwhInBattery property.

 The main di erence is that a @Published value will update its underlying
 value a er emitting the value to its subscribers, the CurrentValueSubject will update
 its value before emitting the value to its subscribers. The following example does a nice job of
 demonstrating this di erence:
 */

/// When to use @Published vs CurrentValueSubject

class Counter {
    @Published var publishedValue = 1
    var subjectValue = CurrentValueSubject<Int, Never>(1)
}

let counter = Counter()

counter.$publishedValue
    .sink(receiveValue: { int in
        print("Published", int == counter.publishedValue)
    })

counter.subjectValue
    .sink(receiveValue: { int in
        print("Subject", int == counter.subjectValue.value)
    })

counter.publishedValue = 2
counter.subjectValue.value = 2

// Limitation of @Published
/*
 There is also a limitation when using @Published though. You can only use this property
 wrapper on properties of classes while CurrentValueSubject is available for both structs
 and classes.

 In addition to this limitation, it’s also not possible to callsendon a@Published
 property because it’s not a Subject.

 In practice, this means that you can’t emit a completion
 event for @Published properties like you can for a Subject. Assigning a new value to the
 @Published property automatically emits this new value to subscribers which is equivalent
 to calling send(_:) with a new value.
 */
