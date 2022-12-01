//
//  MainViewController.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//

import UIKit

//protocol AddCoinViewControllerDelegate {
//    func addCoinInPortfolio(with data: MarketsInfo)
//}

final class MainPortfolioViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var walletLabel: UILabel!
    
    private var coinsInPortfolio: [MarketsInfo] = [] {
        didSet {
            coinsInPortfolio = coinsInPortfolio.sorted {$0.totalPrice ?? "" < $1.totalPrice ?? ""}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.dataSource = self
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coinsInPortfolio = StorageManager.shared.fetchCoins()
        self.tableView.reloadData()
        reloadWallet()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMarkets" {
            guard let marketVC = segue.destination as? MarketTableViewController else { return }
            marketVC.fetchMarkets()
//            marketVC.delegate = self
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
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    func reloadWallet() {
        let newCharSet = CharacterSet.init(charactersIn: "-+$%")
        walletLabel.text = "0.00$"
        
        coinsInPortfolio.forEach { coin in
            guard let totalPrice = coin.totalPrice,
                  let gainMoney = coin.gainMoney,
                  let wallet = walletLabel.text else { return }
            
            let totalText = totalPrice.components(separatedBy: newCharSet).joined()
            let moneyText = gainMoney.components(separatedBy: newCharSet).joined()
            let walletText = wallet.components(separatedBy: newCharSet).joined()
            
            guard var wallet = Float(walletText),
                  let total = Float(totalText),
                  let money = Float(moneyText) else { return }
            
            (gainMoney.contains("-"))
            ? (wallet += total - money)
            : (wallet += total + money)
            
            self.walletLabel.text = "\(String(format: "%.2f", wallet))$"
        }
    }
}

extension MainPortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coinsInPortfolio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        
        let coinOnMarket = coinsInPortfolio[indexPath.row]
        cell.configure(with: coinOnMarket)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.deleteCoin(at: indexPath.row)
            coinsInPortfolio.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            reloadWallet()
        }
    }
}

//extension MainPortfolioViewController: AddCoinViewControllerDelegate {
//
//    func addCoinInPortfolio(with data: MarketsInfo) {
//        self.coinsInPortfolio.append(data)
//        self.tableView.reloadData()
//
//        reloadWallet()
//    }
//}
