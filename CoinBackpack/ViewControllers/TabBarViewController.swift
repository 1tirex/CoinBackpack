//
//  TabBarViewController.swift
//  CoinBackpack
//
//  Created by Илья on 01.12.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//          if self.selectedIndex == 0 {
//             let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
//             rootView.popToRootViewController(animated: false)
//          }
//      }
}
