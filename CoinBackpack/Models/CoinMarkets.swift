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
    let name: String?
    let totalPrice: String?
    let amountCoins: String?
    let buyPriceCoin: String?
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
    
    init(name: String, totalPrice: String, amountCoins: String, buyPriceCoin: String, exchange: String, symbol: String, baseAsset: String,
         quoteAsset: String, priceUnconverted: Float, price: Float, change24Hour: Float,
         spread: Float, volume24Hour: Float, status: String, created: String, updated: String) {
        self.name = name
        self.totalPrice = totalPrice
        self.amountCoins = amountCoins
        self.buyPriceCoin = buyPriceCoin
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
    
    init(coinJP: AddCoinPortfolio) {
        name = coinJP.name
        totalPrice = coinJP.totalPrice
        amountCoins = coinJP.amountCoins
        buyPriceCoin = coinJP.buyPriceCoin
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
        case name
        case totalPrice
        case amountCoins
        case buyPriceCoin
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

struct Assets: Decodable {
    let assets: [AssetsName]
}

struct AssetsName: Decodable {
    let asset: String
    let name: String
    
    enum Coding: String, CodingKey {
        case asset = "asset_id"
        case name
    }
}

struct AddCoinPortfolio: Decodable {
    let name: String
    let totalPrice: String
    let amountCoins: String
    let buyPriceCoin: String
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

    enum CodingKeys: String, CodingKey {
        case name
        case totalPrice
        case amountCoins
        case buyPriceCoin
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


