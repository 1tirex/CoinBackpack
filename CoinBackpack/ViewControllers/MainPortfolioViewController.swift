//
//  MainViewController.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//

import UIKit

protocol AddCoinViewControllerDelegate {
    func addCoinInPortfolio(with data: MarketsInfo)
}

final class MainPortfolioViewController: UIViewController {
    
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
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    func reloadWallet(with data: MarketsInfo) {
        let numericCharSet = CharacterSet.init(charactersIn: "1234567890")
        let newCharSet = CharacterSet.init(charactersIn: "-+$%")
        guard let totalPrice = data.totalPrice,
              let gainMoney = data.gainMoney,
              let wallet = walletLabel.text
        else {
            return
        }
        
        if let _ = totalPrice.rangeOfCharacter(from: numericCharSet),
            let _ = gainMoney.rangeOfCharacter(from: numericCharSet) {
            
            let totalText = totalPrice.components(separatedBy: newCharSet).joined()
            let moneyText = gainMoney.components(separatedBy: newCharSet).joined()
            let walletText = wallet.components(separatedBy: newCharSet).joined()
            
            guard var wallet = Float(walletText),
                  let total = Float(totalText),
                  let money = Float(moneyText)
            else {
                return
            }
            
            (gainMoney.contains("-"))
            ? (wallet -= total - money)
            : (wallet += total + money)
            
            self.walletLabel.text = "\(wallet)$"
        } else {
            self.walletLabel.text = "0.00$"
        }
    }
}

extension MainPortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addCoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        
        let coinOnMarket = addCoin[indexPath.row]
        cell.configure(with: coinOnMarket)
        
        return cell
    }
}

extension MainPortfolioViewController: AddCoinViewControllerDelegate {
    
    func addCoinInPortfolio(with data: MarketsInfo) {
        self.addCoin.append(data)
        self.tableView.reloadData()
        
        reloadWallet(with: data)
    }
}
