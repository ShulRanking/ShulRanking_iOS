//
//  RankingUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/04/10.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

class RankingUtil {
    
    /// 項目が入っている順位までのランキングを返す
    static func getExistDataList(rankingCellViewModelList: [RankingCellViewModel]) -> [RankingCellViewModel] {

        var resultList = [RankingCellViewModel]()
        
        for i in 0 ..< getExistDataIndex(rankingCellViewModelList: rankingCellViewModelList) {
            
            resultList.append(rankingCellViewModelList[i])
        }
        
        return resultList
    }
    
    /// ランキングの中から項目が入っている順位の末尾を返す
    static func getExistDataIndex(rankingCellViewModelList: [RankingCellViewModel]) -> Int {
        
        // データが0でも一つは順位を表示させるため1を設定
        var bottomNum: Int = 1
        
        // 末尾から検索するためreverse
        let reversedList = rankingCellViewModelList.reversed()
        
        // 末尾から検索
        for rankingCellViewModel in reversedList {
            
            // データが入っている場合
            if rankingCellViewModel.image != nil ||
                !rankingCellViewModel.rankTitle.isEmpty ||
                !rankingCellViewModel.rankDescription.isEmpty {
                
                bottomNum = rankingCellViewModel.num
                
                break
            }
        }
        
        return bottomNum
    }
    
//    /// 項目が入っている順位の末尾から後ろの要素を削除
//    static func setExistDataList(rankingViewModel: RankingViewModel) {
//
//        let lastRunk = getExistDataIndex(rankingCellViewModelList: rankingViewModel.rankingCellViewModelList)
//
//        rankingViewModel.rankingCellViewModelList.removeSubrange(lastRunk ..< rankingViewModel.rankingCellViewModelList.count)
//    }
    
    /// ☆評価モードの項目にデータが存在するかを確かめる
    /// - Parameter rankingViewModel: ランキングデータ
    /// - Returns: 項目に値があればtrue
    static func checkStarTitleExist(rankingViewModel: RankingViewModel) -> Bool {
        
        // 項目に入力されているかをチェック
        let starTitleist: [String] = [rankingViewModel.starTitle1, rankingViewModel.starTitle2, rankingViewModel.starTitle3, rankingViewModel.starTitle4, rankingViewModel.starTitle5]

        for starTitle in starTitleist {

            if !starTitle.isEmpty {
                
                return true
            }
        }

        return false
    }

    /// ☆評価モードの項目と☆評価部分のデータを削除する
    /// - Parameters:
    ///   - rankingViewModel: ランキングデータ
    ///   - rankingCellViewModelList: ランキングデータのヘッダーセル以外のセル表示部分
    static func deleteStarData(rankingViewModel: RankingViewModel, rankingCellViewModelList: [RankingCellViewModel]) {
        
        // 項目をクリア
        rankingViewModel.starTitle1 = ""
        rankingViewModel.starTitle2 = ""
        rankingViewModel.starTitle3 = ""
        rankingViewModel.starTitle4 = ""
        rankingViewModel.starTitle5 = ""
        
        // 星をクリア
        for rankingCellViewModel in rankingCellViewModelList {
            
            rankingCellViewModel.starNum1 = 0
            rankingCellViewModel.starNum2 = 0
            rankingCellViewModel.starNum3 = 0
            rankingCellViewModel.starNum4 = 0
            rankingCellViewModel.starNum5 = 0
        }
    }
}
