//
//  Extensions.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var shadowBackgroundColor: UIColor {
        get {
            let color = layer.backgroundColor ?? UIColor.clear.cgColor
            return UIColor(cgColor: color)
        }
        set {
            layer.backgroundColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowOffset = CGSize(width: 0, height: 1)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}


extension UIColor {
    struct Blue {
        static let ouiSendBlueColor = UIColor(red: 16/255, green: 82/255, blue: 150/255, alpha: 1)
    }
}


extension String {
    func soundexContains(_ searchText: String) -> Bool {
        var contains = false
        let words = split(separator: " ")
        words.forEach { (word) in
            if Soundex().soundex(String(word)) == Soundex().soundex(searchText) {
                contains = true
            }
        }
        return contains
    }
    
    func removeAccents() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
    
    func emphaseText(textToEmphase: String) -> NSAttributedString {
        
        let longString = self as NSString
        let longStringLowercased = self.lowercased() as NSString
        
        let attributedString = NSMutableAttributedString(string: longString as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15.0)])
        
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)]
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: longStringLowercased.range(of: textToEmphase.lowercased()))
        
        // 4
        return attributedString
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
