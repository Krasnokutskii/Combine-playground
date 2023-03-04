//
//  LoginViewController.swift
//  CombineInUIkitMVVM
//
//  Created by Yaroslav Krasnokutskiy on 4.3.23..
//

import UIKit
import Combine

class LoginViewController: UIViewController {

    @IBOutlet var topTitle: UILabel!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextFiled: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    
    private let login = "Hello World"
    private let password = "12345"
    
    private var viewModel = LoginViewModel()
    private var cancellable: Set<AnyCancellable> = []
    
    var timerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.$name
            .sink { [weak self] name in
                self?.topTitle.text = name
            }
            .store(in: &cancellable)
        
        viewModel.$timerCount
            .sink { [weak self] timerCount in
                self?.timerLabel.text = "\(timerCount)"
            }
            .store(in: &cancellable)
        viewModel.startTimer()
        setupTextField()
    }

    private func setupTextField(){
        usernameTextFiled.textPublisher
            .combineLatest(passwordTextField.textPublisher)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { [weak self] username, password in
                return username == self?.login && self?.password == password
            }
            .sink(receiveValue: { [weak self] isValid in
                self?.topTitle.textColor = isValid ? .green : .red
                self?.loginButton.isEnabled = isValid
                self?.viewModel.setNewName(name: isValid ? "valid": "invalid")
            })
            .store(in: &cancellable)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        viewModel.setNewName(name: "Welcome")
        
    }
    
}

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }

}
