//
//  URLSessionSampleVC.swift
//  LearnCombine
//
//  Created by Basheer Ahamed S on 29/07/24.
//

import UIKit
import Combine

class URLSessionSampleVC: UIViewController {

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        self.fetchAPI_publisher()
        setupview()
    }
    
    private
    func fetchAPI_publisher() {
        let url = URL(string: "https://api.github.com/repos/johnsundell/publish")!
        
        //approach 1
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Finished", Thread.isMainThread)
                    case .failure(let error):
                        print("Error:", error)
                }
            } receiveValue: {[weak self] value in
                let decoder = JSONDecoder()
                do {
                    let repo = try decoder.decode(Repository.self, from: value.data)
                    self?.label.text = repo.name
                    print(repo)
                } catch {
                    print(error)
                }
            }
            .store(in: &cancellables)
        
        return
        //approach 2
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // Extract the data from the response
            .decode(type: Repository.self, decoder: JSONDecoder()) // Decode the data into a JSON object
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        print("Finished", Thread.isMainThread)
                    case .failure(let error):
                        print("Error:", error)
                }
            }, receiveValue: { [weak self] value in
                self?.label.text = value.name
                print("Received value:", Thread.isMainThread, value)
            })
            .store(in: &cancellables)
    }
    
    private var label: UILabel = .init()
    private
    func setupview() {
        let holder = UIStackView(arrangedSubviews: [label])
        holder.axis = .vertical
        holder.alignment = .center
        holder.backgroundColor = .systemBackground
        self.view = holder
        label.text = "Loading..."        
    }
}

struct Repository: Codable {
    var name: String
    var url: URL
}
