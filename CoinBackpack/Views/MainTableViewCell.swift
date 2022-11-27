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
    
    func configure(with course: MarketsInfo?) {
        self.nameLabel.text = course?.name
        self.totalLabel.text = course?.totalPrice
        self.symbolLabel.text = course?.symbol
        self.priceLabel.text = "\(course?.price ?? 0)$"
        self.exchengeLabel.text = course?.exchange
        self.profitLabel.text = course?.percent
        self.gainLabel.text = course?.gainMoney
        self.symbolImage.image = UIImage(named: course?.baseAsset.lowercased() ?? "")
        
        profitСolorСhanges()
    }
    
    private func profitСolorСhanges() {
        guard let percent = self.profitLabel.text,
                let gainMoney = self.gainLabel.text else { return }

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
