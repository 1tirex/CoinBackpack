//
//  Coin.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

struct Coin: Codable {
    let name: String
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let image: String
    let exchange: String
    let price: Float
    let amount: Float
    let purchase: Float
    let totalPrice: Float
    let percent: Float
    let profit: Float
    //    let change24Hour: Float
    //    let volume24Hour: Float
    //    let priceUnconverted: Float
    //    let spread: Float
    //    let updated: String
    
    init(asset: AssetsCoin, coin: Coin) {
        self.name = asset.name
        self.symbol = coin.symbol
        self.baseAsset = coin.baseAsset
        self.quoteAsset = coin.baseAsset
        self.image = coin.baseAsset
        self.exchange = coin.exchange
        self.price = asset.price
        self.amount = coin.amount
        self.purchase = coin.purchase
        self.totalPrice = amount * purchase
        self.percent = (price - purchase) / (purchase / price)
        self.profit = price - purchase
    }
    
    init(name: String, symbol: String, baseAsset: String,
         quoteAsset: String, imageCoin: String, exchange: String,
         price: Float, amountCoins: Float, buyPriceCoin: Float) {
        
        self.name = name
        self.symbol = symbol
        self.baseAsset = baseAsset
        self.quoteAsset = quoteAsset
        self.image = imageCoin
        self.exchange = exchange
        self.price = price
        self.amount = amountCoins
        self.purchase = buyPriceCoin
        self.totalPrice = amountCoins * buyPriceCoin
        self.percent = (price - buyPriceCoin) / (buyPriceCoin / price)
        self.profit = price - buyPriceCoin
    }
}
