//
//  SettingSegmentedSearchCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/12/01.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class SettingSegmentedSearchCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 選択時の文字色を白に設定
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
    }
    
    func setData(text: String, image: UIImage) {
        
        leftImageView.image = image
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = text
        
        segmentedControl.selectedSegmentIndex = WebImageType.getNowWebImageType().getIndex()
    }
    
    @IBAction func TappedSegment(_ sender: Any) {
        
        Constants.USER_DEFAULTS_STANDARD.set(WebImageType.getWebImageTypeForIndex(index: segmentedControl.selectedSegmentIndex).rawValue,
                                             forKey: Constants.SEARCH_ENGINE)
        
        LogUtil.logAnalytics(logName: "SetVC_SearchEngine")
    }
}
