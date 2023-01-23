//
//  TabBarViewController.swift
//  CoinBackpack
//
//  Created by Илья on 01.12.2022.
//

import UIKit

final class TabBarViewController: UITabBarController {

    private var circle: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
        
        setBackgroundColor()
        setColorTabBar()
        setTabBarAppearance()
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
            .foregroundColor: view.backgroundColor ?? .label
        ]
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.colorWith(name: Resources.Colors.active)?.cgColor
        
        tabBar.barTintColor = view.backgroundColor
        tabBar.tintColor = view.backgroundColor
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
}
