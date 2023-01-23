//
//  MainViewController.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//

import UIKit

final class MainPortfolioViewController: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var purchaseLabel: UILabel!
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
            viewModel.fetchCoins {
                DispatchQueue.main.async { [unowned self] in
                    tableView.reloadData()
                }
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
        viewModel.fetchCoins { 
            DispatchQueue.main.async { [unowned self] in
                tableView.reloadData()
            }
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
        setupSortButton()
        
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
                    walletLabel.alpha = 0.5
                    walletLabel.text = wallet
                    walletLabel.textColor = UIColor.colorWith(name: viewModel.colorChangeWallet.value)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                    UIView.animate(withDuration: 0.5) { [unowned self] in
                        walletLabel.textColor = .label
                        walletLabel.alpha = 1
                    }
                })
            }
            //            reitingView.updateCirclePercentage(percent: viewModel.percent.value)
            //            reitingView.updateCirclePercentage(percent: 9)
            DispatchQueue.main.async { [unowned self] in
                tableView.reloadData()
            }
        }
        
        viewModel.purchase.bind { [unowned self] newValue in
            if purchaseLabel.text != newValue {
                UIView.animate(withDuration: 0.5) { [unowned self] in
                    purchaseLabel.alpha = 0.5
                    purchaseLabel.textColor = UIColor.colorWith(name: viewModel.colorChangeWallet.value)
                    purchaseLabel.text = newValue
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                    UIView.animate(withDuration: 0.5) { [unowned self] in
                        purchaseLabel.textColor = .label //purchaseLabel.text?.toFloat() ?? 0 > 0
                        //                        ? .systemMint
                        //                        : .systemPink
                        purchaseLabel.alpha = 1
                    }
                })
            }
        }
        
        viewModel.isTapped.bind { _ in
            DispatchQueue.main.async { [unowned self] in
                tableView.reloadData()
            }
        }
    }
    
    private func setupSortButton() {
        sortButton.layer.cornerRadius = 5
        sortButton.layer.borderColor = UIColor.colorWith(name: Resources.Colors.active)?.cgColor
        sortButton.layer.borderWidth = 1
        
        sortButton.tintColor = UIColor.colorWith(name: Resources.Colors.inActive)
        sortButton.backgroundColor = UIColor.colorWith(name: Resources.Colors.active)?.withAlphaComponent(0.3)
        
        sortButton.addTarget(self, action: #selector(tabSortButton), for: .touchUpInside)
    }
    
    @objc private func tabSortButton() {
        viewModel.tabSortButton()
    }
}

extension MainPortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRowsInSection == 0 {
            sortButton.isHidden = true
            return viewModel.numberOfRowsInSection
        } else {
            sortButton.isHidden = false
            return viewModel.numberOfRowsInSection
        }
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
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

extension MainPortfolioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
