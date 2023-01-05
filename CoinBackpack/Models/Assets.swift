//
//  Assets.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

struct Assets: Codable {
    let assets: [AssetsCoin]?
    let asset: AssetsCoin?
    let next: String?
}

// MARK: AssetsCoin
struct AssetsCoin: Codable {
    let symbol: String
    let name: String
    let description: String
    let price: Float
    let volume24Hour: Float
    let change1Hour: Float
    let change24Hour: Float
    let change7Day: Float
    let totalSupply: Float
    let maxSupply: Float?
    let marketCup: Float
    
    enum CodingKeys: String, CodingKey {
        case name, description, price
        case symbol = "asset_id"
        case volume24Hour = "volume_24h"
        case change1Hour = "change_1h"
        case change24Hour = "change_24h"
        case change7Day = "change_7d"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case marketCup = "market_cap"
    }
}
