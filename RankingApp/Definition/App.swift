//
//  App.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/08/07.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

struct App {
    
    /// AppDelegete
    static let delegate = UIApplication.shared.delegate as! AppDelegate
    /// 画面サイズ
    static var windowSize: CGSize = UIScreen.main.bounds.size
    /// 画面横幅
    static var windowWidth: CGFloat = windowSize.width
    /// 画面縦幅
    static var windowHeight: CGFloat = windowSize.height
    /// navigationBar高さ
    static let navigationBarHeight: CGFloat = 44
    /// statusBar高さ
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
}
