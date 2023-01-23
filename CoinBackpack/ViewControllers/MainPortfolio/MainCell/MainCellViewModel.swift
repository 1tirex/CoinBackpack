//
//  MainCellViewModel.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import Foundation

protocol MainCellViewModelProtocol {
    var name: String { get }
    var symbol: String { get }
    var exchenge: String { get }
    var price: String { get }
    var total: String { get }
    var percent: String { get }
    var purchase: String { get }
    var image: String { get }
    var percentFloat: Float { get }
    var purchaseFloat: Float { get }
    init(coin: Coin)
}

final class MainCellViewModel: MainCellViewModelProtocol {
    var name: String {
        coin.name
    }
    
    var symbol: String {
        coin.symbol
    }
    
    var exchenge: String {
        coin.exchange
    }
    
    var price: String {
        "\(String(format: "%.2f", coin.price ))$"
    }
    
    var total: String {
        "\(String(format: "%.2f", coin.totalPrice))$"
    }
    
    var percent: String {
        "\(String(format: "%.2f", (coin.price * coin.amount) - (coin.purchase * coin.amount) / (coin.amount * coin.purchase) / coin.price))%"
    }
    
    var purchase: String {
        "\(String(format: "%.2f", (coin.price - coin.purchase) * coin.amount))$"
    }
    
    var image: String {
        coin.baseAsset.lowercased()
    }
    
    var percentFloat: Float {
        (coin.price - coin.purchase) / (coin.purchase / coin.price)
    }
    
    var purchaseFloat: Float {
        coin.price - coin.purchase
    }
    
    private var coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
    }
}
