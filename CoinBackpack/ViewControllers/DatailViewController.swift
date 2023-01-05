//
//  DatailViewController.swift
//  CoinBackpack
//
//  Created by Илья on 24.11.2022.
//

import UIKit

final class DatailViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var saveResult: UIBarButtonItem!
    @IBOutlet var symbolImage: UIImageView!
    
    @IBOutlet var nameCoinLabel: UILabel!
    @IBOutlet var symbolCoinLabel: UILabel!
    @IBOutlet var exchangeCoinLabel: UILabel!
    @IBOutlet var priceCoinLabel: UILabel!
    
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var buyPriceTF: UITextField!
    
    // MARK: - Properties
    var selectedCoins: Market!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTF.becomeFirstResponder()
        configureTF(with: amountTF, .lightGray, "Amount")
        configureTF(with: buyPriceTF, .lightGray, "Buy Price")
        
        setupLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    // MARK: - IBAction
    @IBAction func saveResults(_ sender: UIBarButtonItem) {
        if amountTF.text == "" || buyPriceTF.text == "" {
            showAlert(stutus: .failed)
        } else {
            guard let nameCoin = self.nameCoinLabel.text,
                  let total = self.totalLabel.text,
                  let amount = self.amountTF.text,
                  let buyPrice = self.buyPriceTF.text,
                  let percent = self.percentLabel.text,
                  let gainMoney = self.profitLabel.text else { return }

            let coinInfo = Coin(name: nameCoin,
                                symbol: selectedCoins.symbol,
                                baseAsset: selectedCoins.baseAsset,
                                quoteAsset: selectedCoins.quoteAsset,
                                imageCoin: selectedCoins.baseAsset,
                                exchange: selectedCoins.exchange,
                                price: selectedCoins.price,
                                amountCoins: Float(amount) ?? 0,
                                buyPriceCoin: Float(buyPrice) ?? 0)
//            Market(name: nameCoin,
//                                       totalPrice: total,
//                                       amountCoins: amount,
//                                       buyPriceCoin: buyPrice,
//                                       imageCoin: selectedCoins.baseAsset,
//                                       percent: percent,
//                                       gainMoney: gainMoney,
//                                       exchange: selectedCoins.exchange,
//                                       symbol: selectedCoins.symbol,
//                                       baseAsset: selectedCoins.baseAsset,
//                                       quoteAsset: selectedCoins.quoteAsset,
//                                    status: selectedCoins.status, priceUnconverted: selectedCoins.priceUnconverted,
//                                    price: selectedCoins.price,
//                                    change24Hour: selectedCoins.change24Hour,
//                                    spread: selectedCoins.spread,
//                                    volume24Hour: selectedCoins.volume24Hour,
//                                       created: selectedCoins.created,
//                                       updated: selectedCoins.updated)

            StorageManager.shared.save(coin: coinInfo)
            tabBarController?.selectedIndex = 0
//            delegate?.addCoinInPortfolio(with: coinInfo)
//            performSegue(withIdentifier: "unwindToPortfolio", sender: self)
//            navigationController?.popToRootViewController(animated: false)
        }
    }
    
    @IBAction func amountTFChanged(_ sender: UITextField) {
        if amountTF.text == "", buyPriceTF.text != "" {
            
            guard let buyPrice = buyPriceTF.text else { return }
            self.totalLabel.text = "\(buyPrice)$"
            profitСalculation(buy: buyPrice)
            self.saveResult.isEnabled = false
            
        } else if let _ = buyPriceTF.text?.isNumber,
                  buyPriceTF.text != "",
                  amountTF.text != "" {
            
            guard let buyPriceText = self.buyPriceTF.text,
                  let amtText = sender.text,
                  let buyPrice = Float(buyPriceText),
                  let amt = Float(amtText)  else { return }
            
            self.totalLabel.text = "\(amt * buyPrice)$"
            profitСalculation(amt: amtText, buy: buyPriceText)
            self.saveResult.isEnabled = !amtText.isEmpty
            
        } else {
            self.totalLabel.text = "0.00$"
            profitСalculation()
            self.saveResult.isEnabled = false
        }
        
    }
    
    @IBAction func buyPriceTFChanged(_ sender: UITextField) {
        if amountTF.text == "", buyPriceTF.text != "" {
            
            guard let buyPrice = sender.text else { return }
            self.totalLabel.text = "\(buyPrice)$"
            profitСalculation(buy: buyPrice)
            self.saveResult.isEnabled = false
            
        } else if let _ = amountTF.text?.isNumber,
                  amountTF.text != "",
                  buyPriceTF.text != "" {
            
            guard let amountText = self.amountTF.text,
                  let buyPriceText = sender.text,
                  let amount = Float(amountText),
                  let buy = Float(buyPriceText)  else { return }
            
            self.totalLabel.text = "\(buy * amount)$"
            profitСalculation(amt: amountText, buy: buyPriceText)
            self.saveResult.isEnabled = !buyPriceText.isEmpty
            
        } else {
            self.totalLabel.text = "0.00$"
            profitСalculation()
            self.saveResult.isEnabled = false
        }
    }
    
    // MARK: - Private methods
    private func configureTF(with TF: UITextField,
                             _ color: UIColor,
                             _ text: String) {
        TF.delegate = self
        TF.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor : color]
        )
    }
    
    private func setupLabels() {
        self.symbolImage.image = UIImage(named: selectedCoins.baseAsset.lowercased())
        self.symbolCoinLabel.text = selectedCoins.symbol
        self.exchangeCoinLabel.text  = selectedCoins.exchange
        self.priceCoinLabel.text = "\(String(format: "%.6f", selectedCoins.price))$"
        self.nameCoinLabel.text = selectedCoins.baseAsset
        self.percentLabel.text = ""
        self.profitLabel.text = ""
    }
    
    private func profitСalculation(amt amount: String = "", buy buyPrice: String = "") {
        if amount.isEmpty, !buyPrice.isEmpty {
            guard let price = Float(buyPrice) else { return }
            let percentage = price / selectedCoins.price
            let percent = (selectedCoins.price - price) / percentage
            let gainMoney = (selectedCoins.price - price)
            
            (percent.sign == .minus)
            ? (self.percentLabel.text = "\(String(format: "%.2f", percent))%")
            : (self.percentLabel.text = "+\(String(format: "%.2f", percent))%")
            
            (gainMoney.sign == .minus)
            ? (self.profitLabel.text = "\(String(format: "%.2f", gainMoney))$")
            : (self.profitLabel.text = "+\(String(format: "%.2f", gainMoney))$")
            
        } else if !amount.isEmpty, !buyPrice.isEmpty {
            guard let amt = Float(amount), let price = Float(buyPrice) else { return }
            
            let percentage = (amt * price) / selectedCoins.price
            let percent = (amt * selectedCoins.price - amt * price) / percentage
            let gainMoney = (selectedCoins.price - price) * amt
            
            (percent.sign == .minus)
            ? (self.percentLabel.text = "\(String(format: "%.2f", percent))%")
            : (self.percentLabel.text = "+\(String(format: "%.2f", percent))%")
            
            (gainMoney.sign == .minus)
            ? (self.profitLabel.text = "\(String(format: "%.2f", gainMoney))$")
            : (self.profitLabel.text = "+\(String(format: "%.2f", gainMoney))$")
        } else {
            self.percentLabel.text = ""
            self.profitLabel.text = ""
        }
        profitСolorСhanges()
    }
    
    private func profitСolorСhanges() {
        guard let percent = self.percentLabel.text,
                let gainMoney = self.profitLabel.text else { return }
        
        if percent.contains("-"), gainMoney.contains("-") {
            self.percentLabel.textColor = .systemPink
            self.profitLabel.textColor = .systemPink
        } else if percent.contains("+"), gainMoney.contains("+") {
            let rgba = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1.0)
            self.percentLabel.textColor = rgba
            self.profitLabel.textColor = rgba
        }
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
    
    private func filterContentForCoin(_ coin: String, _ loadNames: [AssetsCoin]) {
        if  loadNames.contains(where: { name in
            name.name.uppercased() == coin.uppercased()}) {
            
            let filtered = loadNames.filter { name in
                name.name.uppercased() == coin.uppercased()}
            self.nameCoinLabel.text = filtered.first?.name
            
        } else {
            self.nameCoinLabel.text = coin
        }
    }
}
// MARK: - Extension
extension DatailViewController {
    func fetchName(from coin: Market?) {
        NetworkManager.shared.fetch(
            type: Assets.self,
            needFor: .coinSearch,
            coin: coin?.baseAsset.uppercased()) { [weak self] result in
                switch result {
                case .success(let loadName):
                    self?.filterContentForCoin(
                        coin?.baseAsset ?? "",
                        loadName.assets ?? []) // incorrect
                case .failure(let error):
                    print(error)
                }
            }
    }
}

// MARK: - UITextFieldDelegate
extension DatailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.isEmpty, buyPriceTF.text == "" {
            self.totalLabel.text = "0.00$"
            profitСalculation()
        }
    }
}

extension String  {
    var isNumber: Bool {
        !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
