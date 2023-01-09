//
//  MarketTableViewCell.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
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
    
    var viewModel: SearchCellViewModelProtocol! {
        didSet {
            symbolLabel.text = viewModel.symbol
            priceLabel.text = viewModel.price
            exchengeLabel.text = viewModel.exchange
            symbolImage.image = UIImage(named: viewModel.image)
        }
    }
}
