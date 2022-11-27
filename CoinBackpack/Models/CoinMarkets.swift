//
//  CoinMarkets.swift
//  CoinBackpack
//
//  Created by Илья on 20.11.2022.
//

struct CoinMarkets: Codable {
    let markets: [MarketsInfo]
    let next: String
}

struct MarketsInfo: Codable {
    let name: String?
    let totalPrice: String?
    let amountCoins: String?
    let buyPriceCoin: String?
    let imageCoin: String?
    let percent: String?
    let gainMoney: String?
    let exchange: String
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let priceUnconverted: Float
    let price: Float
    let change24Hour: Float
    let spread: Float
    let volume24Hour: Float
    let status: String
    let created: String
    let updated: String
    
    
    init(name: String, totalPrice: String, amountCoins: String, buyPriceCoin: String,
         imageCoin: String, percent: String, gainMoney: String, exchange: String, symbol: String, baseAsset: String,
         quoteAsset: String, priceUnconverted: Float, price: Float, change24Hour: Float,
         spread: Float, volume24Hour: Float, status: String, created: String, updated: String) {
        self.name = name
        self.totalPrice = totalPrice
        self.amountCoins = amountCoins
        self.buyPriceCoin = buyPriceCoin
        self.imageCoin = imageCoin
        self.percent = percent
        self.gainMoney = gainMoney
        self.exchange = exchange
        self.symbol = symbol
        self.baseAsset = baseAsset
        self.quoteAsset = quoteAsset
        self.priceUnconverted = priceUnconverted
        self.price = price
        self.change24Hour = change24Hour
        self.spread = spread
        self.volume24Hour = volume24Hour
        self.status = status
        self.created = created
        self.updated = updated
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case totalPrice
        case amountCoins
        case buyPriceCoin
        case imageCoin
        case percent
        case gainMoney
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

struct Assets: Codable {
    let assets: [AssetsName]
}

struct AssetsName: Codable {
    let asset: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case asset = "asset_id"
        case name
    }
}
