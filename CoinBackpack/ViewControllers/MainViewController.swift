//
//  MainViewController.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//

import UIKit

protocol AddCoinViewControllerDelegate {
    func sendPostRequest(with data: MarketsInfo)
}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var walletLabel: UILabel!
    private var addCoin: [MarketsInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        
        tableView.dataSource = self
        setupNavigationBar()
    }
    
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMarkets" {
                guard let marketVC = segue.destination as? MarketTableViewController else { return }
            marketVC.fetchMarkets()
            marketVC.delegate = self
        }
    }
    
    // MARK: - IBAction
    @IBAction func addCoinButtom() {
        performSegue(withIdentifier: "showMarkets", sender: nil)
    }
    
    // MARK: - Private methods
    private func setupNavigationBar() {
        self.navigationItem.title = "Coin BackPack 🎒"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addCoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MarketTableViewCell
        
        let coinOnMarket = addCoin[indexPath.row]
        cell.configure(with: coinOnMarket)
        return cell
    }
}

extension MainViewController: AddCoinViewControllerDelegate {
    func sendPostRequest(with data: MarketsInfo) {

        self.addCoin.append(data)
        self.tableView.reloadData()

        NetworkManager.shared.sendPostRequest(from: .postRequest, with: data ) { result in
            switch result {
            case .success(let coin):
                self.addCoin.append(coin)
                self.tableView.insertRows(
                    at: [IndexPath(row: (self.addCoin.count ) - 1, section: 0)],
                    with: .automatic
                )
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
