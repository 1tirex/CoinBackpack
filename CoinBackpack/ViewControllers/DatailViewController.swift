//
//  DatailViewController.swift
//  CoinBackpack
//
//  Created by Илья on 24.11.2022.
//

import UIKit

final class DatailViewController: UIViewController {
    
    // MARK: - IBOutlet
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
    var selectedCoins: MarketsInfo!
    var delegate: AddCoinViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTF(with: amountTF, .white, "Amount")
        configureTF(with: buyPriceTF, .white, "Buy Price")
        
        setupLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    // MARK: - IBAction
    @IBAction func saveResult(_ sender: UIBarButtonItem) {
        if amountTF.text == "" || buyPriceTF.text == "" {
            showAlert(stutus: .failed)
        } else {
            guard let nameCoin = self.nameCoinLabel.text,
                  let total = self.totalLabel.text,
                  let amount = self.amountTF.text,
                  let buyPrice = self.buyPriceTF.text,
                  let percent = self.percentLabel.text,
                  let gainMoney = self.profitLabel.text else { return }
            
            let coinInfo = MarketsInfo(name: nameCoin,
                                       totalPrice: total,
                                       amountCoins: amount,
                                       buyPriceCoin: buyPrice,
                                       imageCoin: selectedCoins.baseAsset,
                                       percent: percent,
                                       gainMoney: gainMoney,
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
            delegate?.addCoinInPortfolio(with: coinInfo)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func amountTFChanged(_ sender: UITextField) {
        if amountTF.text == "", buyPriceTF.text != "" {
            self.totalLabel.text = "\(buyPriceTF.text ?? "")$"
            profitСalculation(buy: buyPriceTF.text ?? "")
        } else if let _ = buyPriceTF.text?.isNumber,
                    buyPriceTF.text != "",
                    amountTF.text != "" {
            
            guard let buyPriceText = self.buyPriceTF.text,
                  let buyPrice = Double(buyPriceText),
                  let amt = Double(sender.text ?? "")  else { return }
            
            self.totalLabel.text = "\(amt * buyPrice)$"
            profitСalculation(amt: sender.text ?? "", buy: buyPriceText)
        } else {
            self.totalLabel.text = "0.00$"
            profitСalculation()
        }
    }
    
    @IBAction func buyPriceTFChanged(_ sender: UITextField) {
        if amountTF.text == "", buyPriceTF.text != "" {
            self.totalLabel.text = "\(sender.text ?? "")$"
            profitСalculation(buy: sender.text ?? "")
        } else if let _ = amountTF.text?.isNumber,
                    amountTF.text != "",
                    buyPriceTF.text != "" {
            guard let amountText = self.amountTF.text,
                  let amount = Double(amountText),
                  let buy = Double(sender.text ?? "")  else { return }
            
            self.totalLabel.text = "\(buy * amount)$"
            profitСalculation(amt: amountText, buy: sender.text ?? "")
        } else {
            self.totalLabel.text = "0.00$"
            profitСalculation()
        }
    }
    
    // MARK: - Private methods
    private func configureTF(with TF: UITextField, _ color: UIColor, _ text: String) {
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
        self.priceCoinLabel.text = "\(selectedCoins.price)$"
        self.nameCoinLabel.text = selectedCoins.baseAsset
        self.percentLabel.text = ""
        self.profitLabel.text = ""
    }
    
    private func profitСalculation(amt amount: String = "", buy buyPrice: String = "") {
//        if amount.isEmpty, buyPrice.isEmpty {
//            self.percentLabel.text = ""
//            self.profitLabel.text = ""
//        } else if !amount.isEmpty, buyPrice.isEmpty {
//            self.percentLabel.text = ""
//            self.profitLabel.text = ""
//        } else
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
    
    private func filterContentForCoin(_ coin: String, _ loadNames: [AssetsName]) {
        if loadNames.contains(where: { name in
            name.asset.uppercased() == coin.uppercased()}) {
            let filtered = loadNames.filter { name in
                name.asset.uppercased() == coin.uppercased()}
            self.nameCoinLabel.text = filtered.first?.name
        } else {
            self.nameCoinLabel.text = coin
        }
    }
}
// MARK: - Extension
extension DatailViewController {
    func fetchName(from coin: MarketsInfo?) {
        NetworkManager.shared.fetch(type: Assets.self,
                                    needFor: .nameCoin,
                                    coin: coin?.baseAsset.uppercased()) { [weak self] result in
            switch result {
            case .success(let loadName):
                self?.filterContentForCoin(coin?.baseAsset ?? "",
                                           loadName.assets)
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
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
