//
//  CryptoIconURLBuilder.swift
//  CoinBackpack
//
//  Created by Илья on 22.11.2022.
//

import Foundation

public struct CryptoIconURLBuilder {
    
    public let code: String
    public let style: Style
    public let size: Int
    public let url: String
    
    private let baseURL = URL(string: "https://cryptoicons.org")
    
    // MARK: Initialization
    public init(style: Style, code: String, size: Int) {
        self.style = style
        self.code = code
        self.size = size
        
        let url = "https://cryptoicons.org/api/\(style.rawValue)/\(code.lowercased())/\(size)"
        self.url = url
    }
}


// MARK: Style

public extension CryptoIconURLBuilder {
    enum Style: String {
        case black, white, color, icon
    }
}
