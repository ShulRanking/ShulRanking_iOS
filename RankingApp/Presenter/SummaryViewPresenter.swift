//
//  SummaryViewPresenter.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/10.
//

import UIKit

class SummaryViewPresenter: SummaryViewPresenterProtocol {
    
    private weak var view: SummaryViewProtocol?
    private let model: SummaryModel
    
    private var rankingViewModelList: [RankingViewModel]!
    private var isSorted: Bool = false
    private var isTableviewEditing: Bool = false
    
    init(view: SummaryViewProtocol) {
        
        self.view = view
        
        model = SummaryModel()
        model.delegate = self
    }
    
    func viewDidLoad() {
        
        // DBから全ランキングデータを取り出し
        fetchDataList()
        
        view?.reloadTableView()
    }
    
    func viewWillAppear() {
        
        // DBから全ランキングデータを取り出し
        fetchDataList()
        
        view?.reloadTableView()
        
        model.logAnalytics(logName: "SumVC")
    }
    
    func getRankingViewModelList() -> [RankingViewModel] {
        rankingViewModelList
    }
    
    /// データを並び替え
    func sorted(sourceIndex: Int, destinationIndex: Int) {
        
        let sortedRankingViewModel = rankingViewModelList[sourceIndex]
        rankingViewModelList.remove(at: sourceIndex)
        rankingViewModelList.insert(sortedRankingViewModel, at: destinationIndex)
        
        isSorted = true
    }
    
    func rankingDeleted(index: Int) {
        
        model.deleteFirebaseStorage(rankingViewModel: rankingViewModelList[index])
        model.deleteDb(rankingViewModel: rankingViewModelList[index])
        
        rankingViewModelList?.remove(at: index)
        view?.deleteRow(index: index)
        
        model.logAnalytics(logName: "SumVC_Delete")
    }
    
    func itemSelected(index: Int) {
        
        // RankingItemViewControllerへ
        let rankingMainVC = RankingMainViewController(rankingViewModel: rankingViewModelList[index], fromCreateEdit: false)
        view?.pushVC(nextVC: rankingMainVC)
        
        model.logAnalytics(logName: "RanIVC_SumVC")
    }
    
    func editOrSaveTapped() {
        
        isTableviewEditing.toggle()
        
        var topRightIconImage: UIImage? {
            
            isTableviewEditing ? UIImage(named: "save") : UIImage(named: "lineSpacing")
        }
        
        view?.setEditMode(isEdit: isTableviewEditing, image: topRightIconImage!)
        
        // 並び替えを行っていた場合
        if isSorted {
            
            guard let rankingViewModelList = rankingViewModelList else { return }
            
            // DBを並び替えた配列でアップデートする
            model.updateDbSortedRankingViewModelList(rankingViewModelList: rankingViewModelList)
            
            isSorted = false
            
            model.logAnalytics(logName: "SumVC_Sort")
        }
        
        view?.reloadTableView()
    }
    
    /// DBから全ランキングデータを取り出し
    private func fetchDataList() {
        
        model.fetchDataList()
    }
}

// MARK: - SummaryModelProtocol
extension SummaryViewPresenter: SummaryModelProtocol {
    
    func sentRankingViewModelList(rankingViewModelList: [RankingViewModel]) {
        
        self.rankingViewModelList = rankingViewModelList
    }
}
