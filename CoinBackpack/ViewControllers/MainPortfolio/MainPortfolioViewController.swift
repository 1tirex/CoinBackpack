//
//  MainViewController.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//

import UIKit

final class MainPortfolioViewController: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private Properties
    private var viewModel: MainPortfolioViewModelProtocol! {
        didSet {
            viewModel.fetchCoins { [unowned self] in
                tableView.reloadData()
            }
        }
    }
    
    // MARK: Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainPortfolioViewModel()
        
        setBackgroundColor()
        setupNavigationBar()
        setupTableView()
        
        viewModel.wallet.bind { [unowned self] wallet in
            self.walletLabel.text = wallet
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        coinsInPortfolio = StorageManager.shared.fetchCoins()
        tableView.reloadData()
//        reloadWallet()
    }
    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showMarkets" {
//            guard let marketVC = segue.destination as? SearchTableViewController else { return }
//            marketVC.fetchMarkets()
//        }
//    }
    
    // MARK: - IBAction
//    @IBAction func unwindToViewControllerPortfolio(segue: UIStoryboardSegue) {
//        tableView.reloadData()
//        reloadWallet()
//    }
    
    @IBAction func addCoinButtom() {
        tabBarController?.selectedIndex = 1
//        performSegue(withIdentifier: "showMarkets", sender: nil)
    }
    
    // MARK: - Private methods
    private func setBackgroundColor() {
        view.backgroundColor =
        UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.colorWith(name: Resources.Colors.background)
                ?? .systemBackground
            default:
                return UIColor.colorWith(name: Resources.Colors.secondaryBackground)
                ?? .systemGray6
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Coin BackPack 🎒"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func setupTableView() {
        tableView.rowHeight = 70
        tableView.dataSource = self
//        tableView.delegate = self
    }
    
//    private func reloadWallet() {
//        walletLabel.text = "0.00$"
//        
//        coinsInPortfolio.forEach { coin in
//            guard let totalPrice = coin.totalPrice,
//                  let gainMoney = coin.gainMoney else { return }
//            
//            let totalText = resetCharacter(for: totalPrice)
//            let moneyText = resetCharacter(for: gainMoney)
////            let walletText = resetCharacter(for: wallet)
//            
//            guard let total = Float(totalText),
//                  let money = Float(moneyText) else { return }
//            
//            var wallet: Float = 0
//                
//            wallet += (gainMoney.contains("-"))
//            ? ( total - money )
//            : ( total + money )
//            
//            walletLabel.text = "\(String(format: "%.2f", wallet))$"
//        }
//    }
    
//    private func resetCharacter(for text: String) -> String {
//        let newCharSet = CharacterSet.init(charactersIn: "-+$%")
//        return text.components(separatedBy: newCharSet).joined()
//    }
}

extension MainPortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection //coinsInPortfolio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        
        let coinOnMarket = viewModel.getCoin(indexPath) //coinsInPortfolio[indexPath.row]
        cell.configure(with: coinOnMarket)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            StorageManager.shared.deleteCoin(at: indexPath.row)
//            coinsInPortfolio.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            reloadWallet()
//        }
//    }
}
