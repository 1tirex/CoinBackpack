//
//  MainPortfolioViewModel.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import Foundation

protocol MainPortfolioViewModelProtocol {
    var wallet: Box<String> { get }
    var numberOfRowsInSection: Int { get }
    
    func fetchCoins(completion: @escaping() -> Void)
    func getCoin(_: IndexPath) -> Coin
}

final class MainPortfolioViewModel: MainPortfolioViewModelProtocol {
    var wallet: Box<String>
    var numberOfRowsInSection: Int {
        coinsInPortfolio.count
    }
    
    private var gameTimer: Timer?
    
    private var coinsInPortfolio: [Coin] = [] {
        didSet {
            coinsInPortfolio = coinsInPortfolio.sorted {
                $0.totalPrice < $1.totalPrice
            }
        }
    }
    
    func fetchCoins(completion: @escaping () -> Void) {
        coinsInPortfolio = StorageManager.shared.fetchCoins()
        completion()
    }
    
    required init() {
        wallet = Box("0.00$")
        gameTimer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(reloadWallet),
            userInfo: nil,
            repeats: true)
    }
    
    @objc private func reloadWallet() {
        wallet.value = "0.00$"
        
        coinsInPortfolio.forEach { coin in
            reloadCoin(from: coin.baseAsset)
        }
//        coinsInPortfolio.forEach { coin in
//            reloadCoin(from: coin.baseAsset)
//
//            guard let totalPrice = coin.totalPrice,
//                  let gainMoney = coin.gainMoney else { return }
//
//            let totalText = resetCharacter(for: totalPrice)
//            let moneyText = resetCharacter(for: gainMoney)
//
//            guard let total = Float(totalText),
//                  let money = Float(moneyText) else { return }
//
//            var wallet: Float = 0
//
//            wallet += (gainMoney.contains("-"))
//            ? ( total - money )
//            : ( total + money )
//
//            self.wallet.value = "\(String(format: "%.2f", wallet))$"
//            print("\(String(format: "%.2f", wallet))$")
//        }
    }
    
    private func resetCharacter(for text: String) -> String {
        let newCharSet = CharacterSet.init(charactersIn: "-+$%")
        return text.components(separatedBy: newCharSet).joined()
    }
    
    private func reloadCoin(from coin: String) {
        print(coin)
        NetworkManager.shared.fetch(
            type: Assets.self,
            needFor: .coinSearch,
            coin: coin.lowercased()) { [weak self] result in
                switch result {
                case .success(let loadCoin):
                    self?.update(coin: loadCoin.asset)
                case .failure(let error):
                    print(error)
                }
            }
        
    }
    
    private func update(coin: AssetsCoin?) {
        let index = coinsInPortfolio.firstIndex { $0.baseAsset == coin?.symbol }
        guard let index = index, let coin = coin else { return }
        
        coinsInPortfolio[index] = Coin(asset: coin, coin: coinsInPortfolio[index])
        
        StorageManager.shared.update(coin: coinsInPortfolio[index])
    }
    
    func getCoin(_ index: IndexPath) -> Coin {
        coinsInPortfolio[index.row]
    }
    
    private func profitСalculation(amount count: Float = 0, buy buyPrice: Float = 0, price coinPrice: Float) -> (percent: Float, profit: Float) {
        
        var per: Float = 0
        var money: Float = 0
        
        if count.isZero, !buyPrice.isZero {
            
            let percentage = buyPrice / coinPrice
            let percent = (coinPrice - buyPrice) / percentage
            let gainMoney = coinPrice - buyPrice
            
            per = percent
            money = gainMoney
            
//            per = (percent.sign == .minus)
//            ? (self.percentLabel.text = "\(String(format: "%.2f", percent))%")
//            : (self.percentLabel.text = "+\(String(format: "%.2f", percent))%")
//
//            (gainMoney.sign == .minus)
//            ? (self.profitLabel.text = "\(String(format: "%.2f", gainMoney))$")
//            : (self.profitLabel.text = "+\(String(format: "%.2f", gainMoney))$")
//
        } else if !count.isZero, !buyPrice.isZero {
            
            let percentage = (count * buyPrice) / coinPrice
            let percent = (count * coinPrice - count * buyPrice) / percentage
            let gainMoney = (coinPrice - buyPrice) * count
            
            per = percent
            money = gainMoney
            
//            (percent.sign == .minus)
//            ? (self.percentLabel.text = "\(String(format: "%.2f", percent))%")
//            : (self.percentLabel.text = "+\(String(format: "%.2f", percent))%")
//
//            (gainMoney.sign == .minus)
//            ? (self.profitLabel.text = "\(String(format: "%.2f", gainMoney))$")
//            : (self.profitLabel.text = "+\(String(format: "%.2f", gainMoney))$")
        } else {
            
            per = 0
            money = 0
            
//            self.percentLabel.text = ""
//            self.profitLabel.text = ""
        }
//        profitСolorСhanges()
        
        return (per, money)
    }
    
//    private func profitСolorСhanges() {
//        guard let percent = self.percentLabel.text,
//                let gainMoney = self.profitLabel.text else { return }
//
//        if percent.contains("-"), gainMoney.contains("-") {
//            self.percentLabel.textColor = .systemPink
//            self.profitLabel.textColor = .systemPink
//        } else if percent.contains("+"), gainMoney.contains("+") {
//            let rgba = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1.0)
//            self.percentLabel.textColor = rgba
//            self.profitLabel.textColor = rgba
//        }
//    }
}
