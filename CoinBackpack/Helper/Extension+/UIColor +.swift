//
//  UIColor +.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import UIKit

extension UIColor {
    static func colorWith(name: String) -> UIColor? {
        let selector = Selector("\(name)Color")
        
        if UIColor.self.responds(to: selector) {
            let color = UIColor.self.perform(selector).takeUnretainedValue()
            return (color as? UIColor)
        } else {
            return nil
        }
    }
    
    static var tabBarItemLight: UIColor {
        #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 0.5084592301)
    }
}
