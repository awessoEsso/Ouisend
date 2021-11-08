//
//  DiscussionsViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 23/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class DiscussionsViewController: UIViewController {
    
    @IBOutlet weak var channelsTableView: UITableView!
    
     let searchController = UISearchController(searchResultsController: nil)
    
    var channels = [Channel]()
    var filteredChannels = [Channel]()
    
    
    var channelSelected: Channel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSearchController()

    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Rechercher"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        loadChannels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func loadChannels() {
        FirebaseManager.shared.myChannels({ (channels) in
            self.channels = channels
            self.filteredChannels = channels
            DispatchQueue.main.async {
                self.channelsTableView.reloadData()
            }
        }) { (error) in
            print(error?.localizedDescription ?? "Error getting channels")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        switch destination {
        case is OuiChatViewController:
            let destinataire = channelSelected.participant
            let ouiChatController = destination as! OuiChatViewController
            ouiChatController.destinataireId = destinataire.identifier
            ouiChatController.destinataireName = destinataire.displayName ?? ""
            ouiChatController.destinataireUrl = destinataire.photoURL!
            ouiChatController.destinataire = destinataire
        default:
            print("JE sais pas où tuy vas mec")
        }
    }
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

extension DiscussionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = filteredChannels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "discussionTableViewCellId", for: indexPath) as! DiscussionTableViewCell
        cell.participantImageView.sd_setImage(with: channel.participant.photoURL, placeholderImage: nil, completed: nil)
        cell.participantNameLabel.text = channel.participant.displayName
        if let messageKind = channel.messages.last?.kind {
            switch messageKind {
            case .text(let text), .emoji(let text):
                cell.channelLastMessageLabel.text = text
            case .attributedText(let text):
                cell.channelLastMessageLabel.attributedText = text
            default:
                break
            }
        }
        
        if channel.unreadCount > 0 {
            cell.unreadCountLabel.isHidden = false
            cell.unreadCountLabel.text = "\(channel.unreadCount)"
        }
        else {
            cell.unreadCountLabel.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
}

extension DiscussionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        channelSelected = filteredChannels[indexPath.row]
        performSegue(withIdentifier: "showChannelChatView", sender: nil)
    }
}


extension DiscussionsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text!
        if searchText.isEmpty == true {
            filteredChannels = channels
        }
        else {
            filteredChannels =  channels.filter {
                let participantName = $0.participant.displayName ?? ""
                return (participantName.contains(searchText))
            }
        }
        
        channelsTableView.reloadData()
        
    }
    
}
