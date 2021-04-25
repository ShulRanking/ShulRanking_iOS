//
//  CreateEditTableViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/16.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class CreateEditTableViewCell: BaseEditTableViewCell {
    
    @IBOutlet weak var rankingNumLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionPlaceHolderLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var imageRatio43Constraint: NSLayoutConstraint!
    @IBOutlet weak var imageRatio11Constraint: NSLayoutConstraint!
    
    func setData(rankinCellData: RankingCellViewModel, imageRatioType: ImageRatioType) {
        
        // セルの各値をセットする
        rankingNumLabel.text = String(rankinCellData.num)
        titleTextField.text = rankinCellData.rankTitle
        descriptionTextView.text = rankinCellData.rankDescription
        cellImageView.setImageViewRect(targetImage: rankinCellData.image, rect: rankinCellData.imageRect)
        
        emptyImageView.isHidden = rankinCellData.image != nil
        
        // 画像比率を設定
        switch imageRatioType {
        case .ratio4to3:
            imageRatio43Constraint.isActive = true
            imageRatio11Constraint.isActive = false
            
        case .ratio1to1:
            imageRatio43Constraint.isActive = false
            imageRatio11Constraint.isActive = true
        }
        
        setBase(titleTextField: titleTextField,
                descriptionTextView: descriptionTextView,
                descriptionPlaceHolderLabel: descriptionPlaceHolderLabel,
                cellImageView: cellImageView,
                cellImage: rankinCellData.image,
                imageRatioType: imageRatioType)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        
        deleteTapped()
    }
}
