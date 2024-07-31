//
//  NotificationCenterSampleVC.swift
//  LearnCombine
//
//  Created by Basheer Ahamed S on 29/07/24.
//

import UIKit
import Combine

extension Notification.Name {
    static let notification = Notification.Name("notification_testing")
}

class NotificationCenterSampleVC: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    private var label: UILabel = .init()

    private var publisher: AnyPublisher<String?, Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        fetchAPI()
        observe_new()
        setupview()
    }
        
    private func observer_old() {
        NotificationCenter.default.addObserver(self, selector: #selector(observe(_:)), name: .notification, object: nil)
    }
    
    @objc func observe(_ notification: Notification) { }
    
    private func remove_old() {
        NotificationCenter.default.removeObserver(self, name: .notification, object: nil)
    }
    
    private 
    func observe_new() {
        publisher = NotificationCenter.Publisher(center: .default, name: .notification)
            .compactMap({
                return ($0.object as? Repository)?.name
            }).eraseToAnyPublisher()
    }
    
    private
    func fetchAPI() {
        let url = URL(string: "https://api.github.com/repos/johnsundell/publish")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check for data
            guard let data = data else {
                print("No data received")
                return
            }

            let decoder = JSONDecoder()
            do {
                let repo = try decoder.decode(Repository.self, from: data)
                NotificationCenter.default.post(name: .notification, object: repo)
            } catch {
                print(error)
            }
        }

        // Start the data task
        task.resume()
    }
    
    private
    func setupview() {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        
        let holder = UIStackView(arrangedSubviews: [label, button])
        holder.axis = .vertical
        holder.alignment = .center
        holder.distribution = .fillProportionally
        holder.backgroundColor = .systemBackground
        self.view = holder
        label.text = "Loading..."
                
        publisher?
            .receive(on: DispatchQueue.main)
            .sink { value in button.isEnabled = value != "" }
            .store(in: &cancellables)
        
        publisher?
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
    }
    
    @objc
    private func didButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        label.text = "Loading..."

        RunLoop.current.schedule(after: .init(.now + 2)) {
            self.fetchAPI()
        }
    }
    
    deinit {
        print("Deinited \(Self.Type.self)")
    }
}


