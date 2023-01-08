//
//  ExampleThreeViewController.swift
//  Combine_Day7
//
//  Created by Niraj on 08/01/2023.
//

import Combine
import UIKit

class ExampleThreeViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordAgain: UITextField!

    @Published var userNamePublisher = ""
    @Published var passwordPublisher = ""
    @Published var passwordAgainPublisher = ""

    // validate Username
    private var validUserName: AnyPublisher<String?, Never> {
        return $userNamePublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { username in
                return Future { promise in
                    self.usernameAvailable(username) { available in
                        promise(.success(available ? username : nil))
                    }
                }
            }
            .eraseToAnyPublisher()
    }

    // validate password
    private var validatePassword: AnyPublisher<String?, Never> {
        return Publishers.CombineLatest($passwordPublisher, $passwordAgainPublisher)
            .map { password, passwordRetype in
                guard password == passwordRetype && password.count >= 3 else { return nil }
                return password
            }
            .map {
                ($0 ?? "") == "passowrd1" ? nil : $0
            }
            .eraseToAnyPublisher()
    }

    // validate all constraints
    private var validateLogin: AnyPublisher<(String, String)?, Never> {
        return Publishers.CombineLatest(validUserName, validatePassword)
            .receive(on: RunLoop.main)
            .map { username, password in
                guard let usrName = username, let pwd = password else { return nil }
                return (usrName, pwd)
            }
            .eraseToAnyPublisher()
    }

    // Create Subscriber
    var createButtonSubscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

    }

    private func setup() {
        userName.delegate = self
        password.delegate = self
        passwordAgain.delegate = self

        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .primaryActionTriggered)

        createButtonSubscriber = validateLogin
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submitButton)
    }

    @objc func submitButtonTapped(_ sender: UIButton) {
        print("Button Tapped")
    }

    private func usernameAvailable(_ username: String, completion: (Bool) -> Void) {
        completion(true)
    }
}

extension ExampleThreeViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = textField.text ?? ""
        let text = (textFieldText as NSString).replacingCharacters(in: range, with: string)

        if textField == userName { userNamePublisher = text }
        if textField == password { passwordPublisher = text }
        if textField == passwordAgain { passwordAgainPublisher = text }
        return true 
    }
}
