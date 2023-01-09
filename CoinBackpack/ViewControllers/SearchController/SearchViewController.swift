//
//  SearchViewController.swift
//  CoinBackpack
//
//  Created by Дмитрий Собин on 05.01.23.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private Properties
    private var viewModel: SearchViewModelProtocol! {
        didSet {
            viewModel.fetchData { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SearchViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        activityIndicator.startAnimating()
        //        fetchMarkets()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let datailVC = segue.destination as? DatailViewController else { return }
        datailVC.viewModel = sender as? DatailViewModelProtocol
    }
}

extension SearchViewController {
    // MARK: - Private methods
    private func setupUI() {
        setBackgroundColor()
        setupIndicator()
        setupTableView()
        setupSearchController()
        setupNavigationBar()
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
    
    private func setupIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = UIColor.colorWith(name: Resources.Colors.active)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupTableView() {
        tableView.rowHeight = 70
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Coin search"
//        searchController.searchBar.barTintColor = .green
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
            textField.layer.borderColor = UIColor.colorWith(name: Resources.Colors.active)?.cgColor
            textField.backgroundColor = UIColor.colorWith(name: Resources.Colors.active)?.withAlphaComponent(0.2)
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.namePage
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = view.backgroundColor
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.layer.borderColor = UIColor.colorWith(name: Resources.Colors.active)?.cgColor
        navigationController?.navigationBar.layer.borderWidth = 1
    }
}

// MARK:  UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(isFiltering)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as? SearchTableViewCell
        else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.getSearchCellViewModel(at: indexPath, isFiltering)
        return cell
    }
}

// MARK:  UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "addCoin", sender: viewModel.getDeteilViewModel(at: indexPath, isFiltering))
    }
}

// MARK:  UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        activityIndicator.startAnimating()
        guard let text = searchController.searchBar.text else { return }
        viewModel.searchResults(on: text) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
}
