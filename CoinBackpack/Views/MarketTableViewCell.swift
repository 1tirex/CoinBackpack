//
//  MarketTableViewCell.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//

import UIKit

final class MarketTableViewCell: UITableViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
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
    
    func configure(with coin: Market?) {
        self.symbolLabel.text = coin?.symbol
        self.priceLabel.text = "\(String(format: "%.6f", coin?.price ?? 0))$"
        self.exchengeLabel.text = coin?.exchange
        self.symbolImage.image = UIImage(named: coin?.baseAsset.lowercased() ?? "")
    }
}
