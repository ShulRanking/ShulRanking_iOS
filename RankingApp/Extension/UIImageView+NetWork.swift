//
//  UIImageView+NetWork.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/06/19.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    
    /// カラーモードに応じた画像をImageViewに設定
    /// - Parameters:
    ///   - vc: UIViewControllerのインスタンス
    ///   - urlD: ダークモードの場合のURL
    ///   - urlL: ライトモードの場合のURL   
    func setImageUrl(urlD: String, urlL: String) {
        
        let imageUrlStr = OtherUtil.getUrlAccordingColor(urlD: urlD, urlL: urlL)
        af.setImage(withURL: URL(string: imageUrlStr)!, placeholderImage: Constants.LOGO_SIDE_IMAGE)
    }
}
