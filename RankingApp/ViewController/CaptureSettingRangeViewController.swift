//
//  CaptureSettingRangeViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/11/29.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class CaptureSettingRangeViewController: BaseModalViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var topPickerView: UIPickerView!
    @IBOutlet weak var bottomPickerView: UIPickerView!
    
    private let rankingViewModel: RankingViewModel
    private let rankingDisplayStyle: RankingDisplayStyle
    private let completion: (Int, Int) -> Void
    
    private var rankingCellViewModelList: [RankingCellViewModel] {
        rankingViewModel.rankingCellViewModelList
    }
    
    private var bottomNum: Int = 0
    
    init(rankingViewModel: RankingViewModel, rankingDisplayStyle: RankingDisplayStyle, completion: @escaping (Int, Int) -> Void) {
        
        self.rankingViewModel = rankingViewModel
        self.rankingDisplayStyle = rankingDisplayStyle
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil, isCloseBackgroundTouch: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デフォルト設定
        bottomNum = rankingViewModel.lastRunk - 1
        
        topPickerView.selectRow(0, inComponent: 0, animated: false)
        bottomPickerView.selectRow(bottomNum, inComponent: 0, animated: false)
        
        LogUtil.logAnalytics(logName: "CSRVC")
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        
        topPickerView.selectRow(0, inComponent: 0, animated: true)
        bottomPickerView.selectRow(bottomNum, inComponent: 0, animated: true)
    }
    
    @IBAction func decisionButtonTapped(_ sender: UIButton) {
        
        LogUtil.logAnalytics(logName: "CSRVC_Dec_RDStyle_\(rankingDisplayStyle.getNameForLog())")
        
        dismiss(animated: true)
        
        // 上のピッカーで選択した順位が下のピッカーで選択した順位より低い場合
        if topPickerView.selectedRow(inComponent: 0) < bottomPickerView.selectedRow(inComponent: 0) {
            
            completion(topPickerView.selectedRow(inComponent: 0), bottomPickerView.selectedRow(inComponent: 0))
            
        } else {
            
            completion(bottomPickerView.selectedRow(inComponent: 0), topPickerView.selectedRow(inComponent: 0))
        }
    }
}

// MARK: - UIPickerViewDataSource
extension CaptureSettingRangeViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        rankingCellViewModelList.count
    }
}

// MARK: - UIPickerViewDelegate
extension CaptureSettingRangeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if let pickerLabel = pickerLabel {
            
            pickerLabel.text = String(rankingCellViewModelList[row].num) + " " + rankingCellViewModelList[row].rankTitle
            pickerLabel.textColor = ConstantsColor.DARK_GRAY_CUSTOM_100
            
        } else {
            
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 15)
            pickerLabel?.textAlignment = .left
            
            // TODO:- iOS14バグの暫定対応
            if #available(iOS 14, *) {
                pickerLabel?.text = " 　" + String(rankingCellViewModelList[row].num) + " " + rankingCellViewModelList[row].rankTitle
            } else {
                pickerLabel?.text = String(rankingCellViewModelList[row].num) + " " + rankingCellViewModelList[row].rankTitle
            }
            
            pickerLabel?.textColor = ConstantsColor.DARK_GRAY_CUSTOM_100
        }

        return pickerLabel!
    }
}

