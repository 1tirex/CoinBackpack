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
        var url = ""
        
        switch needLinkFor {
        case .markets:
            url = "https://cryptingup.com/api/markets?size=10"
//            self.url = url
        case .marketsAll:
            url = "https://cryptingup.com/api/markets?size=all"
//            self.url = url
        case .coinMarketsSearch:
            url = "https://cryptingup.com/api/assets/\(coin.uppercased())/markets"
//            self.url = url
        case .assetsCoin:
            url = "https://cryptingup.com/api/assets?size=10"
//            self.url = url
        case .postRequest:
            url = "https://jsonplaceholder.typicode.com/posts"
//            self.url = url
        case .coinInfoSearch:
            url = "https://cryptingup.com/api/assets/\(coin.uppercased())"
        }
        
        self.url = url
    }
}

// MARK: - CreateLink
public extension CreateLink {
    enum TypeLink: String {
        case markets, marketsAll, coinMarketsSearch, coinInfoSearch, assetsCoin, postRequest
    }
}
