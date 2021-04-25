//
//  UIView+Border.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/02.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

extension UIView {

    /// 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    /// 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// 角丸設定
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
