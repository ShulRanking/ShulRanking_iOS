//
//  UIImageView+Rect.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/02/11.
//

import UIKit

extension UIImageView {
    
    /// 範囲を指定してImageViewにimageを設定
    /// - Parameters:
    ///   - targetImage: 格納する画像
    ///   - rect: 表示する画像の範囲
    func setImageViewRect(targetImage: UIImage?, rect: CGRect?) {
        
        if let x = rect?.minX,
           let y = rect?.minY,
           let width = rect?.width,
           let height = rect?.height {
            
            let cropFrame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
            
            image = targetImage?.croppedImage(withFrame: cropFrame, angle: 0, circularClip: false)
            
        } else {
            
            image = targetImage
        }
    }
}
