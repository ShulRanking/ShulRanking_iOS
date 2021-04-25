//
//  UIButton+switch.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/12.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

extension UIButton {

    func switchAction(onAction: @escaping () -> Void, offAction: @escaping () -> Void) {
        // 選択状態を反転
        isSelected = !isSelected

        switch isSelected {
        case true:
            onAction()
        case false:
            offAction()
        }
    }
}
