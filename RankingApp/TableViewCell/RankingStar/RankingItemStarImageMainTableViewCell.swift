//
//  RankingItemStarImageMainTableViewCell.swift
//  ShulRanking
//
//  Created by 佐々木英彦 on 2021/03/10.
//

import UIKit
import AMChart

class RankingItemStarImageMainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var rankingNumLabel: UILabel!
    @IBOutlet weak var rankingItemStarInfoView: RankingItemStarInfoView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // textViewの余白を詰める
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        
        cellTitleLabel.adjustsFontSizeToFitWidth = true
        
        // 左上と左下を角丸にする設定
        let path1 = UIBezierPath(roundedRect: rankingNumLabel.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 3.0, height: 3.0))
        let mask1 = CAShapeLayer()
        mask1.path = path1.cgPath
        rankingNumLabel.layer.mask = mask1
        
        let path2 = UIBezierPath(roundedRect: cellImageView.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 3.0, height: 3.0))
        let mask2 = CAShapeLayer()
        mask2.path = path2.cgPath
        cellImageView.layer.mask = mask2
        
//        // これやると影つかない(でもやらんと画像が丸くならない)
//        parentView.layer.masksToBounds = true
        // 影の設定
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        parentView.layer.shadowOffset = CGSize(width: 0.75, height: 1.0)
        // 影の色
        parentView.layer.shadowColor = ConstantsColor.REVERSE_SYSTEM_BACKGROUND_100.cgColor
        // 影の濃さ
        parentView.layer.shadowOpacity = 0.1
        // 影をぼかし
        parentView.layer.shadowRadius = 3
    }
    
    func setData(selectedIndexPath: Int, rankingViewModelData: RankingViewModel) {
        
        let rankinCellData: RankingCellViewModel = rankingViewModelData.rankingCellViewModelList[selectedIndexPath]
        // セルの各値をセットする
        rankingNumLabel.text = String(rankinCellData.num)
        
        let fontSize: CGFloat = 10.5
        
        // 順位に応じて順位ラベルのフォントと背景色を変更
        switch rankinCellData.num {
        
        case 1:
            rankingNumLabel.backgroundColor = ConstantsColor.RANKING_NUM_LABEL_BACKGROUND_1TH_65
            rankingNumLabel.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .semibold)
            
        case 2:
            rankingNumLabel.backgroundColor = ConstantsColor.RANKING_NUM_LABEL_BACKGROUND_2TH_65
            rankingNumLabel.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .semibold)
            
        case 3:
            rankingNumLabel.backgroundColor = ConstantsColor.RANKING_NUM_LABEL_BACKGROUND_3TH_65
            rankingNumLabel.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .semibold)
            
        default:
            rankingNumLabel.backgroundColor = ConstantsColor.RANKING_NUM_LABEL_BACKGROUND_OTHER_65
            rankingNumLabel.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .medium)
        }
        
        // TODO: 暫定対応。インデントつける
        cellTitleLabel.text = " " + rankinCellData.rankTitle + " "
        descriptionTextView.text = rankinCellData.rankDescription
        cellImageView.setImageViewRect(targetImage: rankinCellData.image, rect: rankinCellData.imageRect)
        
        // 星評価部分のviewにデータを設定
        rankingItemStarInfoView.setData(rankinCellData: rankinCellData, rankingViewModelData: rankingViewModelData)
    }
}
