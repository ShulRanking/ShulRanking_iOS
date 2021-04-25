//
//  DataBaseUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/28.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import RealmSwift
import GradientCircularProgress

class DataBaseUtil {
    
    static var isNeedFech: Bool = true
    /// 最新のランキングデータリスト
    private static var newRankingViewModelList: [RankingViewModel]?
    
    static func getRealm() -> Realm {
        
        // バージョンアップ時
        let config = Realm.Configuration(schemaVersion: UInt64(Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION)))
        let realm = try! Realm(configuration: config)
        
//        // DBのパスを出力(シュミレータの時用)
//        print("Realm fileURL simurator\(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        return realm
    }
    
    /// DBの中間データの履歴を解放
    static func compactRealm() {
        //        // Realm圧縮方法1
        //        // http://ios-apps.hatenablog.com/entry/2016/11/01/184137
        //        do {
        //            let realm = getRealm()
        //            let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        //            let defaultParentURL = defaultURL.deletingLastPathComponent()
        //            try! realm.writeCopy(toFile: defaultParentURL.appendingPathComponent("temp.realm"))
        //            try FileManager.default.removeItem(at: defaultURL)
        //            try FileManager.default.moveItem(at: defaultParentURL.appendingPathComponent("temp.realm"), to: defaultURL)
        //        } catch let error as NSError {
        //            print("Error - \(error.localizedDescription)")
        //        }
        
        //        // Realm圧縮方法2
        //        // https://stackoverflow.com/questions/35865711/realm-file-size-is-too-large
        //        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        //        let defaultParentURL = defaultURL.deletingLastPathComponent()
        //        let compactedURL = defaultParentURL.appendingPathComponent("default-compact.realm")
        //
        //        autoreleasepool {
        //            try! getRealm().writeCopy(toFile: compactedURL)
        //            try! FileManager.default.removeItem(at: defaultURL)
        //            try! FileManager.default.moveItem(at: compactedURL, to: defaultURL)
        //        }
        
        //        // Realm圧縮方法3
        //        // https://stackoverflow.com/questions/36877745/how-do-you-compact-a-realm-db-on-ios
        //        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        //        let defaultParentURL = defaultURL.deletingLastPathComponent()
        //        let compactedURL = defaultParentURL.appendingPathComponent("default-compact.realm")
        //
        //        autoreleasepool {
        //            try! getRealm().writeCopy(toFile: compactedURL)
        //        }
        //        try! FileManager.default.removeItem(at: defaultURL)
        //        try! FileManager.default.moveItem(at: compactedURL, to: defaultURL)
    }
    
    /// 初回インストール時用のサンプルランキングを作成とDBへの登録
    static func insertInitialData() {
        
        let cellTitle = "title"
        let image = "image"
        let explanation = "explanation"
        
        let cellInfoDictionalyArray: [[String: Any]] = [
            [cellTitle: "Cairo", image: UIImage(named: "cityCairo")!, explanation: "砂漠とラクダとピラミッド！\n地球最古の歴史に触れたい。"],
            [cellTitle: "Hawaii", image: UIImage(named: "cityHawaii")!, explanation: "スカイダイビングしたり、ウミガメと泳いでみたい。\n思いっきりレジャーを楽しむ！"],
            [cellTitle: "Istanbul", image: UIImage(named: "cityIstanbul")!, explanation: "モスクとケバブとトルコアイス！\nそれに中東やヨーロッパの歴史をここから学びたい。"],
            [cellTitle: "Ukiha", image: UIImage(named: "cityUkiha")!, explanation: "帰省したい。"],
            [cellTitle: "NewYork", image: UIImage(named: "cityNewYork")!, explanation: "タイムズスクエアに自由の女神にウォール街！\n世界の中心と言われるこの場所に一度は行ってみたい！"],
            [cellTitle: "Sydney", image: UIImage(named: "citySydney")!, explanation: "海やエアーズロック。オーストラリアの壮大な自然や真逆の季節を楽しみたい。"],
            [cellTitle: "SaoPaulo", image: UIImage(named: "citySaoPaulo")!, explanation: "地球の裏側、南米でどんな文化や物や人たちがいるのか知りたい。"],
            [cellTitle: "Shanghai", image: UIImage(named: "cityShanghai")!, explanation: "急激に発展する経済都市をこの目でみてみたい。"],
            [cellTitle: "Manila", image: UIImage(named: "cityManila")!, explanation: "グリーンベルトやタガイタイで自然を感じたい。距離も遠くないし、ちょっとした連休で行けるかも。"],
            [cellTitle: "Barcelona", image: UIImage(named: "cityBarcelona")!, explanation: "サクラダファミリアやサッカーやスペイン料理！全て楽しみたい！"]
        ]
        
        var rankingCellViewModelList = [RankingCellViewModel]()
        for n in 1 ... cellInfoDictionalyArray.count {
            
            let rankingCellViewModel = RankingCellViewModel()
            rankingCellViewModel.num = n
            rankingCellViewModelList.append(rankingCellViewModel)
        }
        
        let idDate = DateUtil.getNowDate()
        
        var i: Int = 0
        for rankingCellViewModel in rankingCellViewModelList {
            
            let dbRecord = DataBaseRecord()
            
            // データを最小にするため、タイトルと背景画像は先頭の1つのレコードにのみ保存
            if i == 0 {
                
                dbRecord._majorTitle = "Sample*いつか行きたい旅行先ランキング"
                dbRecord._backgroundImage = getImageDataForRealm(image: UIImage(named: "cityTop"))
                
            } else {
                
                dbRecord._majorTitle = ""
                dbRecord._backgroundImage = nil
            }
            
            dbRecord._idDate = idDate
            dbRecord._updateDate = idDate
            dbRecord._sequence = ""
            dbRecord._displayOrder = 0
            dbRecord._displayFlg = true
            dbRecord._num = String(rankingCellViewModel.num)
            
            if i < cellInfoDictionalyArray.count {
                
                dbRecord._cellTitle = cellInfoDictionalyArray[i][cellTitle] as! String
                dbRecord._image = getImageDataForRealm(image: cellInfoDictionalyArray[i][image] as? UIImage)
                dbRecord._explanation = cellInfoDictionalyArray[i][explanation] as! String
                dbRecord._additionalData = ""
                dbRecord._isExistData = true
                
            } else {
                
                dbRecord._cellTitle = rankingCellViewModel.rankTitle
                dbRecord._explanation = rankingCellViewModel.rankDescription
                dbRecord._isExistData = false
            }
            
            save(dbRecord)
            
            i += 1
        }
    }
    
    /// 特定のランキングデータを取得するための処理
    static func getRankingViewModel(idDate: String, rankingMode: RankingMode) -> RankingViewModel {
        
        let rankingViewModel = RankingViewModel()
        
        switch rankingMode {
        case .normal:
            
            let saveList: Results<DataBaseRecord> = getRealm().objects(DataBaseRecord.self).filter("_idDate == '\(idDate)'")
            
            var rankingCellViewModelList = [RankingCellViewModel]()
            var i: Int = 0
            for dbRecord in saveList {
                // _majorTitleと_backgroundImageは各ランキングの1行目に入っている
                // 初回の場合
                if i == 0 {
                    
                    rankingViewModel.isDisplay = saveList[i]._displayFlg
                    rankingViewModel.idDate = saveList[i]._idDate
                    rankingViewModel.updateDate = saveList[i]._updateDate
                    rankingViewModel.displayOrder = saveList[i]._displayOrder
                    rankingViewModel.rankingMode = RankingMode.normal
                    rankingViewModel.mainTitle = saveList[i]._majorTitle
                    
                    if let backgroundImage = saveList[i]._backgroundImage {
                        rankingViewModel.mainImage = UIImage(data: backgroundImage)
                    }
                }
                
                let rankingCellViewModel = RankingCellViewModel()
                rankingCellViewModel.num = Int(dbRecord._num)!
                rankingCellViewModel.rankTitle = dbRecord._cellTitle
                rankingCellViewModel.rankDescription = dbRecord._explanation
                
                if let dbImage = dbRecord._image {
                    
                    if let dbImage = UIImage(data: dbImage) {
                        rankingCellViewModel.image = dbImage
                    }
                }
                
                rankingCellViewModelList.append(rankingCellViewModel)
                
                // 最後のインデックスの場合
                if i == saveList.count - 1 {
                    
                    rankingViewModel.rankingCellViewModelList = rankingCellViewModelList
                }
                
                i += 1
            }
            
        case .star:
            
            let saveListStar: Results<RankingStarTable> = getRealm().objects(RankingStarTable.self).filter("_idDate == '\(idDate)'")
            
            var rankingCellViewModelList = [RankingCellViewModel]()
            var i: Int = 0
            for dbRecord in saveListStar {
                // _majorTitleと_backgroundImageは各ランキングの1行目に入っている
                // 初回の場合
                if i == 0 {
                    
                    rankingViewModel.isDisplay = saveListStar[i]._displayFlg
                    rankingViewModel.idDate = saveListStar[i]._idDate
                    rankingViewModel.updateDate = saveListStar[i]._updateDate
                    rankingViewModel.displayOrder = saveListStar[i]._displayOrder
                    rankingViewModel.rankingMode = RankingMode.star
                    rankingViewModel.starTitle1 = saveListStar[i]._starTitle1
                    rankingViewModel.starTitle2 = saveListStar[i]._starTitle2
                    rankingViewModel.starTitle3 = saveListStar[i]._starTitle3
                    rankingViewModel.starTitle4 = saveListStar[i]._starTitle4
                    rankingViewModel.starTitle5 = saveListStar[i]._starTitle5
                    rankingViewModel.mainTitle = saveListStar[i]._majorTitle
                    
                    if let backgroundImage = saveListStar[i]._backgroundImage {
                        rankingViewModel.mainImage = UIImage(data: backgroundImage)
                    }
                }
                
                let rankingCellViewModel: RankingCellViewModel = RankingCellViewModel()
                rankingCellViewModel.num = Int(dbRecord._num)!
                rankingCellViewModel.rankTitle = dbRecord._cellTitle
                rankingCellViewModel.rankDescription = dbRecord._explanation
                rankingCellViewModel.starNum1 = dbRecord._starNum1
                rankingCellViewModel.starNum2 = dbRecord._starNum2
                rankingCellViewModel.starNum3 = dbRecord._starNum3
                rankingCellViewModel.starNum4 = dbRecord._starNum4
                rankingCellViewModel.starNum5 = dbRecord._starNum5
                
                if let dbImage = dbRecord._image {
                    
                    if let dbImage = UIImage(data: dbImage) {
                        rankingCellViewModel.image = dbImage
                    }
                }
                
                rankingCellViewModelList.append(rankingCellViewModel)
                
                // 最後のインデックスの場合
                if i == saveListStar.count - 1 {
                    
                    rankingViewModel.rankingCellViewModelList = rankingCellViewModelList
                }
                
                i += 1
            }
        }
        
        return rankingViewModel
    }
    
    /// データを保存するための処理
    static func save(_ record: DataBaseRecord) {
        
        isNeedFech = true
        
        do {
            let realm = getRealm()
            try realm.write {
                realm.add(record)
            }
        } catch {
            
        }
    }
    
    /// データを保存するための処理
    static func save(_ record: RankingStarTable) {
        
        isNeedFech = true
        
        do {
            let realm = getRealm()
            try realm.write {
                realm.add(record)
            }
        } catch {
            
        }
    }
    
    /// データを更新するための処理
    static func update(idDate: String, rankingMode: RankingMode) {
        
        isNeedFech = true
        
        do {
            
            let realm = getRealm()
            
            switch rankingMode {
            case .normal:
                let results = realm.objects(DataBaseRecord.self).filter("_idDate == '\(idDate)'")
                try realm.write {
                    for result in results {
                        result._displayFlg = !result._displayFlg
                    }
                }
                
            case .star:
                let results = realm.objects(RankingStarTable.self).filter("_idDate == '\(idDate)'")
                try realm.write {
                    for result in results {
                        result._displayFlg = !result._displayFlg
                    }
                }
            }
        } catch {
            
        }
    }
    
    /// データを削除するための処理
    static func delete(idDate: String, rankingMode: RankingMode) {
        
        isNeedFech = true
        
        do {
            let realm = getRealm()
            
            switch rankingMode {
            case .normal:
                let results = realm.objects(DataBaseRecord.self).filter("_idDate == '\(idDate)'")
                try realm.write {
                    realm.delete(results)
                }
            case .star:
                let results = realm.objects(RankingStarTable.self).filter("_idDate == '\(idDate)'")
                try realm.write {
                    realm.delete(results)
                }
            }
        } catch {
            
        }
    }
    
    /// DataBaseRecordとRankingStarTableのデータを全て削除
    static func deleteAll() {
        
        do {
            
            let realm = getRealm()
            
            let normalResults = realm.objects(DataBaseRecord.self)
            try realm.write {
                realm.delete(normalResults)
            }
            
            let satrResults = realm.objects(RankingStarTable.self)
            try realm.write {
                realm.delete(satrResults)
            }
        } catch {
            
        }
    }
    
    /// データ取り出し
    static func selectRankingViewModelList(getHidden: Bool) -> [RankingViewModel] {
        
        if !isNeedFech {
            guard let newRankingViewModelList = newRankingViewModelList else {
                fatalError("newRankingViewModelList is nil")
            }
            return newRankingViewModelList
        }
        
        var rankingViewModelList = [RankingViewModel]()
        
        let realm = getRealm()
        // ノーマルモードのランキングデータ取得
        let saveList: Results<DataBaseRecord>! = realm.objects(DataBaseRecord.self)
        
        if saveList.count != 0 {
            var rankingViewModel = RankingViewModel()
            var rankingCellViewModelList = [RankingCellViewModel]()
            var i: Int = 0
            for dbRecord in saveList {
                // _majorTitleと_backgroundImageは各ランキングの1行目に入っている
                // 初回の場合
                if i == 0 {
                    
                    rankingViewModel.isDisplay = saveList[i]._displayFlg
                    rankingViewModel.idDate = saveList[i]._idDate
                    rankingViewModel.updateDate = saveList[i]._updateDate
                    rankingViewModel.displayOrder = saveList[i]._displayOrder
                    rankingViewModel.rankingMode = RankingMode.normal
                    rankingViewModel.mainTitle = saveList[i]._majorTitle
                    
                    if let backgroundImage = saveList[i]._backgroundImage, 0 < backgroundImage.count {
                        rankingViewModel.mainImage = UIImage(data: backgroundImage)
                    }
                }
                // ユニークなIDの場合
                else if saveList[i - 1]._idDate != saveList[i]._idDate {
                    // ここで1つランキング出来上がり
                    rankingViewModel.rankingCellViewModelList = rankingCellViewModelList
                    rankingViewModelList.append(rankingViewModel)
                    
                    // 新しいランキング作る
                    rankingCellViewModelList = []
                    rankingViewModel = RankingViewModel()
                    
                    rankingViewModel.isDisplay = saveList[i]._displayFlg
                    rankingViewModel.idDate = saveList[i]._idDate
                    rankingViewModel.updateDate = saveList[i]._updateDate
                    rankingViewModel.displayOrder = saveList[i]._displayOrder
                    rankingViewModel.rankingMode = RankingMode.normal
                    rankingViewModel.mainTitle = saveList[i]._majorTitle
                    
                    if let backgroundImage = saveList[i]._backgroundImage, 0 < backgroundImage.count {
                        rankingViewModel.mainImage = UIImage(data: backgroundImage)
                    }
                }
                
                let rankingCellViewModel: RankingCellViewModel = RankingCellViewModel()
                rankingCellViewModel.num = Int(dbRecord._num)!
                rankingCellViewModel.rankTitle = dbRecord._cellTitle
                rankingCellViewModel.rankDescription = dbRecord._explanation
                
                if let dbImage = dbRecord._image, 0 < dbImage.count {
                    
                    if let dbImage = UIImage(data: dbImage) {
                        rankingCellViewModel.image = dbImage
                    }
                }
                
                rankingCellViewModelList.append(rankingCellViewModel)
                
                // 最後のインデックスの場合
                if i == saveList.count - 1 {
                    
                    rankingViewModel.rankingCellViewModelList = rankingCellViewModelList
                    rankingViewModelList.append(rankingViewModel)
                }
                
                i += 1
            }
        }
        
        // 星評価モードのランキングデータ取得
        let saveStarList: Results<RankingStarTable>! = realm.objects(RankingStarTable.self)
        
        if saveStarList.count != 0 {
            var rankingViewModel = RankingViewModel()
            var rankingCellViewModelList = [RankingCellViewModel]()
            var i: Int = 0
            for dbRecord in saveStarList {
                // _majorTitleと_backgroundImageは各ランキングの1行目に入っている
                // 初回の場合
                if i == 0 {
                    
                    rankingViewModel.isDisplay = saveStarList[i]._displayFlg
                    rankingViewModel.idDate = saveStarList[i]._idDate
                    rankingViewModel.updateDate = saveStarList[i]._updateDate
                    rankingViewModel.displayOrder = saveStarList[i]._displayOrder
                    rankingViewModel.rankingMode = RankingMode.star
                    rankingViewModel.starTitle1 = saveStarList[i]._starTitle1
                    rankingViewModel.starTitle2 = saveStarList[i]._starTitle2
                    rankingViewModel.starTitle3 = saveStarList[i]._starTitle3
                    rankingViewModel.starTitle4 = saveStarList[i]._starTitle4
                    rankingViewModel.starTitle5 = saveStarList[i]._starTitle5
                    rankingViewModel.mainTitle = saveStarList[i]._majorTitle
                    
                    if let backgroundImage = saveStarList[i]._backgroundImage, 0 < backgroundImage.count {
                        rankingViewModel.mainImage = UIImage(data: backgroundImage)
                    }
                }
                // ユニークなIDの場合
                else if saveStarList[i - 1]._idDate != saveStarList[i]._idDate {
                    // ここで1つランキング出来上がり
                    rankingViewModel.rankingCellViewModelList = rankingCellViewModelList
                    rankingViewModelList.append(rankingViewModel)
                    
                    // 新しいランキング作る
                    rankingCellViewModelList = []
                    rankingViewModel = RankingViewModel()
                    
                    rankingViewModel.isDisplay = saveStarList[i]._displayFlg
                    rankingViewModel.idDate = saveStarList[i]._idDate
                    rankingViewModel.updateDate = saveStarList[i]._updateDate
                    rankingViewModel.displayOrder = saveStarList[i]._displayOrder
                    rankingViewModel.rankingMode = RankingMode.star
                    rankingViewModel.starTitle1 = saveStarList[i]._starTitle1
                    rankingViewModel.starTitle2 = saveStarList[i]._starTitle2
                    rankingViewModel.starTitle3 = saveStarList[i]._starTitle3
                    rankingViewModel.starTitle4 = saveStarList[i]._starTitle4
                    rankingViewModel.starTitle5 = saveStarList[i]._starTitle5
                    rankingViewModel.mainTitle = saveStarList[i]._majorTitle
                    
                    if let backgroundImage = saveStarList[i]._backgroundImage, 0 < backgroundImage.count {
                        rankingViewModel.mainImage = UIImage(data: backgroundImage)
                    }
                }
                
                let rankingCellViewModel = RankingCellViewModel()
                rankingCellViewModel.num = Int(dbRecord._num)!
                rankingCellViewModel.rankTitle = dbRecord._cellTitle
                rankingCellViewModel.rankDescription = dbRecord._explanation
                //                rankingCellViewModel.additionalData = dbRecord._additionalData
                rankingCellViewModel.starNum1 = dbRecord._starNum1
                rankingCellViewModel.starNum2 = dbRecord._starNum2
                rankingCellViewModel.starNum3 = dbRecord._starNum3
                rankingCellViewModel.starNum4 = dbRecord._starNum4
                rankingCellViewModel.starNum5 = dbRecord._starNum5
                //                rankingCellViewModel.isExistData = dbRecord._isExistData
                
                if let dbImage = dbRecord._image, 0 < dbImage.count {
                    //                    rankingCellViewModel.imageData = dbImage
                    
                    if let dbImage = UIImage(data: dbImage) {
                        rankingCellViewModel.image = dbImage
                    }
                }
                
                rankingCellViewModelList.append(rankingCellViewModel)
                
                // 最後のインデックスの場合
                if i == saveStarList.count - 1 {
                    
                    rankingViewModel.rankingCellViewModelList = rankingCellViewModelList
                    rankingViewModelList.append(rankingViewModel)
                }
                
                i += 1
            }
        }
        
        // ロックモードの場合
        if UserDefaults.standard.bool(forKey: Constants.IS_LOCK) && !getHidden {
            var i: Int = 0
            for rankingViewModel in rankingViewModelList {
                // displayFlgがfalseの場合
                if !rankingViewModel.isDisplay {
                    // 表示するリストから削除
                    rankingViewModelList.remove(at: i)
                    i -= 1
                }
                i += 1
            }
        }
        
        // displayOrderで昇順にソート
        rankingViewModelList = rankingViewModelList.sorted(by: { (a, b) -> Bool in
            
            // displayOrderが同じ場合
            if a.displayOrder == b.displayOrder {
                // 日付で降順にソート
                return a.idDate > b.idDate
                
            } else {
                // displayOrderで昇順にソート
                return a.displayOrder < b.displayOrder
            }
        })
        
        newRankingViewModelList = rankingViewModelList
        isNeedFech = false
        
        return newRankingViewModelList!
    }
    
    /// displayOrderの書き換えを行い、データをソートする
    static func updateDbSortedRankingViewModelList(rankingViewModelList: [RankingViewModel]) {
        
        isNeedFech = true
        
        let realm = getRealm()
        // DataBaseRecordに保存してあるデータを全て取得
        let saveList: Results<DataBaseRecord>! = realm.objects(DataBaseRecord.self)
        // RankingStarTableに保存してあるデータを全て取得
        let saveStarList: Results<RankingStarTable>! = realm.objects(RankingStarTable.self)
        
        var rockedDisplayOrderList = [Int]()
        
        // ロックモードの場合
        if UserDefaults.standard.bool(forKey: Constants.IS_LOCK) {
            let selectedList: Results<DataBaseRecord> = saveList.filter("_num == '1' AND _displayFlg == false")
            for dbElement in selectedList {
                rockedDisplayOrderList.append(dbElement._displayOrder)
            }
            
            let selectedStarList: Results<RankingStarTable> = saveStarList.filter("_num == '1' AND _displayFlg == false")
            for dbElement in selectedStarList {
                rockedDisplayOrderList.append(dbElement._displayOrder)
            }
        }
        
        var i: Int = 0
        for rankingViewModel in rankingViewModelList {
            // ロック中のランキングのインデックスは割り当てない
            while rockedDisplayOrderList.contains(i) {
                i += 1
            }
            
            switch rankingViewModel.rankingMode {
            case .normal:
                
                let selectedList: Results<DataBaseRecord> = saveList.filter("_idDate == '\(rankingViewModel.idDate)'")
                
                do {
                    let realm = getRealm()
                    try realm.write {
                        for dbElement in selectedList {
                            dbElement._displayOrder = i
                        }
                    }
                } catch {
                    
                }
                
            case .star:
                
                let selectedList: Results<RankingStarTable> = saveStarList.filter("_idDate == '\(rankingViewModel.idDate)'")
                
                do {
                    let realm = getRealm()
                    try realm.write {
                        for dbElement in selectedList {
                            dbElement._displayOrder = i
                        }
                    }
                } catch {
                    
                }
            }
            
            i += 1
        }
    }
    
    /// Realmに保存できるサイズの画像を取得する
    ///
    /// - Parameter image: 画像
    /// - Returns: リサイズした画像データ
    static func getImageDataForRealm(image: UIImage?) -> Data? {
        
        guard let image = image else { return nil }
        
        var resultData: Data?
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            
            var imageSize: Int = NSData(data: imageData).length
            // 16MB以上の場合
            if imageSize >= 16777216 {
                // 16MBより小さくなるまで圧縮
                while imageSize >= 16777216 {
                    resultData = image.jpegData(compressionQuality: 0.95)!
                    imageSize = NSData(data: resultData!).length
                }
            } else {
                resultData = imageData
            }
        }
        
        return resultData
    }
    
    /// DBに登録する
    static func saveRankingViewModelToDB(rankingViewModel: RankingViewModel,
                                         isEdit: Bool,
                                         gcp: GradientCircularProgress? = nil,
                                         callback: ((RankingViewModel) -> Void)? = nil) {
        
        let idDateEdit = rankingViewModel.idDate
        let updateDate = DateUtil.getNowDate()
        let displayOrder = rankingViewModel.displayOrder
        let displayFlg = rankingViewModel.isDisplay
        let starTitle1 = rankingViewModel.starTitle1
        let starTitle2 = rankingViewModel.starTitle2
        let starTitle3 = rankingViewModel.starTitle3
        let starTitle4 = rankingViewModel.starTitle4
        let starTitle5 = rankingViewModel.starTitle5
        
        let idDateForNew = DateUtil.getNowDate()
        
        if isEdit {
            // 現在のデータを削除
            DataBaseUtil.delete(idDate: idDateEdit, rankingMode: rankingViewModel.rankingMode)
            
            rankingViewModel.idDate = idDateEdit
            rankingViewModel.updateDate = updateDate
            rankingViewModel.displayOrder = displayOrder
            rankingViewModel.isDisplay = displayFlg
        } else {
            
            rankingViewModel.idDate = idDateForNew
            rankingViewModel.updateDate = idDateForNew
            rankingViewModel.displayOrder = 0
            rankingViewModel.isDisplay = true
        }
        
        var i = 0
        var progress: CGFloat = 1
        for rankingCellViewModel in rankingViewModel.rankingCellViewModelList {
            
            switch rankingViewModel.rankingMode {
            case .normal:
                
                let dbRecord = DataBaseRecord()
                
                // データを最小にするため、タイトルと背景画像は先頭の1つのレコードにのみ保存
                if i == 0 {
                    
                    dbRecord._majorTitle = rankingViewModel.mainTitle
                    dbRecord._backgroundImage = DataBaseUtil.getImageDataForRealm(image: rankingViewModel.mainImage)
                    i += 1
                    
                } else {
                    
                    dbRecord._majorTitle = ""
                    dbRecord._backgroundImage = nil
                }
                
                if isEdit {
                    
                    dbRecord._idDate = idDateEdit
                    dbRecord._updateDate = updateDate
                    dbRecord._displayOrder = displayOrder
                    dbRecord._displayFlg = displayFlg
                    
                } else {
                    
                    dbRecord._idDate = idDateForNew
                    dbRecord._updateDate = idDateForNew
                    dbRecord._sequence = ""
                    dbRecord._displayOrder = 0
                    dbRecord._displayFlg = true
                }
                
                dbRecord._num = String(rankingCellViewModel.num)
                dbRecord._cellTitle = rankingCellViewModel.rankTitle
                dbRecord._explanation = rankingCellViewModel.rankDescription
                
                DataBaseUtil.save(dbRecord)
                
            case .star:
                
                let rankingStarTable = RankingStarTable()
                
                // データを最小にするため、タイトルと背景画像は先頭の1つのレコードにのみ保存
                if i == 0 {
                    
                    rankingStarTable._majorTitle = rankingViewModel.mainTitle
                    rankingStarTable._backgroundImage = DataBaseUtil.getImageDataForRealm(image: rankingViewModel.mainImage)
                    i += 1
                    
                } else {
                    
                    rankingStarTable._majorTitle = ""
                    rankingStarTable._backgroundImage = nil
                }
                
                if isEdit {
                    
                    rankingStarTable._idDate = idDateEdit
                    rankingStarTable._updateDate = updateDate
                    rankingStarTable._displayOrder = displayOrder
                    rankingStarTable._displayFlg = displayFlg
                    
                } else {
                    
                    rankingStarTable._idDate = idDateForNew
                    rankingStarTable._updateDate = idDateForNew
                    rankingStarTable._displayOrder = 0
                    rankingStarTable._displayFlg = true
                }
                
                rankingStarTable._starTitle1 = starTitle1
                rankingStarTable._starTitle2 = starTitle2
                rankingStarTable._starTitle3 = starTitle3
                rankingStarTable._starTitle4 = starTitle4
                rankingStarTable._starTitle5 = starTitle5
                
                rankingStarTable._num = String(rankingCellViewModel.num)
                rankingStarTable._cellTitle = rankingCellViewModel.rankTitle
                rankingStarTable._explanation = rankingCellViewModel.rankDescription
                rankingStarTable._starNum1 = rankingCellViewModel.starNum1
                rankingStarTable._starNum2 = rankingCellViewModel.starNum2
                rankingStarTable._starNum3 = rankingCellViewModel.starNum3
                rankingStarTable._starNum4 = rankingCellViewModel.starNum4
                rankingStarTable._starNum5 = rankingCellViewModel.starNum5
                
                DataBaseUtil.save(rankingStarTable)
            }
            
            // UI関連処理のためメインスレッドで実行
            DispatchQueue.main.async {
                gcp?.updateRatio(progress / CGFloat(rankingViewModel.rankingCellViewModelList.count))
                progress += 1
            }
        }
        
        // 上記のUI関連処理を行うため、10m秒待った後にバックグラウンドで実行
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.01) {
            callback?(rankingViewModel)
        }
    }
}
