//
//  MainInfoTableViewController.swift
//  CoinBackpack
//
//  Created by Илья on 20.11.2022.
//

import UIKit

final class MarketTableViewController: UITableViewController {
    
    //MARK: Private properties
    private var markets: CoinMarkets?
    private var filteredMarket: [MarketsInfo] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var delegate: AddCoinViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.backgroundColor = .black
        
        setupSearchController()
        setupNavigationBar()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredMarket.count : markets?.markets.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as? MarketTableViewCell
        else {
            return UITableViewCell()
        }
        
        let coinOnMarket = isFiltering
        ? filteredMarket[indexPath.row]
        : markets?.markets[indexPath.row]
        cell.configure(with: coinOnMarket)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        let selectCoin = isFiltering
        ? filteredMarket[indexPath.row]
        : markets?.markets[indexPath.row]
        performSegue(withIdentifier: "addCoin", sender: selectCoin)
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let datailVC = segue.destination as? DatailViewController else { return }
         datailVC.fetchName(from: sender as? MarketsInfo)
         datailVC.selectedCoins = sender as? MarketsInfo
         datailVC.delegate = delegate
     }
    
    // MARK: - IBAction
    @IBAction func allCoins(_ sender: UIBarButtonItem) {
        fetchData(for: .marketsAll)
    }
    
    // MARK: - Private methods
    private func fetchData(for type: CreateLink.TypeLink) {
        NetworkManager.shared.fetch(type: CoinMarkets.self,
                                    needFor: type) { [weak self] result in
            switch result {
            case .success(let loadMarket):
                self?.markets = loadMarket
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSearch(from coin: String) {
        if !coin.isEmpty {
            NetworkManager.shared.fetch(type: CoinMarkets.self,
                                        needFor: .coinSearch,
                                        coin: coin.lowercased()) { [weak self] result in
                switch result {
                case .success(let loadCoin):
                    self?.filterContentForSearchText(coin, loadCoin.markets)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            fetchMarkets()
        }
    }
    
    private func filterContentForSearchText(_ searchText: String, _ loadMarket: [MarketsInfo]) {
        filteredMarket = loadMarket.filter { market in
            market.baseAsset.uppercased() == searchText.uppercased()
        }
        tableView.reloadData()
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"
        self.searchController.searchBar.barTintColor = .white
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Search"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

    // MARK: - Extension
extension MarketTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        fetchSearch(from: searchController.searchBar.text ?? "")
    }
    
    func fetchMarkets() {
        NetworkManager.shared.fetch(type: CoinMarkets.self,
                                    needFor: .markets) { [weak self] result in
            switch result {
            case .success(let loadMarkets):
                self?.markets = loadMarkets
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
