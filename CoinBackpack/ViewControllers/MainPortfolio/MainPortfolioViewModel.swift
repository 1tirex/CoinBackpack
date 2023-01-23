//
//  MainPortfolioViewModel.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import Foundation

protocol MainPortfolioViewModelProtocol {
    var namePage: String { get }
    var isTapped: Box<Bool> { get }
    var percent: Box<Double> { get }
    var purchase: Box<String> { get }
    var colorChangeWallet: Box<String> { get }
    var wallet: Box<String> { get }
    var numberOfRowsInSection: Int { get }
    func fetchCoins(completion: @escaping() -> Void)
    func getCoin(_: IndexPath) -> MainCellViewModelProtocol
    func deleteCoin(_: IndexPath, completion: @escaping () -> Void)
    func tabSortButton()
}

final class MainPortfolioViewModel: MainPortfolioViewModelProtocol {
    var namePage: String {
        Resources.NamesPages.mainPortfolio
    }
    
    var isTapped: Box<Bool>
    
    var percent: Box<Double>
    
    var purchase: Box<String>
    
    var colorChangeWallet: Box<String>
    
    var wallet: Box<String>
    
    var numberOfRowsInSection: Int {
        coinsInPortfolio.count
    }
    
    private var gameTimer: Timer?
    
    private var coinsInPortfolio: [Coin] = []
    
    required init() {
        wallet = Box("$0.00")
        colorChangeWallet = Box("")
        purchase = Box("$0.00")
        percent = Box(0)
        isTapped = Box(true)
        
        settingTimer()
    }
}

extension MainPortfolioViewModel {
    @objc private func reloadWallet() {
        coinsInPortfolio.forEach { coin in
            fetchCoin(from: coin.baseAsset)
        }
        getColorAndNewValueForWallet()
        
        //        percent.value = Double(setRating(coinsInPortfolio.map { $0.profit }))
    }
    
    func fetchCoins(completion: @escaping () -> Void) {
        coinsInPortfolio = StorageManager.shared.fetchCoins()
        reloadWallet()
        coinsInPortfolio = coinsInPortfolio.sorted { $0.totalPrice > $1.totalPrice }
        completion()
    }
    
    func getCoin(_ index: IndexPath) -> MainCellViewModelProtocol {
        MainCellViewModel(coin: coinsInPortfolio[index.row])
    }
    
    func deleteCoin(_ index: IndexPath, completion: @escaping () -> Void) {
        StorageManager.shared.deleteCoin(at: index.row)
        coinsInPortfolio.remove(at: index.row)
        completion()
        reloadWallet()
    }
    
    func tabSortButton() {
        isTapped.value.toggle()
        
        coinsInPortfolio = isTapped.value
        ? coinsInPortfolio.sorted { $0.profit > $1.profit }
        : coinsInPortfolio.sorted { $0.profit < $1.profit }
    }
    
    private func settingTimer() {
        gameTimer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(reloadWallet),
            userInfo: nil,
            repeats: true)
        gameTimer?.tolerance = 0.2
        RunLoop.current.add(gameTimer ?? .init(), forMode: .common)
    }
    
    private func getColorAndNewValueForWallet() {
        let formulaForWallet = coinsInPortfolio.map { $0.totalPrice + $0.profit }.reduce(0, +)
        let formulaForPurchase = coinsInPortfolio.map { $0.profit }.reduce(0, +)
        if wallet.value.toFloat() != formulaForWallet {
            if wallet.value.toFloat() > formulaForWallet {
                colorChangeWallet.value = "systemPink"
            } else if wallet.value.toFloat() < formulaForWallet {
                colorChangeWallet.value = "systemMint"
            } else {
                colorChangeWallet.value = "label"
            }
            wallet.value = "$\(String(format: "%.2f", formulaForWallet))"
            
            if purchase.value.toFloat() != formulaForPurchase {
                purchase.value = "$\(String(format: "%.2f", formulaForPurchase))"
            }
        }
    }
    
    private func fetchCoin(from coin: String) {
        NetworkManager.shared.fetch(
            type: Assets.self,
            needFor: .coinInfoSearch,
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
}
