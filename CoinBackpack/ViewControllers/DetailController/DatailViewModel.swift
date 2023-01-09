//
//  DatailViewModel.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import Foundation

enum TextFields {
    case amount, purchase
}

protocol DatailViewModelProtocol {
    var statusIsEnabled: Bool { get }
    var image: String { get }
    var symbol: String { get }
    var exchange: String { get }
    var price: String { get }
    var percent: Box<String> { get }
    var profit: Box<String> { get }
    var total: Box<String> { get }
    var name: Box<String> { get }
    var amount: Box<Float> { get }
    var purchase: Box<Float> { get }
    init(coin: Market)
    func saveResults(completion: @escaping() -> Void)
    func getText(from: String, _: TextFields)
}

final class DatailViewModel: DatailViewModelProtocol {
    
    var statusIsEnabled: Bool { !purchase.value.isZero }
    
    var image: String { coin.baseAsset.lowercased() }
    
    var symbol: String { coin.symbol }
    
    var exchange: String { coin.exchange }
    
    var price: String { "\(String(format: "%.6f", coin.price))$" }
    
    var profit: Box<String>
    var percent: Box<String>
    var total: Box<String>
    
    var name: Box<String>
    var amount: Box<Float>
    var purchase: Box<Float>
    
    private var coin: Market
    
    private var percents: Float {
        (amount.value * coin.price - amount.value * purchase.value) / ((amount.value * purchase.value) / coin.price)
    }
    
    private var profits: Float {
        (coin.price - purchase.value) * amount.value
    }
    
    init(coin: Market) {
        self.coin = coin
        name = Box(coin.baseAsset)
        amount = Box(1)
        purchase = Box(0)
        profit = Box("")
        percent = Box("")
        total = Box("")
        fetchName()
    }
    
    func saveResults(completion: @escaping() -> Void) {
        let coinInfo = Coin(name: name.value,
                            symbol: coin.symbol,
                            baseAsset: coin.baseAsset,
                            quoteAsset: coin.quoteAsset,
                            imageCoin: coin.baseAsset,
                            exchange: coin.exchange,
                            price: coin.price,
                            amountCoins: amount.value,
                            purchase: purchase.value)
        
        StorageManager.shared.save(coin: coinInfo)
        print(coinInfo)
        completion()
    }
    
    private func fetchName() {
        NetworkManager.shared.fetch(
            type: Assets.self,
            needFor: .coinInfoSearch,
            coin: name.value.uppercased()) { [weak self] result in
                switch result {
                case .success(let loadName):
                    self?.name.value = loadName.asset?.name ?? "Not Found Coin Name"
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func getText(from text: String, _ field: TextFields) {
        switch field {
        case .amount:
            amount.value = Float(text) ?? 1
        case .purchase:
            purchase.value = Float(text) ?? 0
        }
        calculateResult()
    }
    
    private func calculateResult() {
        if purchase.value.isZero {
            percent.value = "0.0%"
            profit.value = "0.00$"
            total.value = "0.00$"
        } else {
            percent.value = "\(String(format: "%.2f", percents))%"
            profit.value = "\(String(format: "%.2f", profits))$"
            total.value = "\(String(format: "%.2f", amount.value * purchase.value))$"
        }
    }
}
