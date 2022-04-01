//
//  HackerNewsTableViewCell.swift
//  ReignTest
//
//  Created by Pedro Valderrama on 30/03/2022.
//

import UIKit

class HackerNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setData(news: News) {
        titleLabel.font = CustomFont.setFontMedium(fontSize: 14)
        descriptionLabel.font = CustomFont.setFontMedium(fontSize: 12)
        
        titleLabel.text = news.titleComputed
        descriptionLabel.text = news.description
    }
    
}
