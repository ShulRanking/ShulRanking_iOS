//
//  PageCollectionViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/10/19.
//

import UIKit

/// ページャーのタイトルを表示するcell
class PageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pageTitleLabel: UILabel!
    
    func setData(pageTitle: String) {
        
        pageTitleLabel.text = pageTitle
    }
}
