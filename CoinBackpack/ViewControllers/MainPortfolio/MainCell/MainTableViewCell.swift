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
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var purchaseLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var exchengeLabel: UILabel!
    @IBOutlet weak var symbolImage: UIImageView! {
        didSet {
            symbolImage.contentMode = .scaleAspectFit
            symbolImage.clipsToBounds = true
            symbolImage.layer.cornerRadius = symbolImage.frame.height / 2
            symbolImage.backgroundColor = .clear
        }
    }
    
    var viewModel: MainCellViewModelProtocol! {
        didSet {
            nameLabel.text = viewModel.name
            symbolLabel.text = viewModel.symbol
            exchengeLabel.text = viewModel.exchenge
            priceLabel.text = viewModel.price
            totalLabel.text = viewModel.total
            percentLabel.text = viewModel.percent
            purchaseLabel.text = viewModel.purchase
            symbolImage.image = UIImage(named: viewModel.image)
            
            profitСolorСhanges()
        }
    }
    
    private func profitСolorСhanges() {
        let percent = viewModel.percentFloat
        let purchase = viewModel.purchaseFloat
        
        if percent.sign == .minus, purchase.sign == .minus {
            self.percentLabel.textColor = .systemPink
            self.purchaseLabel.textColor = .systemPink
        } else {
            self.percentLabel.textColor = .systemMint
            self.purchaseLabel.textColor = .systemMint
        }
    }
}
