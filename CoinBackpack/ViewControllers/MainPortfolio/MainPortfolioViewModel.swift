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
    func getCoin(_: IndexPath) -> MainCellViewModelProtocol
    func deleteCoin(_: IndexPath, completion: @escaping () -> Void)
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
                $0.totalPrice > $1.totalPrice
            }
        }
    }
    
    required init() {
        wallet = Box("Loading..")
        gameTimer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(reloadWallet),
            userInfo: nil,
            repeats: true)
    }
    
    @objc private func reloadWallet() {
//        let wal = coinsInPortfolio.map { $0.totalPrice + $0.profit }.reduce(0, +)
        wallet.value = "\(String(format: "%.2f", coinsInPortfolio.map { $0.totalPrice + $0.profit }.reduce(0, +)))$"
        
        coinsInPortfolio.forEach { coin in
            fetchCoin(from: coin.baseAsset)
        }
    }
    
    func fetchCoins(completion: @escaping () -> Void) {
        coinsInPortfolio = StorageManager.shared.fetchCoins()
        completion()
        reloadWallet()
    }
    
    func getCoin(_ index: IndexPath) -> MainCellViewModelProtocol {
        MainCellViewModel(coin: coinsInPortfolio[index.row])
    }
    
    func deleteCoin(_ index: IndexPath, completion: @escaping () -> Void) {
        StorageManager.shared.deleteCoin(at: index.row)
        coinsInPortfolio.remove(at: index.row)
        reloadWallet()
        completion()
    }
    
    private func fetchCoin(from coin: String) {
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
}
