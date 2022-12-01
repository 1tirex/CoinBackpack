//
//  LogoAnimationView.swift
//  CoinBackpack
//
//  Created by Илья on 01.12.2022.
//

import UIKit
import SwiftyGif

class LogoAnimationView: UIView {

    let logoGifImageView: UIImageView = {
        var iv = UIImageView()

        if let gif = try? UIImage(gifName: "logo.gif") {
            iv = UIImageView(gifImage: gif, loopCount: 1)
            iv.translatesAutoresizingMaskIntoConstraints = false
        }
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(logoGifImageView)
        logoGifImageView.centerXAnchor.constraint(
            equalTo: self.centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(
            equalTo: centerYAnchor, constant: -100).isActive = true
        logoGifImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoGifImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
extension UIView {

    func pinEdgesToSuperView() {
        guard let superView = superview else { return }

        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
}
