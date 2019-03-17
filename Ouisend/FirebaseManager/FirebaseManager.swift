//
//  FirebaseManager.swift
//  Ouisend
//
//  Created by Esso Awesso on 23/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class FirebaseManager {
    
    // MARK: Singleton
    static let shared = FirebaseManager()
    // MARK: properties
    private(set) var currentUser = Auth.auth().currentUser
    let datebaseReference: DatabaseReference
    
    // MARK: Database References
    lazy var usersReference: DatabaseReference = {
        let userRef = self.datebaseReference.child("User")
        userRef.keepSynced(true)
        return userRef
    }()
    
    lazy var birdsReference: DatabaseReference = {
        let birdRef = self.datebaseReference.child("Bird")
        birdRef.keepSynced(true)
        return birdRef
    }()
    
    lazy var citiesReference: DatabaseReference = {
        let cityRef = self.datebaseReference.child("City")
        cityRef.keepSynced(true)
        return cityRef
    }()
    
    lazy var countriesReference: DatabaseReference = {
        let countryRef = self.datebaseReference.child("Country")
        countryRef.keepSynced(true)
        return countryRef
    }()
    
    lazy var channelReference: DatabaseReference = {
        let channelRef = self.datebaseReference.child("Channel")
        channelRef.keepSynced(true)
        return channelRef
    }()
    
    lazy var joinBirdsReference: DatabaseReference = {
        let joinBirdsRef = self.datebaseReference.child("_Join/_Bird")
        joinBirdsRef.keepSynced(true)
        return joinBirdsRef
    }()
    
    lazy var joinRequestsReference: DatabaseReference = {
        let joinRequestsRef = self.datebaseReference.child("_Join/_Request")
        joinRequestsRef.keepSynced(true)
        return joinRequestsRef
    }()
    
    lazy var joinUsersReference: DatabaseReference = {
        let joinUsersRef = self.datebaseReference.child("_Join/_User")
        joinUsersRef.keepSynced(true)
        return joinUsersRef
    }()
    
    lazy var notificationReference: DatabaseReference = {
        return self.datebaseReference.child("Notification")
    }()
    
    lazy var oneToOneNotificationReference: DatabaseReference = {
        return self.notificationReference.child("to")
    }()
    
    lazy var topicNotificationReference: DatabaseReference = {
        return self.notificationReference.child("Topic")
    }()
    
    lazy var topicReference: DatabaseReference = {
        return self.datebaseReference.child("Topic")
    }()
    
    lazy var requestsReference: DatabaseReference = {
        let requestRef = self.datebaseReference.child("Request")
        requestRef.keepSynced(true)
        return requestRef
    }()
    
    lazy var tokenReference: DatabaseReference = {
        return self.datebaseReference.child("_Installation")
    }()
    

    
    // MARK: init method
    init() {
        datebaseReference = Database.database().reference()
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let newUser = user else {
                return
            }
            self.currentUser = newUser
        }
    }
    
    // MARK: Storage
    
    /// Upload image for the user and add it to profile
    /// - parameter image: the image to upload
    /// - parameter user: the user concerned
    /// - parameter progress: a block with the progress of the upload
    /// - parameter success: a block when upload succeded
    /// - parameter failure: a block when upload failure
    /// - Returns: An instance of FIRStorageUploadTask, which can be used to monitor or manage the upload
    func uploadUserProfileImage(image anImage: UIImage, for user: User,
                                progress: @escaping ((Double) -> Void) = { _ in return },
                                success: @escaping (() -> Void) = {  return }, failure: @escaping ((Error?) -> Void) = { _ in return }) -> StorageUploadTask? {
        
        
        guard let imageData = anImage.jpegData(compressionQuality: 0.8) else { return nil }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("User/\(user.uid)/\(user.uid)_profile.jpg")
        let uploadTask = spaceRef.putData(imageData, metadata: metaData) { (metadata, error) in
            // You can also access to download URL after upload.
            spaceRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                let updateProfile = user.createProfileChangeRequest()
                updateProfile.photoURL = downloadURL
                updateProfile.commitChanges(completion: { (error) in
                    success()
                    print(error ?? "error uploading image")
                })
                
            }

        }
        
        uploadTask.observe(.progress) { (snapshot) in
            progress(snapshot.progress?.fractionCompleted ?? 0)
            print(snapshot)
        }
        uploadTask.observe(.failure) { (snapshot) in
            failure(snapshot.error)
        }
        
        uploadTask.observe(.success) { (snpashot) in
        }
        uploadTask.resume()
        return uploadTask
    }
    
}
