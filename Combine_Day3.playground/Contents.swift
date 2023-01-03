import Combine
import UIKit


// Assign To using Mvvm

/// Model
class Car {
    @Published var kwhInBattery = 50.0
    let kwhPerKilometer = 0.14
}

struct CarViewModel {
    var car: Car

    lazy var batterySubject: AnyPublisher<String?, Never> = {
        return car.$kwhInBattery.map({ newCharge in
            return "The car now has \(newCharge)kwh in its battery"
        }).eraseToAnyPublisher()
    }()

    func drive(kilometer: Double) {
        let kwhNeeded = kilometer * car.kwhPerKilometer
        assert(kwhNeeded <= car.kwhInBattery, "Can't make trip, not
               ,! enough charge in battery")
               car.kwhInBattery -= kwhNeeded
    }


}

class CarStatusViewController {
let label = UILabel()
let button = UIButton()
var viewModel: CarViewModel
var cancellables = Set<AnyCancellable>()
init(viewModel: CarViewModel) {
self.viewModel = viewModel
}
// setup code goes here
func setupLabel() {
    viewModel.batterySubject
        .assign(to: \.text, on: label)
        .store(in: &cancellables)
}

func buttonTapped() {
    viewModel.drive(kilometers: 10)
}
}
