//
//  HomeModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/11/21.
//

class HomeModel {
    
    weak var delegate: HomeModelProtocol?
    
    func logAnalytics(logName: String) {
        
        LogUtil.logAnalytics(logName: logName)
    }
    
    func fetchDataList() {
        
        let rankingViewModelList = DataBaseManager.shared.selectRankingViewModelList()
        delegate?.sentRankingViewModelList(rankingViewModelList: rankingViewModelList)
    }
}
