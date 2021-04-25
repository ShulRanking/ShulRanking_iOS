//
//  GoogleSearchImageAPICollectionViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/08/16.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class GoogleSearchImageAPICollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var googleImageView: UIImageView!
    
    func setData(imageView: UIImage, isFit: Bool) {
        
        googleImageView.image = imageView
        
        googleImageView.contentMode = isFit ? .scaleAspectFit : .scaleAspectFill
    }
}
