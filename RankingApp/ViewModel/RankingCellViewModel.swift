//
//  RankingCellViewModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/20.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class RankingCellViewModel {
    
    var num: Int = 0
    
    var rankTitle: String = ""
    
    var rankDescription: String = ""
    
    /// セルの画像(表示用)
    var image: UIImage?
    
    var imageRect: CGRect? {
        
        if let x = imageRectX,
           let y = imageRectY,
           let width = imageRectWidth,
           let height = imageRectHeight {
            
            return CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
            
        } else {
            
            return nil
        }
    }
    
    var imageRectX: Float?
    
    var imageRectY: Float?
    
    var imageRectWidth: Float?
    
    var imageRectHeight: Float?
            
    var starNum1: Int = 0
    
    var starNum2: Int = 0
    
    var starNum3: Int = 0
    
    var starNum4: Int = 0
    
    var starNum5: Int = 0
    
    var starSum: Int {
        
        starNum1 + starNum2 + starNum3 + starNum4 + starNum5
    }
    
    /// 画像のrectをクリア
    func clearImageRect() {
        
        imageRectX = nil
        imageRectY = nil
        imageRectWidth = nil
        imageRectHeight = nil
    }
}
