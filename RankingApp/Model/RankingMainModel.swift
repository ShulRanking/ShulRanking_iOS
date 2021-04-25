//
//  RankingMainModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/17.
//

class RankingMainModel {
    
    weak var delegate: RankingMainModelProtocol?
    
    func logAnalytics(logName: String) {
        
        LogUtil.logAnalytics(logName: logName)
    }
}
