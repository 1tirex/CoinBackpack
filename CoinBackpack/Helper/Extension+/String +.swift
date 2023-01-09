//
//  String +.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 09.01.23.
//

import Foundation

extension String {
    func toFloat() -> Float {
        let newCharSet = CharacterSet.init(charactersIn: "-+$%")
        let numberText = self.components(separatedBy: newCharSet).joined()
        guard let number = Float(numberText) else { return 0}
        
        return number
    }
}
