//
//  UIView+Image.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/11.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

extension UIView {
    
    /// viewを画像にする
    func convertToUIImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 対象のViewを指定したrectで切り取りUIImageとして取得
    /// - Parameters:
    ///   - rect: 切り取る座標と大きさ
    /// - Returns: 切り取り結果
    func clipView(rect: CGRect?) -> UIImage? {
        
        guard let frameRect = rect else {
            return nil
        }
        
        // ビットマップ画像のcontextを作成
        UIGraphicsBeginImageContextWithOptions(frameRect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        // Affine変換
        let affineMoveLeftTop = CGAffineTransform(translationX: -frameRect.origin.x, y: -frameRect.origin.y)
        context.concatenate(affineMoveLeftTop)
        
        // 対象のview内の描画をcontextに複写する.
        layer.render(in: context)
        
        // 現在のcontextのビットマップをUIImageとして取得.
        let clippedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // contextを閉じる.
        UIGraphicsEndImageContext()
        
        return clippedImage
    }
}
