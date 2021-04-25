//
//  SettingModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/21.
//

class SettingModel {
    
    weak var delegate: SettingModelProtocol?
    
    func logAnalytics(logName: String) {
        
        LogUtil.logAnalytics(logName: logName)
    }
}
