//
//  MarketTableViewCell.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//

import UIKit

class MarketTableViewCell: UITableViewCell {
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var exchengeLabel: UILabel!
    @IBOutlet var symbolImage: UIImageView! {
        didSet {
            symbolImage.contentMode = .scaleAspectFit
            symbolImage.clipsToBounds = true
            symbolImage.layer.cornerRadius = symbolImage.frame.height / 2
            symbolImage.backgroundColor = .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with course: MarketsInfo?) {
        symbolLabel.text = course?.symbol
        priceLabel.text = "\(course?.price ?? 0)$"
        exchengeLabel.text = course?.exchange
        symbolImage.image = UIImage(named: course?.baseAsset.lowercased() ?? "")
    }
}
