//
//  UIViewController+Child.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/10/02.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// ビューコントローラーをビューへ割当
    /// - Parameters:
    ///   - vc: ビューコントローラー
    ///   - container: 登録するビュー
    func addViewController(vc: UIViewController, container: UIView) {
        addChild(vc)
        vc.view.frame = container.bounds
        container.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    /// ビューコントローラーをビューから削除
    /// - Parameter vc: ビューコントローラー
    func removeViewController(vc: UIViewController) {
        vc.willMove(toParent: self)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
