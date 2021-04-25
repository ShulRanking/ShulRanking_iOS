//
//  RankingDetailsViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/09/29.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit
import AMChart

class RankingDetailsViewController: BaseModalViewController {
    
    @IBOutlet weak var imageView11: UIImageView!
    @IBOutlet weak var imageView43: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var numImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var starAndTitlesAreaView: UIView!
    @IBOutlet weak var starTitleLabelsAreaView: UIView!
    @IBOutlet weak var starLabelsAreaView: UIView!
    @IBOutlet weak var radarChartView: AMRadarChartView!
    @IBOutlet weak var layoutToggleButton: UIButton!
    
    private let rankingViewModel: RankingViewModel
    private let rankingDisplayStyle: RankingDisplayStyle
    
    private var rankingCellViewModel: RankingCellViewModel
    private var starTitleStrArray: [String] = []
    private var starTitleArray: [UILabel] = []
    private var starLabelArrayArray: [[UILabel]] = []
    private var starSumArray: [Int] = []
    
    // ページを切り替える方向
    private enum DirectionType {
        case left
        case right
    }
    
    private lazy var resize: (() -> Void)? = {
        
        resizeView()
        
        return nil
    }()
    
    init(rankingViewModel: RankingViewModel,
         rankingCellViewModel: RankingCellViewModel,
         rankingDisplayStyle: RankingDisplayStyle) {
        
        self.rankingViewModel = rankingViewModel
        self.rankingCellViewModel = rankingCellViewModel
        self.rankingDisplayStyle = rankingDisplayStyle
        
        super.init(nibName: nil, bundle: nil, isCloseBackgroundTouch: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch rankingViewModel.rankingMode {
        case .star:
            
            starAndTitlesAreaView.isHidden = false
            layoutToggleButton.isHidden = false
            
            if Constants.USER_DEFAULTS_STANDARD.bool(forKey: Constants.RANKING_DETAIL_IS_CHART) {
                
                radarChartView.isHidden = false
                imageView11.isHidden = true
                imageView43.isHidden = true
                
            } else {
                
                radarChartView.isHidden = true
                
                if rankingDisplayStyle.isImage4to3() {
                    
                    imageView11.isHidden = true
                    imageView43.isHidden = false
                    
                } else {
                    
                    imageView11.isHidden = false
                    imageView43.isHidden = true
                }
            }
            
            let parentWidth = starTitleLabelsAreaView.frame.size.width
            let parentHeight = starTitleLabelsAreaView.frame.size.height
            let boundsY: CGFloat = 0
            let margin: CGFloat = 3
            
            starTitleStrArray = [rankingViewModel.starTitle1, rankingViewModel.starTitle2, rankingViewModel.starTitle3, rankingViewModel.starTitle4, rankingViewModel.starTitle5]
            
            for i in 0 ..< Constants.ITEM_SUM {
                starTitleArray.append(
                    UILabel(frame: CGRect(x: 0,
                                          y: ((parentHeight - boundsY) / CGFloat(Constants.ITEM_SUM)) * CGFloat(i) + boundsY,
                                          width: parentWidth,
                                          height: (parentHeight - boundsY) / CGFloat(Constants.ITEM_SUM) - margin)))
                starTitleArray[i].font = .boldSystemFont(ofSize: 12)
                starTitleArray[i].text = starTitleStrArray[i]
                starTitleArray[i].adjustsFontSizeToFitWidth = true
                starTitleArray[i].textColor = ConstantsColor.DARK_GRAY_CUSTOM_100
                starTitleLabelsAreaView.addSubview(starTitleArray[i])
                
                var starButtonOneLineArray = [UILabel]()
                
                for n in 0 ..< Constants.STAR_SUM {
                    
                    let starLabel = UILabel()
                    starLabel.adjustsFontSizeToFitWidth = true
                    starLabel.textColor = ConstantsColor.DARK_GRAY_CUSTOM_100
                    starButtonOneLineArray.append(starLabel)
                    starLabelsAreaView.addSubview(starButtonOneLineArray[n])
                }
                
                starLabelArrayArray.append(starButtonOneLineArray)
            }
            
            // レーダーチャート
            radarChartView.axisMaxValue = CGFloat(Constants.STAR_SUM)
            radarChartView.axisLabelsFont = .systemFont(ofSize: 0)
            radarChartView.numberOfAxisLabels = Constants.STAR_SUM + 1
            radarChartView.animationDuration = 0.5
            radarChartView.dataSource = self
            
        case .normal:
            
            starAndTitlesAreaView.isHidden = true
            layoutToggleButton.isHidden = true
            radarChartView.isHidden = true
            
            if rankingDisplayStyle.isImage4to3() {
                
                imageView11.isHidden = true
                imageView43.isHidden = false
                
            } else {
                
                imageView11.isHidden = false
                imageView43.isHidden = true
            }
        }
        
        //        if RankingCellViewModel.num == 1) {
        //            numImage.image = UIImage(named: "1st")
        //        } else if RankingCellViewModel.num == 2) {
        //            numImage.image = UIImage(named: "2nd")
        //        } else if RankingCellViewModel.num == 3) {
        //            numImage.image = UIImage(named: "3rd")
        //        } else {
        //            numImage.image = nil
        //        }
        
        leftButton.isEnabled = rankingCellViewModel.num != 1
        rightButton.isEnabled = rankingCellViewModel.num != rankingViewModel.lastRunk
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        setRankingCellData()
        
        LogUtil.logAnalytics(logName: "RDVC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if rankingViewModel.rankingMode == .star {
            // textViewの余白を詰める
            descriptionTextView.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        }
        
        descriptionTextView.setContentOffset(CGPoint(x: 0, y: -descriptionTextView.contentInset.top), animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        descriptionTextView.flashScrollIndicators()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // AoutoLayout確定後にframe設定
        resize?()
    }
    
    func setRankingCellData() {
        
        titleLabel.text = rankingCellViewModel.rankTitle
        descriptionTextView.text = rankingCellViewModel.rankDescription
        numLabel.text = String(rankingCellViewModel.num)
        
        imageView43.setImageViewRect(targetImage: rankingCellViewModel.image, rect: rankingCellViewModel.imageRect)
        imageView11.setImageViewRect(targetImage: rankingCellViewModel.image, rect: rankingCellViewModel.imageRect)
        
        if rankingViewModel.rankingMode == .star {
            
            starSumArray = [rankingCellViewModel.starNum1, rankingCellViewModel.starNum2, rankingCellViewModel.starNum3, rankingCellViewModel.starNum4, rankingCellViewModel.starNum5]
            var i: Int = 0
            for oneLineArray in starLabelArrayArray {
                
                var n: Int = 1
                for label in oneLineArray {
                    
                    if n <= starSumArray[i] {
                        
                        label.text = Constants.STAR_FILL
                    } else {
                        
                        label.text = Constants.STAR_EMPTY
                    }
                    
                    n += 1
                }
                
                i += 1
            }
            
            radarChartView.reloadData()
        }
    }
    
    private func toggleNum(directionType: DirectionType) {
        
        switch directionType {
        case .left:
            
            var i: Int = 0
            if 1 < rankingCellViewModel.num - 1 {
                
                i = rankingCellViewModel.num - 1
                
            } else if 1 == rankingCellViewModel.num - 1 {
                
                i = rankingCellViewModel.num - 1
                leftButton.isEnabled = false
            }
            
            rankingCellViewModel = rankingViewModel.rankingCellViewModelList[i - 1]
            rightButton.isEnabled = true
            
        case .right:
            
            var i: Int = 0
            if rankingCellViewModel.num + 1 < rankingViewModel.lastRunk {
                
                i = rankingCellViewModel.num + 1
                
            } else if rankingCellViewModel.num + 1 == rankingViewModel.lastRunk {
                
                i = rankingCellViewModel.num + 1
                rightButton.isEnabled = false
            }
            
            rankingCellViewModel = rankingViewModel.rankingCellViewModelList[i - 1]
            leftButton.isEnabled = true
        }
        
        //        if RankingCellViewModel.num == 1) {
        //            numImage.image = UIImage(named: "1st")
        //        } else if RankingCellViewModel.num == 2) {
        //            numImage.image = UIImage(named: "2nd")
        //        } else if RankingCellViewModel.num == 3) {
        //            numImage.image = UIImage(named: "3rd")
        //        } else {
        //            numImage.image = nil
        //        }
        
        setRankingCellData()
        
        descriptionTextView.setContentOffset(CGPoint(x: 0, y: -descriptionTextView.contentInset.top), animated: false)
    }
    
    private func resizeView() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            // starLabelsAreaView.frame.widthを確定させるため
            self.view.layoutIfNeeded()
            
            var starLabelWidth: CGFloat = 17.5
            var starLabelFontSize: CGFloat = 11.0
            
            // starLabelWidthが見切れる場合
            if self.starLabelsAreaView.frame.width < starLabelWidth * CGFloat(Constants.STAR_SUM) {
                
                starLabelWidth = self.starLabelsAreaView.frame.width / CGFloat(Constants.STAR_SUM)
                starLabelFontSize = starLabelWidth * 0.75
            }
            
            for (i, starLabelArray) in self.starLabelArrayArray.enumerated() {
                
                for (n, starLabel) in starLabelArray.enumerated() {
                    
                    starLabelArray[n].frame = CGRect(
                        x: starLabelWidth * CGFloat(n),
                        y: self.starTitleArray[i].frame.origin.y,
                        width: starLabelWidth,
                        height: self.starTitleArray[i].frame.size.height)
                    
                    starLabel.font = .systemFont(ofSize: starLabelFontSize)
                }
            }
        }
    }
    
