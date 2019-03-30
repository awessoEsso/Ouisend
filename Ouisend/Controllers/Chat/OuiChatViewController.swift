//
//  OuiChatViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 16/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

import UIKit
import MapKit
import MessageKit
import MessageInputBar

final class OuiChatViewController: ChatViewController {
    
    var currrentBirder: Birder!
    var destinataireId: String = "zozoId"
    var destinataireName = "Zozo"
    var destinataireUrl: URL!
    var destinataire: Birder!
    var channel = ""
    
    var isRoot = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let birder = Datas.shared.birder else { return }
        self.currrentBirder = birder
        
        channel = FirebaseManager.shared.channelForUsers(userIds: [birder.identifier, destinataireId])
        
        resetUnreadForChannel(channel)
        
        title = destinataireName
        
        loadMessages()
        
    }
    
    func  resetUnreadForChannel(_ channel: String)  {
        FirebaseManager.shared.resetUnreadForChannel(channel)
    }
    

    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        if isRoot {
            let homeActivityController = UIStoryboard.homeTabBarController()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.window?.rootViewController = nil
            appDelegate.window?.rootViewController = homeActivityController
        }
        else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func loadMessages() {
        DispatchQueue.global(qos: .userInitiated).async {
            FirebaseManager.shared.messagesByChild(of: self.channel, success: { (ouiMessage) in
                self.insertMessage(ouiMessage)
                self.messagesCollectionView.scrollToBottom()
            }, failure: { (error) in
                print(error?.localizedDescription ?? "Error loading Channel messages")
            })
        }
    }
    
    override func configureMessageInputBar() {
        super.configureMessageInputBar()
        messageInputBar.delegate = self
    }
    
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        //refreshControl.addTarget(self, action: #selector(loadMessages), for: .valueChanged)
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
    }
    
}

// MARK: - MessagesDisplayDelegate

extension OuiChatViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? ouiSendBlueColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
//        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(tail, .curved)
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let senderId = messageList[indexPath.section].sender.id
        var imageUrl:URL
        var name: String
        if (senderId == currrentBirder.identifier) {
            imageUrl = currrentBirder.photoURL!
            name = currrentBirder.displayName ?? ""
        }
        else {
            imageUrl = destinataireUrl
            name = destinataireName
        }
        
        getData(from: imageUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let avatar = Avatar(image: UIImage(data: data), initials: name)
                avatarView.set(avatar: avatar)
                avatarView.isHidden = self.isNextMessageSameSender(at: indexPath)
                avatarView.layer.borderWidth = 2
                avatarView.layer.borderColor = ouiSendBlueColor.cgColor
            }
        }
    }
    
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}

// MARK: - MessagesLayoutDelegate

extension OuiChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
    
}


extension OuiChatViewController: MessagesDataSource {
    // MARK: - MessagesDataSource
    
    func currentSender() -> Sender {
        return Sender(id: currrentBirder.identifier, displayName: currrentBirder.displayName ?? "Moi")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// MARK: - MessageInputBarDelegate

extension OuiChatViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        for component in inputBar.inputTextView.components {
            
            if let str = component as? String {
                let message = OuiMessage(text: str, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                FirebaseManager.shared.createMessage(message, to: destinataireId)
                
            } else if let img = component as? UIImage {
                let message = OuiMessage(image: img, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
            
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
}
