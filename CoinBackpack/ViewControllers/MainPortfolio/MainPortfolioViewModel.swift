//
//  MainPortfolioViewModel.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import Foundation

protocol MainPortfolioViewModelProtocol {
    var namePage: String { get }
    var colorChangeWallet: Box<String> { get }
    var wallet: Box<String> { get }
    var numberOfRowsInSection: Int { get }
    func fetchCoins(completion: @escaping() -> Void)
    func getCoin(_: IndexPath) -> MainCellViewModelProtocol
    func deleteCoin(_: IndexPath, completion: @escaping () -> Void)
}

final class MainPortfolioViewModel: MainPortfolioViewModelProtocol {
    var namePage: String {
        Resources.NamesPages.mainPortfolio
    }
    
    var colorChangeWallet: Box<String>
    
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
        colorChangeWallet = Box("")
        gameTimer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(reloadWallet),
            userInfo: nil,
            repeats: true)
    }
}

extension MainPortfolioViewModel {
    @objc private func reloadWallet() {
        coinsInPortfolio.forEach { coin in
            fetchCoin(from: coin.baseAsset)
        }
        getColorAndNewValueForWallet()
    }
    
    func fetchCoins(completion: @escaping () -> Void) {
        coinsInPortfolio = StorageManager.shared.fetchCoins()
        reloadWallet()
        completion()
    }
    
    private func getColorAndNewValueForWallet() {
        let formula = coinsInPortfolio.map { $0.totalPrice + $0.profit }.reduce(0, +)
        if wallet.value.toFloat() != formula {
            colorChangeWallet.value = wallet.value.toFloat() > formula ? "systemPink" : "systemMint"
        }
        wallet.value = "$\(String(format: "%.2f", formula))"
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
