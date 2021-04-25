//
//  CreateEditModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/12.
//

import GradientCircularProgress

class CreateEditModel {
    
    weak var delegate: CreateEditModelProtocol?
    
    func logAnalytics(logName: String) {
        
        LogUtil.logAnalytics(logName: logName)
    }
    
    func saveRankingViewModelToDB(
        rankingViewModel: RankingViewModel,
        isEdit: Bool,
        gcp: GradientCircularProgress? = nil,
        callback: ((RankingViewModel) -> Void)? = nil) {
        
        DataBaseManager.shared.saveRankingViewModelToDB(
            rankingViewModel: rankingViewModel,
            isEdit: isEdit,
            gcp: gcp,
            callback: callback)
    }
}
