//
//  SettingEntryTableViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/11/17.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class SettingEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    
    func setData(index: Int, text: String, image: UIImage) {
        
        leftImageView.image = image
        titleLabel.text = text
        
        if text == "バージョン" {
            
            rightImage.isHidden = true
            rightLabel.isHidden = false
            rightLabel.text = Constants.APP_VERSION
            
        } else {
            
            rightImage.isHidden = false
            rightLabel.isHidden = true
        }
    }
}
