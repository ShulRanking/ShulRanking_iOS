//
//  HomeCollectionViewLabelCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/09/15.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class HomeCollectionViewLabelCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.text = Constants.ORIGINAL_RANKING
    }
}
