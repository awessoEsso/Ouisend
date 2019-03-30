//
//  LaunchScreenViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 04/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import Lottie

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var lottieView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.loadLottieAnimation()
        
        //view.backgroundColor = UIColor(red: 52/255, green: 144/255, blue: 220/255, alpha: 1)
        view.backgroundColor = ouiSendBlueColor
    }
    
    func loadLottieAnimation() {
        let animationView = LOTAnimationView(name: "ouisendLoading")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.lottieView.addSubview(animationView)
        animationView.leftAnchor.constraint(equalTo: lottieView.leftAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: lottieView.rightAnchor).isActive = true
        animationView.topAnchor.constraint(equalTo: lottieView.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: lottieView.bottomAnchor).isActive = true
        animationView.loopAnimation = true
        animationView.animationSpeed = 1.25
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.openMainViewController()
        })
    }
    
    func openMainViewController() {
        performSegue(withIdentifier: "showMainViewSegueId", sender: self)
    }
    
    
}
