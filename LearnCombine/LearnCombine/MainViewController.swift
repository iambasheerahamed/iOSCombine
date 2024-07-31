//
//  MainViewController.swift
//  LearnCombine
//
//  Created by Basheer Ahamed S on 29/07/24.
//

import UIKit

class MainViewController: UIViewController {
    
    var examples = [
        "Notification Center",
        "URLSession",
        "Timer",
        "Debouncer",
        "Published",
        "CombineLatest"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Combine Examples"
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        examples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LCTableCell
        cell.title.text = examples[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let controller = NotificationCenterSampleVC.init()
            self.present(controller, animated: true)
        case 1:
            let controller = URLSessionSampleVC.init()
            self.navigationController?.pushViewController(controller, animated: true)
            
        case 2:
            let vc = TimerSampleVC()
            self.navigationController?.pushViewController(vc, animated: true)
                
        case 3:
            let vc = DebouncerSampleVC()
            self.present(vc, animated: true)
                
        case 4:
            let vc = PublishedSampleVC()
            self.present(vc, animated: true)
                
        case 5:
            let vc = CombineLatestSampleVC()
            self.present(vc, animated: true)
                
        default:
            break
        }
    }
}

final class LCTableCell: UITableViewCell {
    @IBOutlet var title: UILabel!
}
