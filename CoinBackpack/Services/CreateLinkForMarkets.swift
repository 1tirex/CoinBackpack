//
//  CreateLinkForMarkets.swift
//  CoinBackpack
//
//  Created by Илья on 22.11.2022.
//

import Foundation

public struct CreateLink {
    
    public let next: String
    public let coin: String
    public let url: String
    
    // MARK: Initialization
    public init(next: String = "", baseAsset coin: String = "") {
        self.next = next
        self.coin = coin
        
        if next.isEmpty, coin.isEmpty {
            let url = "https://cryptingup.com/api/markets?size=10"
            self.url = url
        } else if next == "all" {
            let url = "https://cryptingup.com/api/markets?size=all"
            self.url = url
        } else {
            let url = "https://cryptingup.com/api/assets/\(coin.uppercased())/markets"
            self.url = url
        }
    }
}
