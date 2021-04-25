//
//  HomeHeaderHorizonalNormalCollectionViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/11/22.
//

import UIKit

/// ホーム画面横スクロール部分のcell
/// mainImageをセルに表示する
class HomeHeaderHorizonalNormalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var majorTitleLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var existNumLabel: UILabel!
    @IBOutlet weak var majorTitleLabelBackGradationView: GradationView!
    @IBOutlet weak var gradationViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        kindLabel.adjustsFontSizeToFitWidth = true
        kindLabel.textColor = UIColor.white
        
        majorTitleLabelBackGradationView.setGradation()
        
        // テーマカラーによってgradationViewのHeightを設定
        setGradationViewHeight()
    }
    
    func setNotificationCell(imageUrl: [String : String]) {
        
        majorTitleLabel.isHidden = true
        createDateLabel.isHidden = true
        existNumLabel.isHidden = true
        majorTitleLabelBackGradationView.isHidden = true
        
        kindLabel.text = Constants.NOTIFICATION
        kindLabel.backgroundColor = ConstantsColor.WATER_75
        
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.setImageUrl(urlD: imageUrl[Constants.URL_D]!, urlL: imageUrl[Constants.URL_L]!)
    }
    
    func setRankingCell(rankingViewModel: RankingViewModel) {
        
        majorTitleLabel.isHidden = false
        createDateLabel.isHidden = false
        existNumLabel.isHidden = false
        majorTitleLabelBackGradationView.isHidden = false
        
        kindLabel.text = Constants.ORIGINAL
        kindLabel.backgroundColor = ConstantsColor.OFFICIAL_ORANGE_70
        
        majorTitleLabel.text = rankingViewModel.mainTitle
        
        mainImageView.contentMode = .scaleAspectFill
        
        if let image = rankingViewModel.mainImage {
            
            mainImageView.setImageViewRect(targetImage: image, rect: rankingViewModel.mainImageRect)
            
        } else {
            
            mainImageView.image = Constants.LOGO_ICON_IMAGE
        }
        
        createDateLabel.text = String(rankingViewModel.idDate.prefix(10)) + "〜"
        existNumLabel.text = "〜" + String(RankingUtil.getExistDataIndex(rankingCellViewModelList: rankingViewModel.rankingCellViewModelList)) + "th"
    }
    
    /// テーマカラーによってgradationViewのHeightを設定
    private func setGradationViewHeight() {
        
        if #available(iOS 13.0, *), OtherUtil.getTopViewController()?.traitCollection.userInterfaceStyle == .dark {
            
            gradationViewHeightConstraint.constant = 150
            
        } else {
            
            gradationViewHeightConstraint.constant = 75
        }
    }
}
