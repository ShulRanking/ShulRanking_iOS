//
//  CreateEditStarTableViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/02/03.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

class CreateEditStarTableViewCell: BaseEditTableViewCell {
    
    @IBOutlet weak var rankingNumLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionPlaceHolderLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var starSumLabel: UILabel!
    @IBOutlet weak var starTitleLabelsAreaView: UIView!
    @IBOutlet weak var starButtonsAreaView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var imageRatio43Constraint: NSLayoutConstraint!
    @IBOutlet weak var imageRatio11Constraint: NSLayoutConstraint!
    
    weak var starDelegate: CreateEditStarTableViewCellDelegate?
    
    private var itemLabelList: [UILabel] = []
    private var starButtonListList: [[UIButton]] = []
    private var starNumArray: [Int] = [0, 0, 0, 0, 0]
    
    private lazy var resize: (() -> Void)? = {
        
        resizeView()
        
        return nil
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let parentWidth = starTitleLabelsAreaView.frame.size.width
        let parentHeight = starTitleLabelsAreaView.frame.size.height
        let margin: CGFloat = 3
        
        for i in 0 ..< Constants.ITEM_SUM {
            
            itemLabelList.append(
                UILabel(
                    frame: CGRect(
                        x: 0,
                        y: (parentHeight / CGFloat(Constants.ITEM_SUM)) * CGFloat(i) + margin,
                        width: parentWidth,
                        height: parentHeight / CGFloat(Constants.ITEM_SUM) - margin)))
            
            itemLabelList[i].font = .systemFont(ofSize: 11.5)
            itemLabelList[i].adjustsFontSizeToFitWidth = true
            starTitleLabelsAreaView.addSubview(itemLabelList[i])
            
            var starButtonOneLineArray = [UIButton]()
            
            for n in 0 ..< Constants.STAR_SUM {
                
                // frameとfontSizeはlayoutSubviews後に設定
                let starButton = UIButton()
                starButton.setTitle(Constants.STAR_EMPTY, for: .normal)
                starButton.titleLabel?.adjustsFontSizeToFitWidth = true
                starButton.setTitleColor(ConstantsColor.DARK_GRAY_CUSTOM_100, for: .normal)
                starButton.addTarget(self, action: #selector(starTapped(_:)), for: UIControl.Event.touchUpInside)
                starButtonOneLineArray.append(starButton)
                starButtonsAreaView.addSubview(starButtonOneLineArray[n])
            }
            
            starButtonListList.append(starButtonOneLineArray)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // AoutoLayout確定後にframe設定
        resize?()
    }
    
    func setData(rankinCellData: RankingCellViewModel, imageRatioType: ImageRatioType, itemTextArray: [String]) {
        
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
        
        starNumArray = [rankinCellData.starNum1,
                        rankinCellData.starNum2,
                        rankinCellData.starNum3,
                        rankinCellData.starNum4,
                        rankinCellData.starNum5]
        
        for (index, label) in itemLabelList.enumerated() {
            
            label.text = itemTextArray[index]
            label.adjustsFontSizeToFitWidth = true
            //            // 枠のカラー
            //            label.layer.borderColor = UIColor.darkGray.cgColor
            //            // 枠の幅
            //            label.layer.borderWidth = 0.2
            //            // 枠を角丸にする
            //            label.layer.cornerRadius = 5.0
            //            label.layer.masksToBounds = true
        }
        
        var starSum = 0
        var starNumArrayIndex = 0
        for starButtonOneLine in starButtonListList {
            
            var num: Int = 1
            for starButton in starButtonOneLine {
                
                if num <= starNumArray[starNumArrayIndex] {
                    
                    starButton.setTitle(Constants.STAR_FILL, for: .normal)
                    starButton.isSelected = true
                    starSum += 1
                    
                } else {
                    
                    starButton.setTitle(Constants.STAR_EMPTY, for: .normal)
                    starButton.isSelected = false
                }
                
                num += 1
            }
            
            starNumArrayIndex += 1
        }
        
        starSumLabel.text = String(starSum)
        
        setBase(titleTextField: titleTextField,
                descriptionTextView: descriptionTextView,
                descriptionPlaceHolderLabel: descriptionPlaceHolderLabel,
                cellImageView: cellImageView,
                cellImage: rankinCellData.image,
                imageRatioType: imageRatioType)
    }
    
    private func resizeView() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            // starButtonsAreaView.frame.widthを確定させるため
            self.layoutIfNeeded()
            
            var starBottonWidth: CGFloat = 27.5
            var starBottonFontSize: CGFloat = 20.0
            
            // starBottonWidthが見切れる場合
            if self.starButtonsAreaView.frame.width < starBottonWidth * CGFloat(Constants.STAR_SUM) {
                
                starBottonWidth = self.starButtonsAreaView.frame.width / CGFloat(Constants.STAR_SUM)
                starBottonFontSize = starBottonWidth * 0.75
            }
            
            for (i, starButtonOneLineList) in self.starButtonListList.enumerated() {
                
                for (n, starButton) in starButtonOneLineList.enumerated() {
                    
                    starButton.frame = CGRect(
                        x: starBottonWidth * CGFloat(n),
                        y: self.itemLabelList[i].frame.origin.y,
                        width: starBottonWidth,
                        height: self.itemLabelList[i].frame.size.height)
                    
                    starButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Thin", size: starBottonFontSize)
                }
            }
        }
    }
    
    /// starButtonタップ
    @objc func starTapped(_ sender: UIButton) {
        
        var starSum = 0
        for starButtonOneLine in starButtonListList {
            
            for starButton in starButtonOneLine {
                
                if sender == starButton {
                    
                    sender.switchAction(onAction: {
                        
                        starButton.setTitle(Constants.STAR_FILL, for: .normal)
                        
                        for starButtonKid in starButtonOneLine {
                            
                            if starButton == starButtonKid {
                                
                                break
                                
                            } else {
                                
                                starButtonKid.setTitle(Constants.STAR_FILL, for: .normal)
                            }
                        }
                    }) {
                        
                        var tappedRightButton: UIButton = starButton
                        let reversedList = starButtonOneLine.reversed()
                        for starButtonKid in reversedList {
                            
                            if starButton == starButtonKid {
                                // タップされたボタンの右のボタンが選択済みの場合
                                if tappedRightButton.isSelected {
                                    
                                    starButtonKid.setTitle(Constants.STAR_FILL, for: .normal)
                                    
                                } else {
                                    
                                    starButton.setTitle(Constants.STAR_EMPTY, for: .normal)
                                }
                                
                                break
                                
                            } else {
                                
                                starButtonKid.setTitle(Constants.STAR_EMPTY, for: .normal)
                            }
                            
                            tappedRightButton = starButtonKid
                        }
                    }
                }
            }
        }
        
        var index = 0
        for starButtonOneLine in starButtonListList {
            
            var oneLineNum = 0
            for starButton in starButtonOneLine {
                
                if Constants.STAR_FILL == starButton.titleLabel!.text! {
                    
                    starButton.isSelected = true
                    starSum += 1
                    oneLineNum += 1
                    
                } else {
                    
                    starButton.isSelected = false
                }
            }
            
            starNumArray[index] = oneLineNum
            index += 1
        }
        
        starSumLabel.text = String(starSum)
        starDelegate?.starEditing(cell: self, starNumArray: starNumArray)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        
        deleteTapped()
    }
}
