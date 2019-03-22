//
//  PresenterController.swift
//  Soundchat
//
//  Created by Hamza Ghazouani on 19/12/2017.
//  Copyright © 2017 Onmobile. All rights reserved.
//

import UIKit

/// Helps to present controller at any time and from every controller
open class  PresenterController {
    
    // MARK: - private properties
    
    /**
     * The duration of the dismiss animation
     */
    fileprivate let animationDuration = 0.5
    
    private var sourceRootViewController: UIViewController?
    private weak var controllerToPresent: UIViewController?
    
    /**
     * The main window of the application
     */
    private unowned var window: UIWindow
    
    // MARK: init methods
    
    static let shared = PresenterController()
    
    private init?() {
        guard let window = UIApplication.shared.windows.first else { return nil }
        self.window = window
    }
    
    required public init(with window: UIWindow) {
        self.window = window
    }
    
    // MARK: Hide and show management methods
    open func show(controller: UIViewController, animated: Bool) {
        controllerToPresent = controller
        sourceRootViewController = window.rootViewController
        window.rootViewController = controller
    }
    
    /**
     * Hide current controller by restoring the rootViewController of the window, to the initial root view controller (saved in sourceRootViewController property show above)
     * The duration of animation is static = 0.5, show animationDuration property
     */
    @objc open func hideIfPresented(controller: UIViewController, animed: Bool = true) {
        if controller != controllerToPresent { return }
        // the snapshot of the splash view, used to play animation
        let snapshot = window.snapshotView(afterScreenUpdates: true)
        
        // change the current root view controller with the initial rootViewController
        // (the current view controller is the splashScreenViewController)
        window.rootViewController = sourceRootViewController
        
        if animed == false { return }
        
        // adding the splash screen snapshot to the initial root view controller
        window.rootViewController?.view.addSubview(snapshot!)
        
        UIView.animate(withDuration: animationDuration, animations: {
            snapshot?.layer.opacity = 0
            snapshot?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: { (finished) in
            snapshot?.removeFromSuperview()
        })
    }
}
