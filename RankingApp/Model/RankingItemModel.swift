//
//  RankingItemModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/19.
//

import GradientCircularProgress

class RankingItemModel {
    
    weak var delegate: RankingItemModelProtocol?
    
    /// ランキングのモードを変更
    /// - Parameter gcp: プログレスビュー
    /// - Parameter rankingViewModel: モード変更するランキング
    func saveDBModeChange(gcp: GradientCircularProgress,
                          rankingViewModel: RankingViewModel,
                          callback: @escaping (RankingViewModel) -> Void) {
        
        DataBaseManager.shared.saveRankingViewModelToDB(
            rankingViewModel: rankingViewModel,
            isEdit: true,
            gcp: gcp) { [weak self] rankingViewModel in
            
            self?.delegate?.saveDBModeChangeCompleted(rankingViewModel: rankingViewModel)
            
            callback(rankingViewModel)
        }
    }
    
    /// ランキング表示スタイルの選択値を保存
    func saveRankingDisplayStyle(rankingDisplayStyle: RankingDisplayStyle) {
        
        Constants.USER_DEFAULTS_STANDARD.set(rankingDisplayStyle.rawValue, forKey: Constants.RANKING_ITEM_STYLE)
    }
}
