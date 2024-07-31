//
//  DebouncerSampleVC.swift
//  LearnCombine
//
//  Created by Basheer Ahamed S on 30/07/24.
//

import UIKit
import Combine

class DebouncerSampleVC: UIViewController, UITextFieldDelegate {

    private var cancellables = Set<AnyCancellable>()
    @Published var keyword: String?
    
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        label.text = "Loading..."
        
        let textfield = UITextField()
        textfield.placeholder = "Enter the value here..."
        textfield.delegate = self
        textfield.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        
        let stack = UIStackView(arrangedSubviews: [label, textfield])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        self.view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 200),
            stack.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        $keyword
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                guard let value else { return }
                if value.isEmpty {
                    self?.label.text = "Loading..."
                } else {
                    self?.label.text = value
                }
            })
            .store(in: &cancellables)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.label.text = "Loading..."
    }
    
    @objc
    func textFieldChange(_ sender: UITextField) {
        self.keyword = sender.text
    }
    
    var timer: Timer?
    private func timer_old() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            //
        }
    }
    
    func triggerTimer() {
        timer_old()
        timer_old()
        timer_old()
        timer_old()
        timer_old()
    }
}
