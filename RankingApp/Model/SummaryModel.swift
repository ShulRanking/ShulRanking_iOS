//
//  SummaryModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/20.
//

class SummaryModel {
    
    weak var delegate: SummaryModelProtocol?
    
    func logAnalytics(logName: String) {
        
        LogUtil.logAnalytics(logName: logName)
    }
    
    func fetchDataList() {
        
        let rankingViewModelList = DataBaseManager.shared.selectRankingViewModelList()
        delegate?.sentRankingViewModelList(rankingViewModelList: rankingViewModelList)
    }
    
    func updateDbSortedRankingViewModelList(rankingViewModelList: [RankingViewModel]) {
        
        DataBaseManager.shared.updateDbSortedRankingViewModelList(rankingViewModelList: rankingViewModelList)
    }
    
    func deleteDb(rankingViewModel: RankingViewModel) {
        
        DataBaseManager.shared.delete(idDate: rankingViewModel.idDate)
    }
    
    func deleteFirebaseStorage(rankingViewModel: RankingViewModel) {
        
        FirebaseStorageUtil.shared.deleteData(rankingViewModel: rankingViewModel)
    }
}
