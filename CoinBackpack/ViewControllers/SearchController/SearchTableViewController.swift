//
//  MainInfoTableViewController.swift
//  CoinBackpack
//
//  Created by Илья on 20.11.2022.
//

import UIKit

final class SearchTableViewController: UITableViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Private properties
    
    private var filteredMarket: [Market] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var markets: [Market] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.backgroundColor = .black
        
        setupSearchController()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchMarkets()
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.activityIndicator.isAnimating {
            return 0
        } else {
            return isFiltering ? filteredMarket.count : markets.count
        }
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
        : markets[indexPath.row]
        cell.configure(with: coinOnMarket)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectCoin = isFiltering
        ? filteredMarket[indexPath.row]
        : markets[indexPath.row]
        performSegue(withIdentifier: "addCoin", sender: selectCoin)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let datailVC = segue.destination as? DatailViewController else { return }
        datailVC.fetchName(from: sender as? Market)
        datailVC.selectedCoins = sender as? Market
    }
    
    // MARK: - IBAction
    @IBAction func allCoins(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        tableView.reloadData()
        fetchData(for: .marketsAll)
    }
    
    // MARK: - Private methods
    private func fetchData(for type: CreateLink.TypeLink) {
        NetworkManager.shared.fetch(
            type: CoinsMarkets.self,
            needFor: type) { [weak self] result in
                switch result {
                case .success(let loadMarket):
                    self?.markets = loadMarket.markets
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func fetchSearch(from coin: String) {
        if !coin.isEmpty {
            NetworkManager.shared.fetch(
                type: CoinsMarkets.self,
                needFor: .coinSearch,
                coin: coin.lowercased()) { [weak self] result in
                    switch result {
                    case .success(let loadCoin):
                        self?.filterContentForSearchText(coin, loadCoin.markets)
                        self?.activityIndicator.stopAnimating()
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
        } else {
            fetchMarkets()
        }
    }
    
    private func filterContentForSearchText(_ searchText: String, _ loadMarket: [Market]) {
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
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
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
extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        activityIndicator.startAnimating()
        fetchSearch(from: searchController.searchBar.text ?? "")
    }
    
    func fetchMarkets() {
        NetworkManager.shared.fetch(
            type: CoinsMarkets.self,
            needFor: .markets) { [weak self] result in
                switch result {
                case .success(let loadMarkets):
                    self?.markets = loadMarkets.markets
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}
