//
//  PublishedSampleVC.swift
//  LearnCombine
//
//  Created by Basheer Ahamed S on 30/07/24.
//

import UIKit
import Combine

class PublishedSampleVC: UIViewController {
    var cancellables: Set<AnyCancellable> = []
    
    var publisher: Any?
    @Published var isOn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        let button = UIButton(type: .system)
        button.setTitle("Value", for: .normal)
        
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
        
        let stack = UIStackView(arrangedSubviews: [button, switchView])
        stack.axis = .vertical
        stack.spacing = 10
        self.view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        $isOn
            .receive(on: DispatchQueue.main)
            .sink { value in button.setTitleColor(value ? .red: .blue, for: .normal) }
            .store(in: &cancellables)
        
        $isOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: button)
            .store(in: &cancellables)
    }
    
    @objc
    func didSwitch(_ sender: UISwitch) {
        self.isOn = sender.isOn
    }
}

/*
 
 Just
 Future
 
 PassthroughSubject
 CurrentValueSubject
 
 CombineLatest
 CombineLatest3
 
 throttle
 
 */
