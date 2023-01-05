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
        tableView.reloadData()
    }
    
    
    // MARK: - IBAction
//    @IBAction func unwindToViewControllerPortfolio(segue: UIStoryboardSegue) {
//        tableView.reloadData()
//        reloadWallet()
//    }
    
    @IBAction func addCoinButtom() {
        tabBarController?.selectedIndex = 1
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
}

extension MainPortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as? MainTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.viewModel = viewModel.getCoin(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteCoin(indexPath) {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
