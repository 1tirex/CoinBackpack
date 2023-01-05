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
    
    func configure(with coin: Coin) {
        self.nameLabel.text = coin.name
        self.symbolLabel.text = coin.symbol
        self.exchengeLabel.text = coin.exchange
        self.priceLabel.text = "\(String(format: "%.2f", coin.price ))$"
        self.totalLabel.text = "\(String(format: "%.2f", coin.totalPrice))$"
        self.profitLabel.text = "\(String(format: "%.2f", (coin.price - coin.purchase) / (coin.purchase / coin.price)))%"
        self.gainLabel.text = "\(String(format: "%.2f", coin.price - coin.purchase))$"
        self.symbolImage.image = UIImage(named: coin.baseAsset.lowercased())
        
        profitСolorСhanges(with: coin)
    }
    
    private func profitСolorСhanges(with coin: Coin) {
        let percent = (coin.price - coin.purchase) / (coin.purchase / coin.price)
        let profit = coin.price - coin.purchase

        if percent.sign == .minus, profit.sign == .minus {
            self.profitLabel.textColor = .systemPink
            self.gainLabel.textColor = .systemPink
        } else {
            self.profitLabel.textColor = .systemMint
            self.gainLabel.textColor = .systemMint
        }
    }
}
