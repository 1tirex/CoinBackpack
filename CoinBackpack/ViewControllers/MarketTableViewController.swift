//
//  MainInfoTableViewController.swift
//  CoinBackpack
//
//  Created by Илья on 20.11.2022.
//

import UIKit

class MarketTableViewController: UITableViewController {
    
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
    
    var delegate: AddCoinViewControllerDelegate!
//    MarketTableViewController.delegate = self
    
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
        delegate?.sendPostRequest(with: selectCoin)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - IBAction
    @IBAction func allCoins(_ sender: UIBarButtonItem) {
        fetchData(from: "all")
    }
    
    // MARK: - Private methods
    private func fetchData(from url: String?) {
        NetworkManager.shared.fetch(type: CoinMarkets.self, next: url) { result in
            switch result {
            case .success(let loadMarket):
                self.markets = loadMarket
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSearch(from coin: String?) {
        NetworkManager.shared.fetch(type: CoinMarkets.self, coin: coin?.lowercased()) { result in
            switch result {
            case .success(let loadCoin):
                self.filterContentForSearchText(coin ?? "", loadCoin.markets)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func filterContentForSearchText(_ searchText: String, _ loadMarket: [MarketsInfo]) {
        filteredMarket = loadMarket.filter { market in
            market.baseAsset.uppercased() == searchText.uppercased()
        }
        tableView.reloadData()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
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
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

    // MARK: - Extension
extension MarketTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        fetchSearch(from: searchController.searchBar.text ?? "")
    }
    
    func fetchMarkets() {
        NetworkManager.shared.fetch(type: CoinMarkets.self) { result in
            switch result {
            case .success(let loadMarkets):
                self.markets = loadMarkets
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
