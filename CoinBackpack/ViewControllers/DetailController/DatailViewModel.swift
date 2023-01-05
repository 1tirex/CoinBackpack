//
//  DatailViewModel.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import Foundation

protocol DatailViewModelProtocol {
    var image: String { get }
    var symbol: String { get }
    var exchange: String { get }
    var price: String { get }
    var name: Box<String> { get }
    var percent: Box<Float> { get }
    var profit: Box<Float> { get }
    init(coin: Market)
    func saveResults()
}

final class DatailViewModel: DatailViewModelProtocol {
    var image: String {
        coin.baseAsset.lowercased()
    }
    
    var symbol: String {
        coin.symbol
    }
    
    var exchange: String {
        coin.exchange
    }
    
    var price: String {
        "\(String(format: "%.6f", coin.price))$"
    }
    
    var name: Box<String>
    var percent: Box<Float>
    var profit: Box<Float>
    
    private var coin: Market
    
    init(coin: Market) {
        self.coin = coin
        name = Box(coin.baseAsset)
        percent = Box(0)
        profit = Box(0)
    }
    
    func saveResults() {
        let coinInfo = Coin(name: name.value,
                            symbol: coin.symbol,
                            baseAsset: coin.baseAsset,
                            quoteAsset: coin.quoteAsset,
                            imageCoin: coin.baseAsset,
                            exchange: coin.exchange,
                            price: coin.price,
                            amountCoins: 0,//Float(amount) ?? 0,
                            buyPriceCoin: 0)//Float(buyPrice) ?? 0)
        StorageManager.shared.save(coin: coinInfo)
    }
    
    private func fetchName() {
        NetworkManager.shared.fetch(
            type: Assets.self,
            needFor: .coinSearch,
            coin: coin.baseAsset.uppercased()) { [weak self] result in
                switch result {
                case .success(let loadName):
                    self?.name.value = loadName.assets?
                        .filter { $0.name.uppercased() == self?.coin.baseAsset.uppercased() }
                        .first?.name ?? "Not Found"
                case .failure(let error):
                    print(error)
                }
            }
    }
    
//    private func profitСalculation(amt amount: Float = 0, buy buyPrice: Float = 0, price: Float) {
//        if amount.isZero, !buyPrice.isZero {

//            let percentage = buyPrice / price
//            let percent = (price - buyPrice) / buyPrice / price
//            let gainMoney = (price - buyPrice)

//            (percent.sign == .minus)
//            ? (self.percentLabel.text = "\(String(format: "%.2f", percent))%")
//            : (self.percentLabel.text = "+\(String(format: "%.2f", percent))%")
//
//            (gainMoney.sign == .minus)
//            ? (self.profitLabel.text = "\(String(format: "%.2f", gainMoney))$")
//            : (self.profitLabel.text = "+\(String(format: "%.2f", gainMoney))$")

//        } else if !amount.isZero, !buyPrice.isZero {
//            guard let amt = Float(amount), let price = Float(buyPrice) else { return }

//            let percentage = (amt * price) / selectedCoins.price
            
//            let percent = (price - buyPrice) / buyPrice / price
//            let gainMoney = (price - buyPrice)

//            (percent.sign == .minus)
//            ? (self.percentLabel.text = "\(String(format: "%.2f", percent))%")
//            : (self.percentLabel.text = "+\(String(format: "%.2f", percent))%")
//
//            (gainMoney.sign == .minus)
//            ? (self.profitLabel.text = "\(String(format: "%.2f", gainMoney))$")
//            : (self.profitLabel.text = "+\(String(format: "%.2f", gainMoney))$")
//        } else {
//            self.percentLabel.text = ""
//            self.profitLabel.text = ""
//        }
//        profitСolorСhanges()
    
}
