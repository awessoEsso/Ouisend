//
//  FirebaseManager+request.swift
//  Ouisend
//
//  Created by Esso Awesso on 03/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import Firebase
import SwiftDate

extension FirebaseManager {
    
    /// Add user to the database, FIRUser used only for authentification
    ///
    /// - Parameters:
    ///   - user: the user to add to the database
    ///   - success: closure called when the user created with success
    ///   - failure: closure called when error happaned during the operation
    func createRequest(_ request: Request, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        
        let requestReference = requestsReference.childByAutoId()
        
        let newRequest = [
            "bird": request.bird,
            "departureCity": request.departureCity ,
            "departureCountry": request.departureCountry ,
            "departureDate": request.departureDate.timeIntervalSince1970 * 1000 ,
            "arrivalCity": request.arrivalCity,
            "arrivalCountry": request.arrivalCountry,
            "arrivalDate": request.arrivalDate.timeIntervalSince1970 * 1000 ,
            "weight": request.weight ,
            "details": request.details ,
            "birderId": request.birderId ,
            "birderName": request.birderName ,
            "birderProfilePicUrl": request.birderProfilePicUrl.absoluteString,
            "questerName": request.questerName ,
            "questerProfilePicUrl": request.questerProfilePicUrl.absoluteString,
            "status": request.status.rawValue,
            "createdAt": ServerValue.timestamp(),
            "creator": request.creator,
            ] as [String : Any]
        
        requestReference.setValue(newRequest) { (error, reference) in
            if (error == nil) {
                let newRequestValues = request
                newRequestValues.identifier = reference.key!
                self.createRequestJoinReference(newRequestValues, success: {
                    self.createBirdJoinReference(newRequestValues, success: {
                        success?()
                    }, failure: { (joinBirdError) in
                        failure?(joinBirdError)
                    })
                }, failure: { (joinError) in
                    failure?(joinError)
                })
            }
            else {
                failure?(error)
            }
        }
    }
    
