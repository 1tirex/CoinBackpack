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
    
    func configure(with course: MarketsInfo?) {
        self.symbolLabel.text = course?.symbol
        self.priceLabel.text = "\(String(format: "%.6f", course?.price ?? 0))$"
        self.exchengeLabel.text = course?.exchange
        self.symbolImage.image = UIImage(named: course?.baseAsset.lowercased() ?? "")
    }
}
