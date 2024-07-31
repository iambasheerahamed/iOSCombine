//
//  CombineLatestSampleVC.swift
//  LearnCombine
//
//  Created by Basheer Ahamed S on 31/07/24.
//

import UIKit
import Combine

class CombineLatestSampleVC: UIViewController {
    
    var acceptedSwitch: UISwitch!
    var privacySwitch: UISwitch!
    var nameField: UITextField!
    var submitButton: UIButton!
    
    // Define publishers
    @Published private var acceptedTerms = false
    @Published private var acceptedPrivacy = false
    @Published private var name = ""
    
    // Define subscriber
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        nameField = UITextField()
        nameField.placeholder = "Enter the name..."
        nameField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        
        submitButton = UIButton(type: .system)
        submitButton.setTitle("Value", for: .normal)
        
        acceptedSwitch = UISwitch()
        acceptedSwitch.addTarget(self, action: #selector(acceptTerms), for: .valueChanged)

        privacySwitch = UISwitch()
        privacySwitch.addTarget(self, action: #selector(acceptPrivacy), for: .valueChanged)

        let stack = UIStackView(arrangedSubviews: [acceptedSwitch, privacySwitch, nameField, submitButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .fillEqually
        self.view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stack.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        
        nameField.delegate = self
        
        // Hook subscriber up to publisher
        cancellable = validToSubmit
            .assign(to: \.isEnabled, on: submitButton)
    }
    
    @objc
    func acceptTerms(_ sender: UISwitch) {
        acceptedTerms = sender.isOn
    }
    
    @objc
    func acceptPrivacy(_ sender: UISwitch) {
        acceptedPrivacy = sender.isOn
    }
    
    @objc
    func nameChanged(_ sender: UITextField) {
        name = sender.text ?? ""
    }
    
    // Combine publishers into single stream
    private var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3($acceptedTerms, $acceptedPrivacy, $name)
            .map { terms, privacy, name in
                return terms && privacy && !name.isEmpty
            }.eraseToAnyPublisher()
    }
}

extension CombineLatestSampleVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

/*
 AnyPublisher -> erasetoanypublisher
 
 notification type first
 apro map mathurathu
 
 assign
 
 autoconnect, makeconnectable, connect
 
 */
