//
//  CreateLinkForMarkets.swift
//  CoinBackpack
//
//  Created by Илья on 22.11.2022.
//

import Foundation

public struct CreateLink {
    public let needLinkFor: TypeLink
    public let coin: String
    public let url: String
    
    public init(needLinkFor: TypeLink, baseAsset coin: String = "") {
        self.needLinkFor = needLinkFor
        self.coin = coin
        
        switch needLinkFor {
        case .markets:
            let url = "https://cryptingup.com/api/markets?size=10"
            self.url = url
        case .marketsAll:
            let url = "https://cryptingup.com/api/markets?size=all"
            self.url = url
        case .coinSearch:
            let url = "https://cryptingup.com/api/assets/\(coin.uppercased())"
            self.url = url
        case .assetsCoin:
            let url = "https://cryptingup.com/api/assets?size=10"
            self.url = url
        case .postRequest:
            let url = "https://jsonplaceholder.typicode.com/posts"
            self.url = url
        }
    }
}

// MARK: - CreateLink
public extension CreateLink {
    enum TypeLink: String {
        case markets, marketsAll, coinSearch, assetsCoin, postRequest
    }
}
