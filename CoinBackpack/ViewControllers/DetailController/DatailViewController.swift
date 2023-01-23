//
//  DatailViewController.swift
//  CoinBackpack
//
//  Created by Илья on 24.11.2022.
//

import UIKit

final class DatailViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet var saveResult: UIBarButtonItem!
    @IBOutlet weak var symbolImage: UIImageView! {
        didSet {
            symbolImage.contentMode = .scaleAspectFit
            symbolImage.clipsToBounds = true
            symbolImage.layer.cornerRadius = symbolImage.frame.height / 2
            symbolImage.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var nameCoinLabel: UILabel!
    @IBOutlet weak var symbolCoinLabel: UILabel!
    @IBOutlet weak var exchangeCoinLabel: UILabel!
    @IBOutlet weak var priceCoinLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var buyPriceTF: UITextField!
    
    // MARK: Properties
    var viewModel: DatailViewModelProtocol!
    
    // MARK: Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: IBAction
    @IBAction func saveResults(_ sender: UIBarButtonItem) {
        if amountTF.text == "" || buyPriceTF.text == "" {
            showAlert(stutus: .failed)
        } else {
            viewModel.saveResults { [unowned self] in
                tabBarController?.selectedIndex = 0
                navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension DatailViewController {
    // MARK: Private methods
    private func setupUI() {
        saveResult.isEnabled = false
        setBackgroundColor()
        setupLabels()
        
        amountTF.becomeFirstResponder()
        configureTF(with: amountTF, placeholder: "Amount")
        configureTF(with: buyPriceTF, placeholder: "Purchase")
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
    
    private func configureTF(with TF: UITextField, placeholder: String) {
        TF.delegate = self
        TF.placeholder = placeholder
        TF.layer.borderColor = UIColor.colorWith(name: Resources.Colors.active)?.cgColor
        TF.layer.borderWidth = 1
        TF.layer.cornerRadius = 10
        TF.backgroundColor = UIColor.colorWith(name: Resources.Colors.active)?.withAlphaComponent(0.2)
        TF.layer.masksToBounds = true
    }
    
    private func setupLabels() {
        symbolImage.image = UIImage(named: viewModel.image)
        symbolCoinLabel.text = viewModel.symbol
        exchangeCoinLabel.text  = viewModel.exchange
        priceCoinLabel.text = viewModel.price
        nameCoinLabel.text = viewModel.name.value
        totalLabel.text = viewModel.total.value
        percentLabel.text = viewModel.percent.value
        profitLabel.text = viewModel.profit.value
    }
    
    private func setupBind() {
        viewModel.name.bind { [unowned self] newValue in
            nameCoinLabel.text = newValue
        }
        
        viewModel.profit.bind { [unowned self] newValue in
            profitLabel.text = newValue
            
        }
        
        viewModel.percent.bind { [unowned self] newValue in
            percentLabel.text = newValue
        }
        
        viewModel.total.bind { [unowned self] newValue in
            totalLabel.text = newValue
            profitСolorСhanges()
            saveResult.isEnabled = viewModel.statusIsEnabled
        }
    }
    
    private func profitСolorСhanges() {
        guard let percent = self.percentLabel.text,
              let profit = self.profitLabel.text else { return }
        
        if percent.contains("-"), profit.contains("-") {
            self.percentLabel.textColor = .systemPink
            self.profitLabel.textColor = .systemPink
        } else {
            self.percentLabel.textColor = .systemMint
            self.profitLabel.textColor = .systemMint
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
}

// MARK: - UITextFieldDelegate
extension DatailViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        switch textField {
        case amountTF:
            viewModel.getText(from: text, .amount)
        case buyPriceTF:
            viewModel.getText(from: text, .purchase)
        default:
            print("text field text error")
        }

        if viewModel.purchase.value.isZero {
            profitLabel.isHidden = true
            percentLabel.isHidden = true
            totalLabel.isHidden = true
        } else {
            profitLabel.isHidden = false
            percentLabel.isHidden = false
            totalLabel.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let newCharSet = CharacterSet.init(charactersIn: "!@#$%^&*(){},?/|[]§±<>-_=+'")
        textField.text = text.components(separatedBy: newCharSet).joined(separator: ".")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldChange : Bool = true
        let newCharSet = CharacterSet.init(charactersIn: "!@#$%^&*(){},?/|[]§±<>-_=+'")
        let numberString = (textField.text ?? "")
            .replacingOccurrences(of: ",", with: ".")
            .components(separatedBy: newCharSet).joined(separator: ".")
        guard let character = string.first else { return true }

            if character == ".", !numberString.contains("."), !numberString.isEmpty {
                shouldChange = true
            } else if character.isNumber {
                shouldChange = true
            } else {
                shouldChange = false
            }
        return shouldChange
    }
}
