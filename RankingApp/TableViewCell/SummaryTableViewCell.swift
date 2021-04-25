//
//  SummaryTableViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/08/28.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enterIconImageView: UIImageView!
    
    func setData(rankingViewModel: RankingViewModel, isHiddenEnterIcon: Bool) {
        
        // セルの各値をセットする
        titleLabel.text = rankingViewModel.mainTitle
        enterIconImageView.isHidden = isHiddenEnterIcon
        
        if let image = rankingViewModel.mainImage {
            
            mainImageView.setImageViewRect(targetImage: image, rect: rankingViewModel.mainImageRect)
            
        } else {
            
            mainImageView.image = Constants.LOGO_ICON_IMAGE
        }
    }
}
