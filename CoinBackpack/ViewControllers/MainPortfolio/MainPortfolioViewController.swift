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
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.layer.cornerRadius = 10
            addButton.backgroundColor = UIColor.colorWith(name: Resources.Colors.active)
        }
    }
    
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
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCoins { [unowned self] in
            tableView.reloadData()
        }
    }
    
    @IBAction func addCoinButtom() {
        tabBarController?.selectedIndex = 1
    }
}

extension MainPortfolioViewController {
    // MARK: - Private methods
    private func setupUI() {
        setBackgroundColor()
        setupNavigationBar()
        setupTableView()
        
        setupBind()
    }
    
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
        navigationItem.title = viewModel.namePage
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func setupTableView() {
        tableView.rowHeight = 70
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupBind() {
        viewModel.wallet.bind { [unowned self] wallet in
            if wallet != walletLabel.text {
                UIView.animate(withDuration: 0.5) { [unowned self] in
                    walletLabel.textColor = UIColor.colorWith(name: viewModel.colorChangeWallet.value)
                    walletLabel.alpha = 0.5
                    walletLabel.text = wallet
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    UIView.animate(withDuration: 0.5) { [unowned self] in
                        walletLabel.textColor = .label
                        walletLabel.alpha = 1
                    }
                })
            }
        }
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

extension MainPortfolioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
