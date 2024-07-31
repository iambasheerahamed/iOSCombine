//
//  TimerSampleVC.swift
//  LearnCombine
//
//  Created by Basheer Ahamed S on 29/07/24.
//

import UIKit
import Combine

class TimerSampleVC: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    private var label: UILabel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        label.text = dateFormatter.string(from: Date())

        let holder = UIStackView(arrangedSubviews: [label])
        holder.axis = .vertical
        holder.alignment = .center
        holder.backgroundColor = .systemBackground
        self.view = holder

        self.timerPublisher()
//        self.timerPublisher_withcancel()
//        self.timerPublisher_manual()
    }

    private
    func basicArrayPublisher() {
        [1, 2, 3]
                .publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Something went wrong: \(error)")
                    case .finished:
                        print("Received Completion")
                    }
                }, receiveValue: { value in
                    print("Received value \(value)")
                })
                .store(in: &cancellables)
    }
    
    private
    func timerPublisher() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { output in
                print("finished stream with : \(output)")
            } receiveValue: { [weak self] value in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                self?.label.text = dateFormatter.string(from: value)
                
                print("current common: \(value)", Thread.isMainThread)
            }
            .store(in: &cancellables)
    }
    
    private
    func timerPublisher_withcancel() {
        let publisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { output in
                print("finished stream with : \(output)")
            } receiveValue: { [weak self] value in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                self?.label.text = dateFormatter.string(from: value)
                
                print("receive value: \(value)")
            }
        
        RunLoop.main.schedule(after: .init(.now + 2)) {
            publisher.cancel()
        }
    }
    
    private func timerPublisher_manual() {
        let publisher = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common)
            .autoconnect()
            .makeConnectable()
        
        publisher.sink { [weak self] value in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            self?.label.text = dateFormatter.string(from: value)
            
            print("current common: \(value)", Thread.isMainThread)

        }
        .store(in: &cancellables)
        
        let cancel: Cancellable? = publisher.connect()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            cancel?.cancel()
        }
    }
    
    deinit {
        print("deinited")
    }
}

/*
 Use Timer.publisher if you are already using Combine or planning to implement reactive programming patterns. It is ideal for scenarios where you need to handle time-based events as part of a larger data flow.

 Use Timer (NSTimer) for simpler or legacy applications where reactive programming is not required, or when working in environments where Combine is not available.
 */


/*
 RunLoop.Mode ->
 
 .default: The default mode used for standard operations. It’s appropriate for most general-purpose timers.
 .common: A special mode that includes multiple common modes. Timers scheduled in this mode continue to fire even when the run loop is processing events in other modes, such as during scrolls or other user interactions.
 .eventTracking: Used specifically for tracking events like user interactions. It ensures that the run loop processes event tracking operations even if other tasks are running.
 .modal: Used during modal presentations to ensure that modal events are processed correctly.
 
 */
