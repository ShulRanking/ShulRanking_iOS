//
//  RealmMigrationManager.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/28.
//

import Foundation

final class RealmMigrationManager {
    
    static let shared = RealmMigrationManager()
    
    private init() {}
    
    /// DBのバージョンに応じてDBの編集を行う
    func checkDatabaseVersion() {
        
        var nowVersion: Int
        if Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION) <= 3 {
            
            // 初回インストールの場合
            if !Constants.USER_DEFAULTS_STANDARD.bool(forKey: Constants.IS_INSTALLED) {
                
                Constants.USER_DEFAULTS_STANDARD.set(0, forKey: Constants.NOW_VERSION)
                nowVersion = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION)
                
            } else {
                
                // DBのバージョンはミスで1と2は存在しないので3を保存
                Constants.USER_DEFAULTS_STANDARD.set(3, forKey: Constants.NOW_VERSION)
                nowVersion = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION)
            }
            
        } else {
            
            nowVersion = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION)
        }
        
        if nowVersion == 0 {
            
            DataBaseManager.shared.insertInitialData()
            Constants.USER_DEFAULTS_STANDARD.set(true, forKey: Constants.IS_INSTALLED)
            Constants.USER_DEFAULTS_STANDARD.set(true, forKey: Constants.IS_LOCK)
            Constants.USER_DEFAULTS_STANDARD.set(true, forKey: Constants.DISPLAY_DIALOG)
            
            let now = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let idDate: String = formatter.string(from: now as Date)
            Constants.USER_DEFAULTS_STANDARD.set(NSUUID().uuidString + idDate, forKey: Constants.USER_ID)
            
            // DBのバージョンはミスで1と2は存在しないので3を保存
            Constants.USER_DEFAULTS_STANDARD.set(3, forKey: Constants.NOW_VERSION)
            nowVersion = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION)
        }
        
        // nowVersion == 1,2は存在しない
        
        if nowVersion == 3 {
            
            Constants.USER_DEFAULTS_STANDARD.set(4, forKey: Constants.NOW_VERSION)
            nowVersion = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION)
        }
        
        if nowVersion == 4 {
            
            Constants.USER_DEFAULTS_STANDARD.set(5, forKey: Constants.NOW_VERSION)
            nowVersion = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION)
            
            // 以前のModelからランキングデータを取得
            let oldRankingViewModelList = DataBaseUtil.selectRankingViewModelList(getHidden: true)
            
            for oldRankingViewModel in oldRankingViewModelList {
                
                // ランキングデータを新たなModelに保存
                DataBaseManager.shared.saveRankingViewModelToDB(rankingViewModel: oldRankingViewModel, isEdit: true)
            }
            
            // 以前のModelのランキングデータを削除
            DataBaseUtil.deleteAll()
        }
        
        if nowVersion == 5 {
            
            // RankingViewModelにimageRatioTypeプロパティ追加のため
            
            Constants.USER_DEFAULTS_STANDARD.set(6, forKey: Constants.NOW_VERSION)
            nowVersion = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION)
        }
        
        insertUserDefaultsInitialData()
    }
    
    /// UserDefaultsの初期値を登録
    private func insertUserDefaultsInitialData() {
        
        if Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.SEARCH_ENGINE) == nil {
            
            Constants.USER_DEFAULTS_STANDARD.set(WebImageType.google.rawValue, forKey: Constants.SEARCH_ENGINE)
        }
        
        if Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.RANKING_MODE) == nil {
            
            Constants.USER_DEFAULTS_STANDARD.set(RankingMode.normal.rawValue, forKey: Constants.RANKING_MODE)
        }
        
        if Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.RANKING_ITEM_STYLE) == nil {
            
            Constants.USER_DEFAULTS_STANDARD.set(RankingDisplayStyle.standard.rawValue, forKey: Constants.RANKING_ITEM_STYLE)
        }
    }
}
