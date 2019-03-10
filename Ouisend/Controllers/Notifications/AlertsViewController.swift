//
//  AlertsViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 09/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController {

    @IBOutlet weak var topicsTableView: UITableView!
    
    
    var topicJoins = [TopicJoin]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FirebaseManager.shared.myTopics({ (topicJoins) in
            print(topicJoins)
            self.topicJoins = topicJoins
            self.topicsTableView.reloadData()
        }) { (error) in
            print(error?.localizedDescription ?? "Error loading topics")
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch destination {
        case is UINavigationController:
            let navigationController = destination as! UINavigationController
            if let newAlertViewController = navigationController.viewControllers.first as? NewAlertViewController {
                newAlertViewController.delegate = self
            }
        default:
            print("Unknown segue")
        }
    }
 

}

extension AlertsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topicJoin = topicJoins[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicTableViewCellId", for: indexPath)
        cell.textLabel?.text = topicJoin.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicJoins.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indexToDelete = indexPath.row
            let identifier = topicJoins[indexPath.row].identifier
            guard let birder = Datas.shared.birder else { return }
            FirebaseManager.shared.deleteTopic(identifier: identifier, for: birder.identifier)
            self.topicJoins.remove(at: indexToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            FIRMessagingService.shared.unsubscribe(from: identifier)
        }
    }
}

extension AlertsViewController: NewAlertViewControllerDelegate {
    func didCreateTopic(_ topicJoin: TopicJoin) {
        topicJoins.append(topicJoin)
        topicsTableView.beginUpdates()
        let lastIndexPath = IndexPath(row: topicJoins.count-1, section: 0)
        topicsTableView.insertRows(at: [lastIndexPath], with: .bottom)
        topicsTableView.endUpdates()
        topicsTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
    
    
}
