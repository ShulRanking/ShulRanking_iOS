//
//  CollectionViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/08/13.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: HomeCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        
        // imageViewロングタップ時のアクションを設定
        let pressLongGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(imageViewLongPressed))
        mainImageVIew?.addGestureRecognizer(pressLongGestureRecognizer)
    }
    
    func setData(rankingViewModel: RankingViewModel) {
        
        titleLabel.text = rankingViewModel.mainTitle
        
        if let image = rankingViewModel.mainImage {
            
            mainImageVIew.setImageViewRect(targetImage: image, rect: rankingViewModel.mainImageRect)
            
        } else {
            
            mainImageVIew.image = Constants.LOGO_ICON_IMAGE
        }
    }
    
    /// 長押し時
    @objc func imageViewLongPressed() {
        
        delegate?.homeCollectionViewCellLongTapped(cell: self)
    }
}

protocol HomeCollectionViewCellDelegate {
    
    func homeCollectionViewCellLongTapped(cell: HomeCollectionViewCell) -> ()
}
