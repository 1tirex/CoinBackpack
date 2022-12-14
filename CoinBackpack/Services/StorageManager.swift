//
//  StorageManager.swift
//  CoinBackpack
//
//  Created by Илья on 30.11.2022.
//

import Foundation
import Alamofire

class StorageManager {

    static let shared = StorageManager()
    
    private let defaults = UserDefaults.standard
    private let coinKey = "coinsKey"
    
    private init() {}
    
    func save(coin: MarketsInfo) {
        var coins = fetchCoins()
        coins.append(coin)
        guard let data = try? JSONEncoder().encode(coins) else { return }
        defaults.set(data, forKey: coinKey)
    }
    
    func fetchCoins() -> [MarketsInfo] {

        guard let data = defaults.data(forKey: coinKey) else { return [] }
        // Вот тут не понимаю как внедрить Alamofire
        guard let coins = try? JSONDecoder().decode([MarketsInfo].self, from: data) else { return [] }
        return coins
    }
    
    func deleteCoin(at index: Int) {
        var coins = fetchCoins()
        coins.remove(at: index)
        guard let data = try? JSONEncoder().encode(coins) else { return }
        defaults.set(data, forKey: coinKey)
    }
}

//extension StorageManager: DataDecoder {
//    func decode<D>(_ type: D.Type, from data: Data) throws -> D where D : Decodable {
//        <#code#>
//    }
//}
