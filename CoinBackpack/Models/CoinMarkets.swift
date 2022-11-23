//
//  CoinMarkets.swift
//  CoinBackpack
//
//  Created by Илья on 20.11.2022.
//

struct CoinMarkets: Decodable {
    let markets: [MarketsInfo]
    let next: String
}

struct MarketsInfo: Decodable, Encodable {
    let exchange: String
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let priceUnconverted: Float?
    let price: Float
    let change24Hour: Float
    let spread: Float?
    let volume24Hour: Float
    let status: String?
    let created: String?
    let updated: String?
    
    init(coinJP: AddCoin) {
        exchange = coinJP.exchange
        symbol = coinJP.symbol
        baseAsset = coinJP.baseAsset
        quoteAsset = coinJP.quoteAsset
        priceUnconverted = coinJP.priceUnconverted
        price = coinJP.price
        change24Hour = coinJP.change24Hour
        spread = coinJP.spread
        volume24Hour = coinJP.volume24Hour
        status = coinJP.status
        created = coinJP.created
        updated = coinJP.updated
    }
    
    enum CodingKeys: String, CodingKey {
        case exchange = "exchange_id"
        case symbol
        case baseAsset = "base_asset"
        case quoteAsset = "quote_asset"
        case priceUnconverted = "price_unconverted"
        case price
        case change24Hour = "change_24h"
        case spread
        case volume24Hour = "volume_24h"
        case status
        case created = "created_at"
        case updated = "updated_at"
        }
}

struct AddCoin: Decodable, Encodable {
    let exchange: String
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let priceUnconverted: Float?
    let price: Float
    let change24Hour: Float
    let spread: Float?
    let volume24Hour: Float
    let status: String?
    let created: String?
    let updated: String?
    
    enum CodingKeys: String, CodingKey {
        case exchange = "exchange_id"
        case symbol
        case baseAsset = "base_asset"
        case quoteAsset = "quote_asset"
        case priceUnconverted = "price_unconverted"
        case price
        case change24Hour = "change_24h"
        case spread
        case volume24Hour = "volume_24h"
        case status
        case created = "created_at"
        case updated = "updated_at"
        }
}
