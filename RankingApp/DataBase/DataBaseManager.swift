//
//  DataBaseManager.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/25.
//

import RealmSwift
import GradientCircularProgress

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    private init() {}
    
    var isNeedFech: Bool = true
    /// 最新のランキングデータリスト
    private var newRankingViewModelList: [RankingViewModel]?
    
    func getRealm() -> Realm {
        
        // バージョンアップ時
        let config = Realm.Configuration(schemaVersion: UInt64(Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.NOW_VERSION)))
        let realm = try! Realm(configuration: config)
        
        #if DEBUG || ORIGINAL || DEVELOP
        // DBのパスを出力(シミュレータ用)
        print("Realm fileURL simurator: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        #endif
        
        return realm
    }
    
    /// DBの中間データの履歴を解放
    func compactRealm() {
        
        // Realm履歴削除
        // https://stackoverflow.com/questions/36877745/how-do-you-compact-a-realm-db-on-ios
        do {
            
            guard let defaultURL = Realm.Configuration.defaultConfiguration.fileURL else { return }
            
            let defaultParentURL = defaultURL.deletingLastPathComponent()
            let compactedURL = defaultParentURL.appendingPathComponent("compact.realm")
            
            autoreleasepool {
                
                try? getRealm().writeCopy(toFile: compactedURL)
            }
            
            try FileManager.default.removeItem(at: defaultURL)
            try FileManager.default.moveItem(at: compactedURL, to: defaultURL)
            
        } catch let error as NSError {
            
            print("Realm Error \(error)")
            print("Realm Error \(error.localizedDescription)")
        }
    }
    
    /// 初回インストール時用のサンプルランキングを作成とDBへの登録
    func insertInitialData() {
        
        let rankTitle = "title"
        let image = "image"
        let rankDescription = "description"
        
        let cellInfoDictionalyArray: [[String: Any]] = [
            [rankTitle: "Cairo", image: UIImage(named: "cityCairo")!, rankDescription: "砂漠とラクダとピラミッド！\n地球最古の歴史に触れたい。"],
            [rankTitle: "Hawaii", image: UIImage(named: "cityHawaii")!, rankDescription: "スカイダイビングしたり、ウミガメと泳いでみたい。\n思いっきりレジャーを楽しむ！"],
            [rankTitle: "Istanbul", image: UIImage(named: "cityIstanbul")!, rankDescription: "モスクとケバブとトルコアイス！\nそれに中東やヨーロッパの歴史をここから学びたい。"],
            [rankTitle: "Ukiha", image: UIImage(named: "cityUkiha")!, rankDescription: "帰省したい。"],
            [rankTitle: "NewYork", image: UIImage(named: "cityNewYork")!, rankDescription: "タイムズスクエアに自由の女神にウォール街！\n世界の中心と言われるこの場所に一度は行ってみたい！"],
            [rankTitle: "Sydney", image: UIImage(named: "citySydney")!, rankDescription: "海やエアーズロック。オーストラリアの壮大な自然や真逆の季節を楽しみたい。"],
            [rankTitle: "SaoPaulo", image: UIImage(named: "citySaoPaulo")!, rankDescription: "地球の裏側、南米でどんな文化や物や人たちがいるのか知りたい。"],
            [rankTitle: "Shanghai", image: UIImage(named: "cityShanghai")!, rankDescription: "急激に発展する経済都市をこの目でみてみたい。"],
            [rankTitle: "Manila", image: UIImage(named: "cityManila")!, rankDescription: "グリーンベルトやタガイタイで自然を感じたい。距離も遠くないし、ちょっとした連休で行けるかも。"],
            [rankTitle: "Barcelona", image: UIImage(named: "cityBarcelona")!, rankDescription: "サクラダファミリアやサッカーやスペイン料理！全て楽しみたい！"]
        ]
        
        let rankingViewModel = RankingViewModel()
        rankingViewModel.mainTitle = "Sample*いつか行きたい旅行先ランキング"
        rankingViewModel.mainImage = UIImage(named: "cityTop")
        rankingViewModel.rankingMode = .normal
        rankingViewModel.imageRatioType = .ratio4to3
        
        for (index, cellInfoDictionaly) in cellInfoDictionalyArray.enumerated() {
            
            let rankingCellViewModel = RankingCellViewModel()
            
            rankingCellViewModel.num = index + 1
            rankingCellViewModel.rankTitle = cellInfoDictionaly[rankTitle] as! String
            rankingCellViewModel.image = cellInfoDictionaly[image] as? UIImage
            rankingCellViewModel.rankDescription = cellInfoDictionaly[rankDescription] as! String
            
            rankingViewModel.rankingCellViewModelList.append(rankingCellViewModel)
        }
        
        saveRankingViewModelToDB(rankingViewModel: rankingViewModel, isEdit: false)
    }
    
    /// 特定のランキングデータを取得
    func getRankingViewModel(idDate: String) -> RankingViewModel {
        
        guard let rankingRealmModel = getRealm().object(ofType: RankingRealmModel.self, forPrimaryKey: idDate) else {
            
            fatalError("rankingRealmModel is nil")
        }
        
        let rankingViewModel = RankingViewModel()
        rankingViewModel.idDate = rankingRealmModel.idDate ?? ""
        rankingViewModel.updateDate = rankingRealmModel.updateDate ?? ""
        rankingViewModel.mainTitle = rankingRealmModel.mainTitle ?? ""
        rankingViewModel.displayOrder = rankingRealmModel.displayOrder
        rankingViewModel.isDisplay = rankingRealmModel.isDisplay
        rankingViewModel.imageRatioType = ImageRatioType.getEnumBy(rawValue: rankingRealmModel.imageRatioType)
        rankingViewModel.mainImageRectX = rankingRealmModel.mainImageRectX.value
        rankingViewModel.mainImageRectY = rankingRealmModel.mainImageRectY.value
        rankingViewModel.mainImageRectWidth = rankingRealmModel.mainImageRectWidth.value
        rankingViewModel.mainImageRectHeight = rankingRealmModel.mainImageRectHeight.value
        rankingViewModel.starTitle1 = rankingRealmModel.starTitle1 ?? ""
        rankingViewModel.starTitle2 = rankingRealmModel.starTitle2 ?? ""
        rankingViewModel.starTitle3 = rankingRealmModel.starTitle3 ?? ""
        rankingViewModel.starTitle4 = rankingRealmModel.starTitle4 ?? ""
        rankingViewModel.starTitle5 = rankingRealmModel.starTitle5 ?? ""
        rankingViewModel.mainImage = rankingRealmModel.mainImageData?.toUIImage()
        
        rankingViewModel.rankingMode = RankingMode.getEnumBy(rawValue: rankingRealmModel.rankingModeStr)
        
        for rankingCellRealmModel in rankingRealmModel.rankingCellRealmModelList {
            
            let rankingCellViewModel = RankingCellViewModel()
            rankingCellViewModel.num = rankingCellRealmModel.num
            rankingCellViewModel.rankTitle = rankingCellRealmModel.rankTitle ?? ""
            rankingCellViewModel.rankDescription = rankingCellRealmModel.rankDescription ?? ""
            rankingCellViewModel.imageRectX = rankingCellRealmModel.imageRectX.value
            rankingCellViewModel.imageRectY = rankingCellRealmModel.imageRectY.value
            rankingCellViewModel.imageRectWidth = rankingCellRealmModel.imageRectWidth.value
            rankingCellViewModel.imageRectHeight = rankingCellRealmModel.imageRectHeight.value
            rankingCellViewModel.starNum1 = rankingCellRealmModel.starNum1
            rankingCellViewModel.starNum2 = rankingCellRealmModel.starNum2
            rankingCellViewModel.starNum3 = rankingCellRealmModel.starNum3
            rankingCellViewModel.starNum4 = rankingCellRealmModel.starNum4
            rankingCellViewModel.starNum5 = rankingCellRealmModel.starNum5
            rankingCellViewModel.image = rankingCellRealmModel.imageData?.toUIImage()
            
            rankingViewModel.rankingCellViewModelList.append(rankingCellViewModel)
        }
        
        return rankingViewModel
    }
    
    /// データを保存
    func save(rankingRealmModel: RankingRealmModel) {
        
        isNeedFech = true
        
        do {
            
            let realm = getRealm()
            
            try realm.write {
                
                realm.add(rankingRealmModel)
            }
        } catch {
            
        }
    }
    
    /// 表示フラグを更新
    func updateIsDisplay(idDate: String) {
        
        isNeedFech = true
        
        do {
            
            let realm = getRealm()
            
            let results = realm.objects(RankingRealmModel.self).filter("idDate == '\(idDate)'")
            
            try realm.write {
                
                for result in results {
                    
                    result.isDisplay.toggle()
                }
            }
        } catch {
            
        }
    }
    
    /// データを削除
    func delete(idDate: String) {
        
        isNeedFech = true
        
        do {
            
            let realm = getRealm()
            
            guard let result = realm.objects(RankingRealmModel.self).filter("idDate == '\(idDate)'").first else { return }
            
            try realm.write {
                
                // リレーションシップのあるオブジェクトを削除
                // rankingRealmModelを消してもrankingRealmModel.rankingCellRealmModelListは自動的に消えないので先に消す
                realm.delete(result.rankingCellRealmModelList)
                
                // ランキング本体を削除
                realm.delete(result)
            }
        } catch {
            
        }
    }
    
    /// データ取り出し
    func selectRankingViewModelList() -> [RankingViewModel] {
        
        if !isNeedFech {
            
            guard let newRankingViewModelList = newRankingViewModelList else { fatalError("newRankingViewModelList is nil") }
            
            return newRankingViewModelList
        }
        
        var rankingViewModelList = [RankingViewModel]()
        
        let realm = getRealm()
        // ランキングデータ取得
        let saveList: Results<RankingRealmModel> = realm.objects(RankingRealmModel.self)
        
        for rankingRealmModel in saveList {
            
            let rankingViewModel = RankingViewModel()
            rankingViewModel.idDate = rankingRealmModel.idDate ?? ""
            rankingViewModel.updateDate = rankingRealmModel.updateDate ?? ""
            rankingViewModel.mainTitle = rankingRealmModel.mainTitle ?? ""
            rankingViewModel.displayOrder = rankingRealmModel.displayOrder
            rankingViewModel.isDisplay = rankingRealmModel.isDisplay
            rankingViewModel.imageRatioType = ImageRatioType.getEnumBy(rawValue: rankingRealmModel.imageRatioType)
            rankingViewModel.mainImageRectX = rankingRealmModel.mainImageRectX.value
            rankingViewModel.mainImageRectY = rankingRealmModel.mainImageRectY.value
            rankingViewModel.mainImageRectWidth = rankingRealmModel.mainImageRectWidth.value
            rankingViewModel.mainImageRectHeight = rankingRealmModel.mainImageRectHeight.value
            rankingViewModel.starTitle1 = rankingRealmModel.starTitle1 ?? ""
            rankingViewModel.starTitle2 = rankingRealmModel.starTitle2 ?? ""
            rankingViewModel.starTitle3 = rankingRealmModel.starTitle3 ?? ""
            rankingViewModel.starTitle4 = rankingRealmModel.starTitle4 ?? ""
            rankingViewModel.starTitle5 = rankingRealmModel.starTitle5 ?? ""
            rankingViewModel.mainImage = rankingRealmModel.mainImageData?.toUIImage()
            
            rankingViewModel.rankingMode = RankingMode.getEnumBy(rawValue: rankingRealmModel.rankingModeStr)
            
            for rankingCellRealmModel in rankingRealmModel.rankingCellRealmModelList {
                
                let rankingCellViewModel = RankingCellViewModel()
                rankingCellViewModel.num = rankingCellRealmModel.num
                rankingCellViewModel.rankTitle = rankingCellRealmModel.rankTitle ?? ""
                rankingCellViewModel.rankDescription = rankingCellRealmModel.rankDescription ?? ""
                rankingCellViewModel.imageRectX = rankingCellRealmModel.imageRectX.value
                rankingCellViewModel.imageRectY = rankingCellRealmModel.imageRectY.value
                rankingCellViewModel.imageRectWidth = rankingCellRealmModel.imageRectWidth.value
                rankingCellViewModel.imageRectHeight = rankingCellRealmModel.imageRectHeight.value
                rankingCellViewModel.starNum1 = rankingCellRealmModel.starNum1
                rankingCellViewModel.starNum2 = rankingCellRealmModel.starNum2
                rankingCellViewModel.starNum3 = rankingCellRealmModel.starNum3
                rankingCellViewModel.starNum4 = rankingCellRealmModel.starNum4
                rankingCellViewModel.starNum5 = rankingCellRealmModel.starNum5
                rankingCellViewModel.image = rankingCellRealmModel.imageData?.toUIImage()
                
                rankingViewModel.rankingCellViewModelList.append(rankingCellViewModel)
            }
            
            rankingViewModelList.append(rankingViewModel)
        }
        
        // ロックモードの場合
        if Constants.USER_DEFAULTS_STANDARD.bool(forKey: Constants.IS_LOCK) {
            
            var i: Int = 0
            for rankingViewModel in rankingViewModelList {
                
                // isDisplayがfalseの場合
                if !rankingViewModel.isDisplay {
                    
                    // 表示するリストから削除
                    rankingViewModelList.remove(at: i)
                    i -= 1
                }
                
                i += 1
            }
        }
        
        // displayOrderで昇順にソート
        rankingViewModelList = rankingViewModelList.sorted { a, b -> Bool in
            
            // displayOrderが同じ場合
            if a.displayOrder == b.displayOrder {
                
                // 日付で降順にソート
                return a.idDate > b.idDate
                
            } else {
                
                // displayOrderで昇順にソート
                return a.displayOrder < b.displayOrder
            }
        }
        
        newRankingViewModelList = rankingViewModelList
        isNeedFech = false
        
        return newRankingViewModelList!
    }
    
    /// displayOrderの書き換えを行い、データをソートする
    func updateDbSortedRankingViewModelList(rankingViewModelList: [RankingViewModel]) {
        
        isNeedFech = true
        
        let realm = getRealm()
        // 保存してあるデータを全て取得
        let saveList: Results<RankingRealmModel> = realm.objects(RankingRealmModel.self)
        
        var rockedDisplayOrderList = [Int]()
        
        // ロックモードの場合
        if Constants.USER_DEFAULTS_STANDARD.bool(forKey: Constants.IS_LOCK) {
            
            let selectedList: Results<RankingRealmModel> = saveList.filter("isDisplay == false")
            
            for selectedRankingViewModel in selectedList {
                
                rockedDisplayOrderList.append(selectedRankingViewModel.displayOrder)
            }
        }
        
        var i: Int = 0
        for rankingViewModel in rankingViewModelList {
            
            // ロック中のランキングのインデックスは割り当てない
            while rockedDisplayOrderList.contains(i) {
                
                i += 1
            }
            
            let selectedList: Results<RankingRealmModel> = saveList.filter("idDate == '\(rankingViewModel.idDate)'")
            
            do {
                
                let realm = getRealm()
                try realm.write {
                    
                    for selectedRankingViewModel in selectedList {
                        
                        selectedRankingViewModel.displayOrder = i
                    }
                }
            } catch {
                
            }
            
            i += 1
        }
    }
    
    /// RankingViewModelをDBに登録
    func saveRankingViewModelToDB(rankingViewModel: RankingViewModel,
                                  isEdit: Bool,
                                  gcp: GradientCircularProgress? = nil,
                                  callback: ((RankingViewModel) -> Void)? = nil) {
        
        if isEdit {
            
            let updateDate = DateUtil.getNowDate()
            
            rankingViewModel.updateDate = updateDate
            
        } else {
            
            let idDateForNew = DateUtil.getNowDate()
            
            rankingViewModel.idDate = idDateForNew
            rankingViewModel.updateDate = idDateForNew
        }
        
        let rankingRealmModel = RankingRealmModel()
        rankingRealmModel.idDate = rankingViewModel.idDate
        rankingRealmModel.updateDate = rankingViewModel.updateDate
        rankingRealmModel.mainTitle = rankingViewModel.mainTitle
        rankingRealmModel.displayOrder = rankingViewModel.displayOrder
        rankingRealmModel.isDisplay = rankingViewModel.isDisplay
        rankingRealmModel.imageRatioType = rankingViewModel.imageRatioType.rawValue
        rankingRealmModel.mainImageData = getImageDataForRealm(image: rankingViewModel.mainImage)
        rankingRealmModel.mainImageRectX.value = rankingViewModel.mainImageRectX
        rankingRealmModel.mainImageRectY.value = rankingViewModel.mainImageRectY
        rankingRealmModel.mainImageRectWidth.value = rankingViewModel.mainImageRectWidth
        rankingRealmModel.mainImageRectHeight.value = rankingViewModel.mainImageRectHeight
        rankingRealmModel.starTitle1 = rankingViewModel.starTitle1
        rankingRealmModel.starTitle2 = rankingViewModel.starTitle2
        rankingRealmModel.starTitle3 = rankingViewModel.starTitle3
        rankingRealmModel.starTitle4 = rankingViewModel.starTitle4
        rankingRealmModel.starTitle5 = rankingViewModel.starTitle5
        rankingRealmModel.rankingModeStr = rankingViewModel.rankingMode.rawValue
        
        var progress: CGFloat = 1
        for rankingCellViewModel in rankingViewModel.rankingCellViewModelList {
            
            let rankingCellRealmModel = RankingCellRealmModel()
            rankingCellRealmModel.num = rankingCellViewModel.num
            rankingCellRealmModel.rankTitle = rankingCellViewModel.rankTitle
            rankingCellRealmModel.rankDescription = rankingCellViewModel.rankDescription
            rankingCellRealmModel.imageRectX.value = rankingCellViewModel.imageRectX
            rankingCellRealmModel.imageRectY.value = rankingCellViewModel.imageRectY
            rankingCellRealmModel.imageRectWidth.value = rankingCellViewModel.imageRectWidth
            rankingCellRealmModel.imageRectHeight.value = rankingCellViewModel.imageRectHeight
            rankingCellRealmModel.starNum1 = rankingCellViewModel.starNum1
            rankingCellRealmModel.starNum2 = rankingCellViewModel.starNum2
            rankingCellRealmModel.starNum3 = rankingCellViewModel.starNum3
            rankingCellRealmModel.starNum4 = rankingCellViewModel.starNum4
            rankingCellRealmModel.starNum5 = rankingCellViewModel.starNum5
            rankingCellRealmModel.imageData = getImageDataForRealm(image: rankingCellViewModel.image)
            
            rankingRealmModel.rankingCellRealmModelList.append(rankingCellRealmModel)
            
            DispatchQueue.main.async {
                
                // プログレスビューを%で表示
                gcp?.updateRatio(progress / CGFloat(rankingViewModel.rankingCellViewModelList.count))
                progress += 1
            }
        }
        
        // 編集の場合
        if isEdit, !rankingViewModel.idDate.isEmpty {
            
            // 元のデータを削除
            delete(idDate: rankingViewModel.idDate)
        }
        
        // 新しいデータを保存
        save(rankingRealmModel: rankingRealmModel)
        
        // 10m秒待った後にバックグラウンドで実行
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.01) {
            
            callback?(rankingViewModel)
        }
    }
    
    /// UIImageをDataに圧縮して変換
    ///
    /// - Parameter image: 画像
    /// - Returns: リサイズした画像データ
    func getImageDataForRealm(image: UIImage?) -> Data? {
        
        guard let image = image, let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        var resultData: Data?
        var imageSize: Int = NSData(data: imageData).length
        
        // 200KB以上の場合
        if imageSize >= 200 {
            
            // 圧縮
            guard let compressedData = image.jpegData(compressionQuality: 0.5) else { return nil }
            
            imageSize = NSData(data: compressedData).length
            
            // 16MB以上の場合
            if imageSize >= 16777216 {
                
                return nil
            }
            
            resultData = compressedData
        }
        
        return resultData
    }
}
