//
//  CustomNavigationController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/01/05.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    private enum TabBarItem: Int {
        
        case HOME = 0
        case NOTIFICATION = 1
        case CREATE = 2
        case SUMMARY = 3
        case SETTING = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーのタイトルの文字色
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: ConstantsColor.DARK_GRAY_CUSTOM_100]
        
        switch tabBarItem.tag {
        
        case TabBarItem.HOME.rawValue:
            viewControllers.append(HomeViewController())
//            viewControllers.append(SplashViewController())
            
        case TabBarItem.NOTIFICATION.rawValue:
            viewControllers.append(NotificationViewController())
            
        case TabBarItem.CREATE.rawValue:
            viewControllers.append(CreateEditViewController(rankingViewModel: nil, isEdit: false))
            
        case TabBarItem.SUMMARY.rawValue:
            viewControllers.append(SummaryViewController())
            
        case TabBarItem.SETTING.rawValue:
            viewControllers.append(SettingViewController())
            
        default:
            break
        }
    }
}
