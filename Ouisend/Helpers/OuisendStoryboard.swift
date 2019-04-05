//
//  OuisendStoryboard.swift
//  Ouisend
//
//  Created by Esso Awesso on 23/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {
    /// The uniform place where we state all the storyboard we have in our application
    enum Storyboard: String {
        case main
        case login
        case chat
        case onBoarding
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    // MARK: - Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - Class Functions
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - View Controller Instantiation from Generics
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return viewController
    }
    
    // MARK: MAIN View Controllers
    
    
    
    static func homeNavigationController() -> UINavigationController {
        let homeStoryboard = UIStoryboard(storyboard: .main)
        guard let navigationController: UINavigationController = homeStoryboard.instantiateInitialViewController() as? UINavigationController else { return UINavigationController() }
        return navigationController
    }
    
    static func homeTabBarController() -> UITabBarController {
        let homeStoryboard = UIStoryboard(storyboard: .main)
        guard let tabBarController: UITabBarController = homeStoryboard.instantiateInitialViewController() as? UITabBarController else { return UITabBarController() }
        return tabBarController
    }
    
    static func loginViewController() -> LoginViewController {
        let loginStoryboard = UIStoryboard(storyboard: .login)
        let loginViewController: LoginViewController = loginStoryboard.instantiateViewController()
        return loginViewController
    }
    
    
    static func ouiChatViewController() -> OuiChatViewController {
        let mainStoryboard = UIStoryboard(storyboard: .main)
        let ouiChatViewController: OuiChatViewController = mainStoryboard.instantiateViewController()
        return ouiChatViewController
    }
    
    static func chatViewController() -> UIViewController {
        let chatStoryboard = UIStoryboard(storyboard: .chat)
        let chatViewController = chatStoryboard.instantiateInitialViewController() as! UINavigationController
        return chatViewController
    }
    
    static func onBoardingViewController() -> OnboardingViewController {
        let onBoardingStoryboard = UIStoryboard(storyboard: .onBoarding)
        let onBoardingViewController: OnboardingViewController = onBoardingStoryboard.instantiateViewController()
        return onBoardingViewController
    }
    
}
