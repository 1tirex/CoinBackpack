//
//  DatailViewController.swift
//  CoinBackpack
//
//  Created by Илья on 24.11.2022.
//

import UIKit

class DatailViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var symbolImage: UIImageView!
    
    @IBOutlet var nameCoinLabel: UILabel!
    @IBOutlet var symbolCoinLabel: UILabel!
    @IBOutlet var exchangeCoinLabel: UILabel!
    @IBOutlet var priceCoinLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var buyPriceTF: UITextField!
    
    // MARK: - Properties
    var selectedCoins: MarketsInfo!
    var delegate: AddCoinViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(with: amountTF, .white, "Amount")
        configure(with: buyPriceTF, .white, "Buy Price")
        setupLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
    @IBAction func saveResult(_ sender: UIBarButtonItem) {
        if amountTF.text == "", buyPriceTF.text == "" {
            showAlert(stutus: .failed)
        } else {
            let coinInfo = MarketsInfo(name: nameCoinLabel.text ?? "NoName",
                                       totalPrice: totalLabel.text ?? "0.00$",
                                       amountCoins: amountTF.text ?? "0",
                                       buyPriceCoin: buyPriceTF.text ?? "0.00$",
                                       exchange: selectedCoins.exchange,
                                       symbol: selectedCoins.symbol,
                                       baseAsset: selectedCoins.baseAsset,
                                       quoteAsset: selectedCoins.quoteAsset,
                                       priceUnconverted: selectedCoins.priceUnconverted,
                                       price: selectedCoins.price,
                                       change24Hour: selectedCoins.change24Hour,
                                       spread: selectedCoins.spread,
                                       volume24Hour: selectedCoins.volume24Hour,
                                       status: selectedCoins.status,
                                       created: selectedCoins.created,
                                       updated: selectedCoins.updated)
            delegate.sendPostRequest(with: coinInfo)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func amountTFChanged(_ sender: UITextField) {
        if totalLabel.text == "" {
            totalLabel.text = "\(sender.text ?? "")$"
        } else if totalLabel.text != "", buyPriceTF.text != "", let _ = buyPriceTF.text?.isNumber {
            guard let buyPriceText = self.buyPriceTF.text,
                    let buyPrice = Double(buyPriceText) else { return }
            
            totalLabel.text = "\((Double(sender.text ?? "") ?? 0) * buyPrice)$"
        } else {
            totalLabel.text = "0.00$"
        }
    }
    
    @IBAction func buyPriceTFChanged(_ sender: UITextField) {
        if totalLabel.text == "" {
            totalLabel.text = "\(sender.text ?? "")$"
        } else if totalLabel.text != "", let _ = amountTF.text?.isNumber, amountTF.text != "" {
            guard let amountText = self.amountTF.text,
                    let amount = Double(amountText) else { return }
            
            totalLabel.text = "\((Double(sender.text ?? "") ?? 0) * amount)$"
        } else {
            totalLabel.text = "0.00$"
        }
    }
    
    // MARK: - Private methods
    private func configure(with TF: UITextField, _ color: UIColor, _ text: String) {
        TF.delegate = self
        TF.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor : color]
        )
    }
    
    private func setupLabels() {
        symbolImage.image = UIImage(named: selectedCoins.baseAsset.lowercased())
        symbolCoinLabel.text = selectedCoins.symbol
        exchangeCoinLabel.text  = selectedCoins.exchange
        priceCoinLabel.text = "\(selectedCoins.price)$"
    }
    
    private func showAlert(stutus: StutusAlert) {
            let alert = UIAlertController(
                title: stutus.title,
                message: stutus.message,
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
    }
    
    private func filterContentForCoin(_ coin: String, _ loadNames: [AssetsName]) {
        if loadNames.contains(where: { name in
            name.asset.uppercased() == coin.uppercased()}) {
            let filtered = loadNames.filter { name in
                name.asset.uppercased() == coin.uppercased()}
            nameCoinLabel.text = filtered.first?.name
        }
    }
}
// MARK: - Extension
extension DatailViewController {
    func fetchName(from coin: MarketsInfo?) {
        NetworkManager.shared.fetch(type: Assets.self,needFor: .nameCoin,
                                    coin: coin?.baseAsset.uppercased()) { [weak self] result in
            switch result {
            case .success(let loadCoin):
                self?.filterContentForCoin(coin?.baseAsset ?? "", loadCoin.assets)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

// MARK: - UITextFieldDelegate
extension DatailViewController: UITextFieldDelegate {
}