    @IBAction func rightSwiped(_ sender: UISwipeGestureRecognizer) {
        
        if rankingCellViewModel.num == 1 {
            
            return
        }
        
        toggleNum(directionType: .left)
    }
    
    @IBAction func leftSwiped(_ sender: UISwipeGestureRecognizer) {
        
        if rankingCellViewModel.num == rankingViewModel.lastRunk {
            
            return
        }
        
        toggleNum(directionType: .right)
    }
    
    @IBAction func layoutToggleTapped(_ sender: UIButton) {
        
        radarChartView.isHidden.toggle()
        
        if rankingDisplayStyle.isImage4to3() {
            
            imageView43.isHidden.toggle()
            
        } else {
            
            imageView11.isHidden.toggle()
        }
        
        Constants.USER_DEFAULTS_STANDARD.set(!radarChartView.isHidden, forKey: Constants.RANKING_DETAIL_IS_CHART)
    }
    
    @IBAction func leftTapped(_ sender: UIButton) {
        
        toggleNum(directionType: .left)
    }
    
    @IBAction func rightTapped(_ sender: UIButton) {
        
        toggleNum(directionType: .right)
    }
}

// MARK: - AMRadarChartViewDataSource
extension RankingDetailsViewController: AMRadarChartViewDataSource {
    
