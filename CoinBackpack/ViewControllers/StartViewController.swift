//
//  StartViewController.swift
//  CoinBackpack
//
//  Created by Илья on 01.12.2022.
//

import UIKit
import SwiftyGif

final class StartViewController: UIViewController {
    
    private let logoAnimationView = LogoAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }
}

extension StartViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true

        performSegue(withIdentifier: "choiceScreen", sender: nil)
    }
}
