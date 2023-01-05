//
//  CoinMarkets.swift
//  CoinBackpack
//
//  Created by Илья on 20.11.2022.
//

struct CoinsMarkets: Codable {
    let markets: [Market]
    let next: String
}

// MARK: Market
struct Market: Codable {
//    let name: String?
//    let percent: String?
//    let gainMoney: String?
//    let imageCoin: String?
//    let totalPrice: String?
//    let amountCoins: String?
//    let buyPriceCoin: String?
    let symbol: String
    let status: String
    let created: String
    let updated: String
    let exchange: String
    let baseAsset: String
    let quoteAsset: String
    let price: Float
    let spread: Float
    let change24Hour: Float
    let volume24Hour: Float
    let priceUnconverted: Float
    
    
    init(name: String, totalPrice: String, amountCoins: String,
         buyPriceCoin: String, imageCoin: String, percent: String,
         gainMoney: String, exchange: String, symbol: String,
         baseAsset: String, quoteAsset: String, status: String,
         priceUnconverted: Float, price: Float,
         change24Hour: Float, spread: Float, volume24Hour: Float,
         created: String, updated: String) {
//        self.name = name
        self.price = price
        self.symbol = symbol
        self.spread = spread
        self.status = status
        self.created = created
        self.updated = updated
//        self.percent = percent
        self.exchange = exchange
//        self.imageCoin = imageCoin
//        self.gainMoney = gainMoney
        self.baseAsset = baseAsset
        self.quoteAsset = quoteAsset
//        self.totalPrice = totalPrice
//        self.amountCoins = amountCoins
        self.change24Hour = change24Hour
        self.volume24Hour = volume24Hour
//        self.buyPriceCoin = buyPriceCoin
        self.priceUnconverted = priceUnconverted
    }
    
    init(newCoin: AssetsCoin, oldCoin: Market) {
//        self.name = oldCoin.name
        self.price = newCoin.price
        self.symbol = oldCoin.symbol
        self.spread = oldCoin.spread
        self.status = oldCoin.status
        self.created = oldCoin.created
        self.updated = oldCoin.updated
//        self.percent = oldCoin.percent
        self.exchange = oldCoin.exchange
//        self.imageCoin = oldCoin.imageCoin
//        self.gainMoney = oldCoin.gainMoney
        self.baseAsset = newCoin.symbol
        self.quoteAsset = oldCoin.quoteAsset
//        self.totalPrice = oldCoin.totalPrice
//        self.amountCoins = oldCoin.amountCoins
        self.change24Hour = newCoin.change24Hour
        self.volume24Hour = newCoin.volume24Hour
//        self.buyPriceCoin = oldCoin.buyPriceCoin
        self.priceUnconverted = oldCoin.priceUnconverted
    }
    
    enum CodingKeys: String, CodingKey {
        case created = "created_at"
        case updated = "updated_at"
        case exchange = "exchange_id"
        case baseAsset = "base_asset"
        case quoteAsset = "quote_asset"
        case change24Hour = "change_24h"
        case volume24Hour = "volume_24h"
        case priceUnconverted = "price_unconverted"
//        case name, totalPrice
        case price, spread, status
        case symbol
//        case amountCoins, buyPriceCoin, imageCoin
    }
}
