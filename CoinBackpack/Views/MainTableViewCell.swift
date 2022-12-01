//
//  MainTableViewCell.swift
//  CoinBackpack
//
//  Created by Илья on 26.11.2022.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var exchengeLabel: UILabel!
    @IBOutlet weak var symbolImage: UIImageView! {
        didSet {
            symbolImage.contentMode = .scaleAspectFit
            symbolImage.clipsToBounds = true
            symbolImage.layer.cornerRadius = symbolImage.frame.height / 2
            symbolImage.backgroundColor = .black
        }
    }
    
    func configure(with coin: MarketsInfo?) {
        self.nameLabel.text = coin?.name
        self.priceLabel.text = "\(String(format: "%.3f", coin?.price ?? 0))$"
        self.symbolLabel.text = coin?.symbol
        self.exchengeLabel.text = coin?.exchange
        self.totalLabel.text = "\(String(format: "%.2f", convertToNumber(coin?.totalPrice)))$"
        self.profitLabel.text = "\(String(format: "%.2f", convertToNumber(coin?.percent)))%"
        self.gainLabel.text = "\(String(format: "%.2f", convertToNumber(coin?.gainMoney)))$"
        self.symbolImage.image = UIImage(named: coin?.baseAsset.lowercased() ?? "")
        
        profitСolorСhanges(with: coin)
    }
    
    private func convertToNumber(_ text: String?) -> Float {
        let newCharSet = CharacterSet.init(charactersIn: "-+$%")
                    
        guard let numberText = text?.components(separatedBy: newCharSet).joined(),
                let number = Float(numberText) else { return 0}
        
        return number
    }
    
    private func profitСolorСhanges(with coin: MarketsInfo?) {
        guard let percent = coin?.percent,
                let gainMoney = coin?.gainMoney else { return }

        if percent.contains("-"), gainMoney.contains("-") {
            self.profitLabel.textColor = .systemPink
            self.gainLabel.textColor = .systemPink
            
        } else if percent.contains("+"), gainMoney.contains("+") {
            let rgba = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1.0)
            self.profitLabel.textColor = rgba
            self.gainLabel.textColor = rgba
        }
    }
    
}
