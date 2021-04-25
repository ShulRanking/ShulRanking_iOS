//
//  RankingForJson.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/01.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

struct RankingForJson: Codable {
    
    var appVersion: String = Constants.APP_VERSION
    
    let filePathAndName: String
    
    let idDate: String
    
    let updateDate: String
    
//    let displayOrder: Int
    
    let isDisplay: Bool
    
    let imageRatioType: String
    
    let existMainImage: Bool
    
    var mainImageData: Data?
    
    let mainImageRectX: Float?
    
    let mainImageRectY: Float?
    
    let mainImageRectWidth: Float?
    
    let mainImageRectHeight: Float?
    
    let mainTitle: String
    
    let starTitle1: String?
    
    let starTitle2: String?
    
    let starTitle3: String?
    
    let starTitle4: String?
    
    let starTitle5: String?
    
    /// JSON encode した際にアルファベットでプロパティがソートされるためzzzをつけてこのプロパティを末尾に指定
    var zzzRankingCellForJsonList: [RankingCellForJson]

    struct RankingCellForJson: Codable {

        let num: Int
        
        let existImage: Bool

        var imageData: Data?
        
        let imageRectX: Float?
        
        let imageRectY: Float?
        
        let imageRectWidth: Float?
        
        let imageRectHeight: Float?

        let rankTitle: String

        let rankDescription: String

        let starNum1: Int?

        let starNum2: Int?

        let starNum3: Int?

        let starNum4: Int?

        let starNum5: Int?
    }
    
    func createRankingViewModel() -> RankingViewModel {
        
        let rankingViewModel = RankingViewModel()
        
        rankingViewModel.idDate = idDate
        rankingViewModel.updateDate = updateDate
        rankingViewModel.mainTitle = mainTitle
//        rankingViewModel.displayOrder = displayOrder
        rankingViewModel.isDisplay = isDisplay
        rankingViewModel.imageRatioType = ImageRatioType.getEnumBy(rawValue: imageRatioType)
        
        if let data = mainImageData {
            
            rankingViewModel.mainImage = UIImage(data: data)
            
            rankingViewModel.mainImageRectX = mainImageRectX
            rankingViewModel.mainImageRectY = mainImageRectY
            rankingViewModel.mainImageRectWidth = mainImageRectWidth
            rankingViewModel.mainImageRectHeight = mainImageRectHeight
        }
        
        if let starTitle1 = starTitle1 {
            
            rankingViewModel.rankingMode = .star
            rankingViewModel.starTitle1 = starTitle1
            rankingViewModel.starTitle2 = starTitle2!
            rankingViewModel.starTitle3 = starTitle3!
            rankingViewModel.starTitle4 = starTitle4!
            rankingViewModel.starTitle5 = starTitle5!
            
        } else {
            
            rankingViewModel.rankingMode = .normal
        }
            
        for rankingCellForJson in zzzRankingCellForJsonList {
            
            let rankingCellViewModel = RankingCellViewModel()
            
            rankingCellViewModel.num = rankingCellForJson.num
            rankingCellViewModel.rankTitle = rankingCellForJson.rankTitle
            rankingCellViewModel.rankDescription = rankingCellForJson.rankDescription
            
            if let data = rankingCellForJson.imageData {
                
                rankingCellViewModel.image = UIImage(data: data)
                
                rankingCellViewModel.imageRectX = rankingCellForJson.imageRectX
                rankingCellViewModel.imageRectY = rankingCellForJson.imageRectY
                rankingCellViewModel.imageRectWidth = rankingCellForJson.imageRectWidth
                rankingCellViewModel.imageRectHeight = rankingCellForJson.imageRectHeight
            }
            
            if starTitle1 != nil {
                
                rankingCellViewModel.starNum1 = rankingCellForJson.starNum1!
                rankingCellViewModel.starNum2 = rankingCellForJson.starNum2!
                rankingCellViewModel.starNum3 = rankingCellForJson.starNum3!
                rankingCellViewModel.starNum4 = rankingCellForJson.starNum4!
                rankingCellViewModel.starNum5 = rankingCellForJson.starNum5!
            }
            
            rankingViewModel.rankingCellViewModelList.append(rankingCellViewModel)
        }
        
        return rankingViewModel
    }
}
