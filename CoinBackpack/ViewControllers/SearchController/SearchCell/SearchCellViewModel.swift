//
//  SearchCellViewModel.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import Foundation

protocol SearchCellViewModelProtocol {
    var symbol: String { get }
    var price: String { get }
    var exchange: String { get }
    var image: String { get }
    init(coin: Market)
}

final class SearchCellViewModel: SearchCellViewModelProtocol {
    var symbol: String {
        coin.symbol
    }
    
    var price: String {
        "\(String(format: "%.6f", coin.price))$"
    }
    
    var exchange: String {
        coin.exchange
    }
    
    var image: String {
        coin.baseAsset.lowercased()
    }
    
    private var coin: Market
    
    init(coin: Market) {
        self.coin = coin
    }
}
