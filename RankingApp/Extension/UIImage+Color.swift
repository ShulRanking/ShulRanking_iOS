//
//  UIImage+Color.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/12.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 画像の色を変更する
    func chageImageColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
}
