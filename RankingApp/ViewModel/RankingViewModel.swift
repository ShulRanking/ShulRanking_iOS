//
//  RankingViewModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/23.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class RankingViewModel {
    
    var idDate: String = ""
    
    var updateDate: String = ""
    
    var mainTitle: String = ""
    
    var rankingMode: RankingMode = .normal
    
    var displayOrder: Int = 0
    
    var isDisplay: Bool = true
    
    var lastRunk: Int {
        
        rankingCellViewModelList.count
    }
    
    var imageRatioType: ImageRatioType = .ratio4to3
    
    var mainImage: UIImage?
    
    var mainImageRect: CGRect? {
        
        if let x = mainImageRectX,
           let y = mainImageRectY,
           let width = mainImageRectWidth,
           let height = mainImageRectHeight {
            
            return CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
            
        } else {
            
            return nil
        }
    }
    
    var mainImageRectX: Float?
    
    var mainImageRectY: Float?
    
    var mainImageRectWidth: Float?
    
    var mainImageRectHeight: Float?
    
    var starTitle1: String = ""
    
    var starTitle2: String = ""
    
    var starTitle3: String = ""
    
    var starTitle4: String = ""
    
    var starTitle5: String = ""
    
    var rankingCellViewModelList: [RankingCellViewModel] = []
    
    /// 引数で受け取ったインスタンスのプロパティで上書き
    /// - Parameter rankingViewModel: 上書きするインスタンス
    func overwrite(rankingViewModel: RankingViewModel) {
        
        idDate = rankingViewModel.idDate
        updateDate = rankingViewModel.updateDate
        mainTitle = rankingViewModel.mainTitle
        rankingMode = rankingViewModel.rankingMode
        displayOrder = rankingViewModel.displayOrder
        isDisplay = rankingViewModel.isDisplay
        imageRatioType = rankingViewModel.imageRatioType
        mainImage = rankingViewModel.mainImage
        mainImageRectX = rankingViewModel.mainImageRectX
        mainImageRectY = rankingViewModel.mainImageRectY
        mainImageRectHeight = rankingViewModel.mainImageRectHeight
        mainImageRectHeight = rankingViewModel.mainImageRectHeight
        starTitle1 = rankingViewModel.starTitle1
        starTitle2 = rankingViewModel.starTitle2
        starTitle3 = rankingViewModel.starTitle3
        starTitle4 = rankingViewModel.starTitle4
        starTitle5 = rankingViewModel.starTitle5
        rankingCellViewModelList = rankingViewModel.rankingCellViewModelList
    }
    
    /// 画像のrectをクリア
    func clearImageRect() {
        
        mainImageRectX = nil
        mainImageRectY = nil
        mainImageRectWidth = nil
        mainImageRectHeight = nil
    }
    
    /// selfに対応するJsonを作成
    func createJsonData() -> RankingForJson {
        
        var rankingCellForJsonList = [RankingForJson.RankingCellForJson]()
        
        for rankingCellViewModel in rankingCellViewModelList {
            
            var rankingCellForJson: RankingForJson.RankingCellForJson
            
            switch rankingMode {
            case .normal:
                rankingCellForJson = RankingForJson.RankingCellForJson(
                    num: rankingCellViewModel.num,
                    existImage: rankingCellViewModel.image != nil,
                    imageData: nil,
                    imageRectX: rankingCellViewModel.imageRectX,
                    imageRectY: rankingCellViewModel.imageRectY,
                    imageRectWidth: rankingCellViewModel.imageRectWidth,
                    imageRectHeight: rankingCellViewModel.imageRectHeight,
                    rankTitle: rankingCellViewModel.rankTitle,
                    rankDescription: rankingCellViewModel.rankDescription,
                    starNum1: nil,
                    starNum2: nil,
                    starNum3: nil,
                    starNum4: nil,
                    starNum5: nil)
                
            case .star:
                rankingCellForJson = RankingForJson.RankingCellForJson(
                    num: rankingCellViewModel.num,
                    existImage: rankingCellViewModel.image != nil,
                    imageData: nil,
                    imageRectX: rankingCellViewModel.imageRectX,
                    imageRectY: rankingCellViewModel.imageRectY,
                    imageRectWidth: rankingCellViewModel.imageRectWidth,
                    imageRectHeight: rankingCellViewModel.imageRectHeight,
                    rankTitle: rankingCellViewModel.rankTitle,
                    rankDescription: rankingCellViewModel.rankDescription,
                    starNum1: rankingCellViewModel.starNum1,
                    starNum2: rankingCellViewModel.starNum2,
                    starNum3: rankingCellViewModel.starNum3,
                    starNum4: rankingCellViewModel.starNum4,
                    starNum5: rankingCellViewModel.starNum5)
            }
            
            rankingCellForJsonList.append(rankingCellForJson)
        }
        
        var rankingForJson: RankingForJson
        
        // ファイルパスを作成
        // userIdを取得
        let userId = Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.USER_ID) ?? "NO USERID"
        // userIdの末尾14文字(インストール日時)を取得
        let instalTimeString = String(userId.suffix(14))
        // インストール日時をDateに変換
        let instalTimeDate = DateUtil.dateFromString(string: instalTimeString, format: "yyyyMMddHHmmss")
        // Stringに変換
        let formatInstalTime = DateUtil.stringFromDate(date: instalTimeDate, format: "yyyy_MMdd_HHmm_ss")
        // userIdからインストール日時部分を削除
        let userIdMinusInstalTime = userId.replacingOccurrences(of: instalTimeString, with:"")
        
        // ファイル名を作成
        // ランキングのid(idDate)をDateに変換
        let idDateDate = DateUtil.dateFromString(string: idDate, format: "yyyy/MM/dd HH:mm:ss")
        // Stringに変換
        let idDateString = DateUtil.stringFromDate(date: idDateDate, format: "yyyy_MMdd_HHmm_ss")
        
        let filePathAndName = formatInstalTime + "-" + userIdMinusInstalTime + "/" + idDateString
        
        switch rankingMode {
        case .normal:
            rankingForJson = RankingForJson(
                filePathAndName: filePathAndName,
                idDate: idDate,
                updateDate: updateDate,
//                displayOrder: displayOrder,
                isDisplay: isDisplay,
                imageRatioType: imageRatioType.rawValue,
                existMainImage: mainImage != nil,
                mainImageData: nil,
                mainImageRectX: mainImageRectX,
                mainImageRectY: mainImageRectY,
                mainImageRectWidth: mainImageRectWidth,
                mainImageRectHeight: mainImageRectHeight,
                mainTitle: mainTitle,
                starTitle1: nil,
                starTitle2: nil,
                starTitle3: nil,
                starTitle4: nil,
                starTitle5: nil,
                zzzRankingCellForJsonList: rankingCellForJsonList)
            
        case .star:
            rankingForJson = RankingForJson(
                filePathAndName: filePathAndName,
                idDate: idDate,
                updateDate: updateDate,
//                displayOrder: displayOrder,
                isDisplay: isDisplay,
                imageRatioType: imageRatioType.rawValue,
                existMainImage: mainImage != nil,
                mainImageData: nil,
                mainImageRectX: mainImageRectX,
                mainImageRectY: mainImageRectY,
                mainImageRectWidth: mainImageRectWidth,
                mainImageRectHeight: mainImageRectHeight,
                mainTitle: mainTitle,
                starTitle1: starTitle1,
                starTitle2: starTitle2,
                starTitle3: starTitle3,
                starTitle4: starTitle4,
                starTitle5: starTitle5,
                zzzRankingCellForJsonList: rankingCellForJsonList)
        }
        
        return rankingForJson
    }
}