    func numberOfSections(in radarChartView: AMRadarChartView) -> Int {
        1
    }
    
    func numberOfRows(in radarChartView: AMRadarChartView) -> Int {
        Constants.ITEM_SUM
    }
    
    func radarChartView(_ radarChartView: AMRadarChartView, valueForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        CGFloat(starSumArray[indexPath.row])
    }
    
    func radarChartView(_ radarChartView: AMRadarChartView, fillColorForSection section: Int) -> UIColor {
        ConstantsColor.RADAR_ORANGE_40
    }
    
    func radarChartView(_ radarChartView: AMRadarChartView, strokeColorForSection section: Int) -> UIColor {
        .clear
    }
    
    /// 各頂点の文字を設定する
    func radarChartView(_ radarChartView: AMRadarChartView, titleForVertexInRow row: Int) -> String {
        starTitleStrArray[row]
    }
    
    /// 各頂点の文字フォントを設定する
    func radarChartView(_ radarChartView: AMRadarChartView, fontForVertexInRow row: Int) -> UIFont {
        .systemFont(ofSize: 10)
    }
    
    /// 各頂点の文字色を設定する
    func radarChartView(_ radarChartView: AMRadarChartView, textColorForVertexInRow row: Int) -> UIColor {
        ConstantsColor.DARK_GRAY_CUSTOM_100
    }
}
