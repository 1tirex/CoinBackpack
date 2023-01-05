//
//  StorageManager.swift
//  CoinBackpack
//
//  Created by Илья on 30.11.2022.
//

import Foundation
import Alamofire

final class StorageManager {
    static let shared = StorageManager()

    private let defaults = UserDefaults.standard
    private let coinKey = "coinsKey"
    
    private init() {}
    
    func fetchCoins() -> [Coin] {
        guard let data = defaults.data(forKey: coinKey) else { return [] }
        // Вот тут не понимаю как внедрить Alamofire
        guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else { return [] }
        return coins
    }
    
    func save(coin: Coin) {
        var coins = fetchCoins()
        coins.append(coin)
        guard let data = try? JSONEncoder().encode(coins) else { return }
        defaults.set(data, forKey: coinKey)
    }

    func deleteCoin(at index: Int) {
        var coins = fetchCoins()
        coins.remove(at: index)
        guard let data = try? JSONEncoder().encode(coins) else { return }
        defaults.set(data, forKey: coinKey)
    }
    
    func update(coin: Coin?) {
        var coins = fetchCoins()
        let index = coins.firstIndex { $0.baseAsset == coin?.baseAsset }
        guard let index = index, let coin = coin else { return }
        coins[index] = coin
        guard let data = try? JSONEncoder().encode(coins) else { return }
        defaults.set(data, forKey: coinKey)
    }
    
//    func getLabels(for coinName: String) {
//
//    }
}
