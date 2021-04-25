//
//  NotificationTableViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/11/03.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var ribbonLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainImageView.layer.borderColor = UIColor.lightGray.cgColor
        mainImageView.layer.borderWidth = 0.25
    }
    
    func setData(index: Int, ribbon: String, text: String) {
        
        ribbonLabel.text = "  " + ribbon + "  "
        descriptionLabel.text = text
        
        switch ribbon {
        case Constants.INTRODUCTION:
            ribbonLabel.backgroundColor = ConstantsColor.INTRODUCTION_75
            
        case Constants.NEW_NOTIFICATION:
            ribbonLabel.backgroundColor = ConstantsColor.NEW_FUNCTION_75
            
        case Constants.GREETING:
            ribbonLabel.backgroundColor = ConstantsColor.OFFICIAL_ORANGE_70
            
        default:
            break
        }
    }
}
