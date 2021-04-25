//
//  HomeHeaderHorizonalItemsCollectionViewICell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/11/24.
//

import UIKit

/// ホーム画面横スクロール部分のcell
/// 20個の順位の画像をセルに表示する
class HomeHeaderHorizonalItemsCollectionViewICell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var majorTitleLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var existNumLabel: UILabel!
    @IBOutlet weak var majorTitleLabelBackGradationView: GradationView!
    @IBOutlet weak var gradationViewHeightConstraint: NSLayoutConstraint!
    
    private var imageViewList: [UIImageView] = []
    
    /// 初期化処理
    private lazy var setup: (() -> Void)? = {
        
        majorTitleLabel.adjustsFontSizeToFitWidth = true
        
        kindLabel.adjustsFontSizeToFitWidth = true
        kindLabel.text = Constants.ORIGINAL
        
        majorTitleLabelBackGradationView.setGradation()
        
        // テーマカラーによってgradationViewのHeightを設定
        setGradationViewHeight()
        
        // 各順位画像を保持する[UIImageVIew]を作成し、配置
        let verticalCount: Int = 4
        let horizonalCount: Int = 5
        
        let imageViewWidth: CGFloat = frame.width / CGFloat(horizonalCount)
        let imageViewHeight: CGFloat = frame.height / CGFloat(verticalCount)
        
        for verticalIndex in 0 ..< verticalCount {
            
            for horizonalIndex in 0 ..< horizonalCount {
                
                let imageView = UIImageView(
                    frame: CGRect(x: imageViewWidth * CGFloat(horizonalIndex),
                                  y: frame.height - imageViewHeight * CGFloat(verticalIndex + 1),
                                  width: imageViewWidth,
                                  height: imageViewHeight))
                
                // 枠を角丸にする
                imageView.layer.cornerRadius = 3.0
                imageView.layer.masksToBounds = true
                imageView.contentMode = .scaleAspectFill
                
                mainImageView.addSubview(imageView)
                imageViewList.append(imageView)
            }
        }
        
        return nil
    }()
    
    func setData(rankingViewModel: RankingViewModel) {
        
        // 初期化(2回目以降はnilになり呼ばれない)
        setup?()
        
        majorTitleLabel.text = rankingViewModel.mainTitle
        
        if let image = rankingViewModel.mainImage {
            
            mainImageView.setImageViewRect(targetImage: image, rect: rankingViewModel.mainImageRect)
            
        } else {
            
            mainImageView.image = Constants.LOGO_ICON_IMAGE
        }
        
        createDateLabel.text = String(rankingViewModel.idDate.prefix(10)) + "〜"
        existNumLabel.text = "〜" + String(RankingUtil.getExistDataIndex(rankingCellViewModelList: rankingViewModel.rankingCellViewModelList)) + "th"
    
        // 画像が入っている項目を取得
        var existImageList = [UIImage]()
        for rankingCellViewModel in rankingViewModel.rankingCellViewModelList {
            
            if let image = rankingCellViewModel.image {
                
                existImageList.append(image)
            }
        }
        
        // シャッフル
        existImageList.shuffle()
        
        for index in imageViewList.indices {
            
            if index < existImageList.count {
                
                imageViewList[index].image = existImageList[index]
                
            } else {
                
                imageViewList[index].image = nil
            }
        }
    }
    
    /// テーマカラーによってgradationViewのHeightを設定
    private func setGradationViewHeight() {
        
        if #available(iOS 13.0, *), OtherUtil.getTopViewController()?.traitCollection.userInterfaceStyle == .dark {
            
            gradationViewHeightConstraint.constant = 150
            
        } else {
            
            gradationViewHeightConstraint.constant = 90
        }
    }
}
