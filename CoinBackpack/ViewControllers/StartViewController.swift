//
//  StartViewController.swift
//  CoinBackpack
//
//  Created by Илья on 01.12.2022.
//

import UIKit
import SwiftyGif

class StartViewController: UIViewController {
    
    private let logoAnimationView = LogoAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoAnimationView)
        self.logoAnimationView.pinEdgesToSuperView()
        self.logoAnimationView.logoGifImageView.delegate = self
        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logoAnimationView.logoGifImageView.startAnimatingGif()
    }
    

    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
}

extension StartViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        self.logoAnimationView.isHidden = true
        performSegue(withIdentifier: "choiceScreen", sender: nil)
    }
}