    /// Get User by identifier
    ///
    /// - Parameter identifier: the identifier
    func request(with identifier: String, success: @escaping ((Request) -> Void), failure: ((Error?) -> Void)?) {
        requestsReference.child(identifier).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let request = Request(identifier: snapshot.key, dictionary: dictionary)
                success(request)
            } else {
                failure?(nil)
            }
        })
    }
    
    func declineRequest(with identifier: String) {
        requestsReference.child(identifier).child("status").setValue(2)
    }
    
    func acceptRequest(with identifier: String) {
        requestsReference.child(identifier).child("status").setValue(3)
    }
    
    fileprivate func createRequestJoinReference(_ request: Request , success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        if let currentUser = Auth.auth().currentUser {
            joinUsersReference.child(currentUser.uid).child("requests").child(request.identifier).setValue(ServerValue.timestamp()) { (error, reference) in
                if (error == nil) {
                    success?()
                }
                else {
                    failure?(error)
                }
            }
        }
    }
    
    fileprivate func createBirdJoinReference(_ request: Request , success: (() -> Void)?, failure: ((Error?) -> Void)?) {
            joinBirdsReference.child(request.bird).child("requests").child(request.identifier).setValue(ServerValue.timestamp()) { (error, reference) in
                if (error == nil) {
                    success?()
                }
                else {
                    failure?(error)
                }
            }
    }
    
    func myRequests(_ success: @escaping (([Request]) -> Void), failure: ((Error?) -> Void)?) {
        
        guard let currentUser = Auth.auth().currentUser else {
            let error = NSError(domain: "user not loggedIn", code: 3001, userInfo: nil)
            failure?(error)
            return
        }
        var requests = [Request]()
        let userIdentifier = currentUser.uid
        joinUsersReference.child(userIdentifier).child("requests").queryOrderedByValue().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let taskEvent = DispatchGroup()
                taskEvent.enter()
                requests.removeAll()
                let dictionary = snapshot.value as? [String: Any]
                // for each identifier we get the request noeud
                dictionary?.forEach {
                    taskEvent.enter()
                    let RequestIdentifier = $0.key
                    self.request(with: RequestIdentifier, success: { (Request) in
                        requests.append(Request)
                        taskEvent.leave()
                    }, failure: { (error) in
                        failure?(error)
                        taskEvent.leave()
                    })
                }
                taskEvent.leave()
                taskEvent.notify(queue: .main, execute: {
                    requests = requests.sorted(by: {$0.departureDate < $1.departureDate})
                    success(requests)
                })
            }
            else {
                success(requests)
            }
            
        })
    }
    
    func myRequestsObserveSingle(_ success: @escaping (([Request]) -> Void), failure: ((Error?) -> Void)?) {
        
        guard let currentUser = Auth.auth().currentUser else {
            let error = NSError(domain: "user not loggedIn", code: 3001, userInfo: nil)
            failure?(error)
            return
        }
        var requests = [Request]()
        let userIdentifier = currentUser.uid
        joinUsersReference.child(userIdentifier).child("requests").queryOrderedByValue().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let taskEvent = DispatchGroup()
                taskEvent.enter()
                requests.removeAll()
                let dictionary = snapshot.value as? [String: Any]
                // for each identifier we get the request noeud
                dictionary?.forEach {
                    taskEvent.enter()
                    let RequestIdentifier = $0.key
                    self.request(with: RequestIdentifier, success: { (Request) in
                        requests.append(Request)
                        taskEvent.leave()
                    }, failure: { (error) in
                        failure?(error)
                        taskEvent.leave()
                    })
                }
                taskEvent.leave()
                taskEvent.notify(queue: .main, execute: {
                    requests = requests.sorted(by: {$0.departureDate < $1.departureDate})
                    success(requests)
                })
            }
            else {
                success(requests)
            }

        })
    }
    
    func birdRequests(with birdIdentifier: String, success: @escaping (([Request]) -> Void), failure: ((Error?) -> Void)?) {
        
        var requests = [Request]()
        joinBirdsReference.child(birdIdentifier).child("requests").queryOrderedByValue().observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let taskBirdRequests = DispatchGroup()
                taskBirdRequests.enter()
                requests.removeAll()
                let dictionary = snapshot.value as? [String: Any]
                // for each identifier we get the request noeud
                dictionary?.forEach {
                    taskBirdRequests.enter()
                    let requestIdentifier = $0.key
                    self.request(with: requestIdentifier, success: { (request) in
                        requests.append(request)
                        taskBirdRequests.leave()
                    }, failure: { (error) in
                        failure?(error)
                        taskBirdRequests.leave()
                    })
                }
                taskBirdRequests.leave()
                taskBirdRequests.notify(queue: .main, execute: {
                    requests = requests.sorted(by: {$0.departureDate < $1.departureDate})
                    success(requests)
                })
            }
            else {
                success(requests)
            }

        })
    }
    
    func birdRequestsObserveSingle(with birdIdentifier: String, success: @escaping (([Request]) -> Void), failure: ((Error?) -> Void)?) {
        
        var requests = [Request]()
        joinBirdsReference.child(birdIdentifier).child("requests").queryOrderedByValue().observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let taskEvent = DispatchGroup()
                taskEvent.enter()
                requests.removeAll()
                let dictionary = snapshot.value as? [String: Any]
                // for each identifier we get the request noeud
                dictionary?.forEach {
                    taskEvent.enter()
                    let RequestIdentifier = $0.key
                    self.request(with: RequestIdentifier, success: { (Request) in
                        requests.append(Request)
                        taskEvent.leave()
                    }, failure: { (error) in
                        failure?(error)
                        taskEvent.leave()
                    })
                }
                taskEvent.leave()
                taskEvent.notify(queue: .main, execute: {
                    requests = requests.sorted(by: {$0.departureDate < $1.departureDate})
                    success(requests)
                })
            }
            else {
                success(requests)
            }
            
        })
    }
    
    func requests(_ success: @escaping (([Request]) -> Void), failure: ((Error?) -> Void)?) {
        requestsReference.observe(.value, with: { (snapshot) in
            var requests = [Request]()
            if snapshot.childrenCount > 0 {
                guard let dictionary = snapshot.value as? [String: Any] else {
                    let anError = NSError(domain: "error occured: can't retreive cities", code: 30001, userInfo: nil)
                    failure?(anError)
                    return
                }
                for (key, item) in dictionary {
                    if let dict = item as? [String: Any] {
                        let request = Request(identifier: key, dictionary: dict)
                        requests.append(request)
                    }
                }
                requests = requests.sorted(by: {$0.departureDate < $1.departureDate})
                success(requests)
            }
            else {
                success(requests)
            }

        })
    }
    
}
