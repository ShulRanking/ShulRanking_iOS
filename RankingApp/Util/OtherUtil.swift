//
//  OtherUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/03/02.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

class OtherUtil {
    
    /// 現在最前面で表示しているViewControllerを取得する
    /// - Returns: 最前面で表示しているViewController
    static func getTopViewController() -> UIViewController? {
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            
            var topViewController: UIViewController = rootViewController

            while let presentedViewController = topViewController.presentedViewController {
                
                topViewController = presentedViewController
            }

            return topViewController
            
        } else {
            
            return nil
        }
    }
    
    /// カラーモードに応じたURLを返却
    /// - Parameters:
    ///   - urlD: ダークモードの場合のURL
    ///   - urlL: ライトモードの場合のURL
    /// - Returns: カラーモードに応じたURL
    static func getUrlAccordingColor(urlD: String, urlL: String) -> String {
        
        if #available(iOS 13.0, *), OtherUtil.getTopViewController()?.traitCollection.userInterfaceStyle == .dark {
            
            return urlD
            
        } else {
            
            return urlL
        }
    }
    
    /// 指定した桁の乱数を生成
    /// - Parameter length: 桁数
    /// - Returns: 生成された乱数
    static func randomString(length: Int) -> String {

        let letters: NSString = "0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
}
