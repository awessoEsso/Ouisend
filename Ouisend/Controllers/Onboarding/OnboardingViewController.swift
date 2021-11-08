//
//  OnboardingViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 31/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var onBoardingFrames = [
        OnBoardingFrame(title: "", description: "Envoyez vos colis à bon marché partout dans le monde à travers des particuliers de confiance.", image: UIImage(named: "frame_0")!),
        OnBoardingFrame(title: "Envoyez vos colis!", description: "Préparez votre colis avec amour et soin et confiez le à un de nos voyageurs en toute sécurité.", image: UIImage(named: "frame_1")!),
        OnBoardingFrame(title: "Voyagez moins cher!", description: "Amortissez vos frais de voyage en transportant des colis pour des particuliers de confiance.", image: UIImage(named: "frame_2")!),
        OnBoardingFrame(title: "Achetez à l'étranger", description: "Vous avez besoin d'un produit indisponible dans votre localité?\n Demandez à un voyageur de vous le ramener.", image: UIImage(named: "frame_3")!),
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardingFrames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            pageControl.isHidden = true
        }
        else {
            pageControl.isHidden = false
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCellId", for: indexPath) as! OnBoardingCollectionViewCell
        
        let onBoardingFrame = onBoardingFrames[indexPath.item]
        
        cell.titleLabel.text = onBoardingFrame.title
        cell.textLabel.text = onBoardingFrame.description
        cell.imageView.image = onBoardingFrame.image
        
        if indexPath.item == 3 {
            cell.startButton.isHidden = false
        }
        else {
            cell.startButton.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}


extension OnboardingViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
}

struct OnBoardingFrame {
    var title: String
    var description: String
    var image: UIImage
    
    init(title: String, description: String,  image: UIImage) {
        self.title = title
        self.description = description
        self.image = image
    }
}
