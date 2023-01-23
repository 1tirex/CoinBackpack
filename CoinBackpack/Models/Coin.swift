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
        self.percent = (price * amount - purchase * amount) / (amount * purchase) / price
        self.profit = (price - purchase) * amount
    }
    
    init(name: String, symbol: String, baseAsset: String,
         quoteAsset: String, imageCoin: String, exchange: String,
         price: Float, amountCoins: Float, purchase: Float) {
        
        self.name = name
        self.symbol = symbol
        self.baseAsset = baseAsset
        self.quoteAsset = quoteAsset
        self.image = imageCoin
        self.exchange = exchange
        self.price = price
        self.amount = amountCoins
        self.purchase = purchase
        self.totalPrice = amountCoins * purchase
        self.percent = (amountCoins * price - amountCoins * purchase) / (amountCoins * purchase) / price
        self.profit = (price - purchase) * amountCoins
    }
}
