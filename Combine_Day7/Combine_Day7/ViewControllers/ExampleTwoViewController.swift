//
//  ExampleTwoViewController.swift
//  Combine_Day7
//
//  Created by Niraj on 08/01/2023.
//

import Combine
import UIKit

class ExampleTwoViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var privacyPolicySwitch: UISwitch!
    @IBOutlet weak var termsConditionSwitch: UISwitch!

    @Published var acceptTermsCondition: Bool = false
    @Published var acceptPrivacyPolicy: Bool = false
    @Published var name: String = ""

    // Publisher for combining all elements
    private var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3($acceptTermsCondition, $acceptPrivacyPolicy, $name)
            .map { terms, privacy, name in
                return terms && privacy && !name.isEmpty
            }
            .eraseToAnyPublisher()
    }

    private var buttonSubscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self

        // Hook Subscriber to Publisher
        buttonSubscriber = validToSubmit
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submitButton)
    }

    @IBAction func termsConditionSwitch(_ sender: UISwitch) {
        acceptTermsCondition = sender.isOn
    }

    @IBAction func privacyPolicySwitch(_ sender: UISwitch) {
        acceptPrivacyPolicy = sender.isOn
    }

    @IBAction func nameChanged(_ sender: UITextField) {
        name = sender.text ?? ""
    }
}

extension ExampleTwoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
