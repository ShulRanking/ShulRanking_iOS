//
//  RankingItemStarInfoView.swift
//  ShulRanking
//
//  Created by 佐々木英彦 on 2021/03/15.
//

import UIKit
import AMChart

class RankingItemStarInfoView: UIView {
    
    @IBOutlet weak var starSum: UILabel!
    @IBOutlet weak var titlesAreaView: UIView!
    @IBOutlet weak var starsAreaView: UIView!
    @IBOutlet weak var radarChartView: AMRadarChartView!
    
    private var starTitleLabelArray: [UILabel] = []
    private var starLabelArrayArray: [[UILabel]] = []
    private var starSumArray: [Int] = []
    private var isFirstDraw: Bool = true
    
    private lazy var resize: (() -> Void)? = {
        
        resizeView()
        
        return nil
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadNib()
        
        // 評価項目のタイトルと星のviewを作成
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // AoutoLayout確定後にframe設定
        resize?()
    }
    
    func setData(rankinCellData: RankingCellViewModel, rankingViewModelData: RankingViewModel) {
        
        starSum.text = String(rankinCellData.starNum1 + rankinCellData.starNum2 + rankinCellData.starNum3 + rankinCellData.starNum4 + rankinCellData.starNum5)
        
        starSumArray = [rankinCellData.starNum1, rankinCellData.starNum2, rankinCellData.starNum3, rankinCellData.starNum4, rankinCellData.starNum5]
        
        for (index, oneLineArray) in starLabelArrayArray.enumerated() {
            
            var n: Int = 1
            for label in oneLineArray {
                
                if n <= starSumArray[index] {
                    
                    label.text = Constants.STAR_FILL
                    
                } else {
                    
                    label.text = Constants.STAR_EMPTY
                }
                
                n += 1
            }
        }
        
        let starTitleStrArray = [rankingViewModelData.starTitle1, rankingViewModelData.starTitle2, rankingViewModelData.starTitle3, rankingViewModelData.starTitle4, rankingViewModelData.starTitle5]
        
        for (index, titleLabel) in starTitleLabelArray.enumerated() {
            
            titleLabel.text = starTitleStrArray[index]
        }
        
        if isFirstDraw {
            
            isFirstDraw = false
            
        } else {
            
            radarChartView.reloadData()
        }
        
        resizeView()
    }
    
    /// 評価項目のタイトルと星のviewを作成
    private func setUpView() {
        
        let parentWidth: CGFloat = titlesAreaView.frame.size.width
        let parentHeight: CGFloat = titlesAreaView.frame.size.height
        let boundsY: CGFloat = 2
        let verticalMargin: CGFloat = 3
        let horaizonalMargin: CGFloat = 7
        
        for i in 0 ..< Constants.ITEM_SUM {
            
            starTitleLabelArray.append(
                UILabel(
                    frame: CGRect(
                        x: horaizonalMargin,
                        y: ((parentHeight - boundsY) / CGFloat(Constants.ITEM_SUM)) * CGFloat(i) + boundsY,
                        width: parentWidth - horaizonalMargin * 2,
                        height: (parentHeight - boundsY) / CGFloat(Constants.ITEM_SUM) - verticalMargin)))
            
            starTitleLabelArray[i].font = .systemFont(ofSize: 11.5)
            starTitleLabelArray[i].adjustsFontSizeToFitWidth = true
            starTitleLabelArray[i].textColor = ConstantsColor.VERY_DARK_GRAY_CUSTOM_100
            titlesAreaView.addSubview(starTitleLabelArray[i])
            
            var starLabelOneLineArray = [UILabel]()
            
            for n in 0 ..< Constants.STAR_SUM {
                
                // frameとfontSizeはlayoutSubviews後に設定
                let starLabel = UILabel()
                starLabel.text = Constants.STAR_EMPTY
                starLabel.adjustsFontSizeToFitWidth = true
                starLabel.textColor = ConstantsColor.DARK_GRAY_CUSTOM_100
                starLabelOneLineArray.append(starLabel)
                starsAreaView.addSubview(starLabelOneLineArray[n])
            }
            
            starLabelArrayArray.append(starLabelOneLineArray)
        }
        
        // レーダーチャート
        radarChartView.axisMaxValue = CGFloat(Constants.STAR_SUM)
        radarChartView.axisLabelsFont = .systemFont(ofSize: 0)
        radarChartView.numberOfAxisLabels = Constants.STAR_SUM + 1
        radarChartView.animationDuration = 0.5
        radarChartView.dataSource = self
    }
    
    private func resizeView() {
        
        // starsAreaView.frame.widthを確定させるため
        layoutIfNeeded()
        
        var starLabelWidth: CGFloat = 16.5
        var starLabelFontSize: CGFloat = 10.0
        
        // starLabelWidthが見切れる場合
        if starsAreaView.frame.width < starLabelWidth * CGFloat(Constants.STAR_SUM) {
            
            starLabelWidth = starsAreaView.frame.width / CGFloat(Constants.STAR_SUM)
            starLabelFontSize = starLabelWidth * 0.75
        }
        
        for (i, starLabelOneLineArray) in starLabelArrayArray.enumerated() {
            
            for (n, starLabel) in starLabelOneLineArray.enumerated() {
                
                starLabel.frame = CGRect(
                    x: starLabelWidth * CGFloat(n),
                    y: starTitleLabelArray[i].frame.origin.y,
                    width: starLabelWidth,
                    height: starTitleLabelArray[i].frame.height)
                
                starLabel.font = .systemFont(ofSize: starLabelFontSize)
            }
        }
    }
    
    /// xibファイルを読み込みビューに追加
    private func loadNib() {
        
        let bundle = Bundle(for: type(of: self))
        
        let view = bundle.loadNibNamed(className, owner: self, options: nil)!.first as! UIView
        view.frame = bounds
        
        addSubview(view)
    }
}

// MARK: - AMRadarChartViewDataSource
extension RankingItemStarInfoView: AMRadarChartViewDataSource {
    
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
}
