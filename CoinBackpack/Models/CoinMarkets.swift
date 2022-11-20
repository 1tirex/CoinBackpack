//
//  CoinMarkets.swift
//  CoinBackpack
//
//  Created by Илья on 20.11.2022.
//

struct CoinMarkets: Decodable {
    let markets: [MarketsInfo]
}

struct MarketsInfo: Decodable {
    let exchange: String
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let price: Int
    let change24Hour: Int
    let volume24Hour: Int
    let next: Int
    
    
    
    enum CodingKeys: String, CodingKey {
        case exchange = "exchange_id"
        case symbol = "symbol"
        case baseAsset = "base_asset"
        case quoteAsset = "quote_asset"
        case price = "price"
        case change24Hour = "change_24h"
        case volume24Hour = "volume_24h"
        case next = "next"
    }
}

enum Link: String {
    case markets = "https://cryptingup.com/api/markets"
}
