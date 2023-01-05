//
//  TabBarViewController.swift
//  CoinBackpack
//
//  Created by Илья on 01.12.2022.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
        
        setBackgroundColor()
        setColorTabBar()
    }
    
    private func setBackgroundColor() {
        view.backgroundColor =
        UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.colorWith(name: Resources.Colors.background)
                ?? .systemBackground
            default:
                return UIColor.colorWith(name: Resources.Colors.secondaryBackground)
                ?? .systemGray6
            }
        }
    }
    
    private func setColorTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarItemAppearance.configureWithDefault(for: .inline)
        tabBarItemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        tabBarItemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        tabBar.barTintColor = view.backgroundColor
        tabBar.tintColor = UIColor.colorWith(name: Resources.Colors.active)
        tabBar.unselectedItemTintColor = UIColor.colorWith(name: Resources.Colors.inActive)
    }
}
