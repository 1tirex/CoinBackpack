//
//  UIView +.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import UIKit

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
