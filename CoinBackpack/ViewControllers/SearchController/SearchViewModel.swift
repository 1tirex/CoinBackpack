//
//  SearchViewModel.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import Foundation

protocol SearchViewModelProtocol {
    func fetchData(completion: @escaping() -> Void)
    func searchResults(on: String, completion: @escaping() -> Void)
    func numberOfRowsInSection(_: Bool) -> Int
    func getSearchCellViewModel(at: IndexPath, _: Bool) -> SearchCellViewModelProtocol
    func getDeteilViewModel(at: IndexPath, _: Bool) -> DatailViewModelProtocol
}

final class SearchViewModel: SearchViewModelProtocol {
    
    private var filteredMarket: [Market] = []
    private var markets: [Market] = []
    
    func fetchData(completion: @escaping () -> Void) {
        NetworkManager.shared.fetch(
            type: CoinsMarkets.self,
            needFor: .markets) { [weak self] result in
                switch result {
                case .success(let loadMarkets):
                    self?.markets = loadMarkets.markets
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func searchResults(on coin: String, completion: @escaping () -> Void) {
        NetworkManager.shared.fetch(
            type: CoinsMarkets.self,
            needFor: .coinSearch,
            coin: coin.lowercased()) { [weak self] result in
                switch result {
                case .success(let loadCoin):
                    self?.filteredMarket = loadCoin.markets.filter { $0.baseAsset.uppercased() == coin.uppercased() }
//                    self?.filterContentForSearchText(coin, loadCoin.markets)
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
//    private func filterContentForSearchText(_ searchText: String,
//                                            _ loadMarket: [Market]) {
//        filteredMarket = loadMarket.filter { $0.baseAsset.uppercased() == searchText.uppercased() }
////        tableView.reloadData()
//    }
    
    func numberOfRowsInSection(_ isFiltering: Bool) -> Int {
        isFiltering ? filteredMarket.count : markets.count
    }
    
    func getSearchCellViewModel(at indexPath: IndexPath, _ isFiltering: Bool) -> SearchCellViewModelProtocol {
        SearchCellViewModel(coin: isFiltering ? filteredMarket[indexPath.row] : markets[indexPath.row])
    }
    
    func getDeteilViewModel(at indexPath: IndexPath, _ isFiltering: Bool) -> DatailViewModelProtocol {
        DatailViewModel(coin: isFiltering ? filteredMarket[indexPath.row] : markets[indexPath.row])
    }
}
