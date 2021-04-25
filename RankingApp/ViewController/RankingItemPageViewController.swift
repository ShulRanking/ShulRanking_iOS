//
//  RankingItemPageViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/27.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit
import Photos
import GradientCircularProgress

class RankingItemPageViewController: BaseTabPageViewController {
    
    var nowRankingVc: RankingItemViewController {
        viewControllers![0] as! RankingItemViewController
    }
    
    var rankingItemViewControllers: [RankingItemViewController] {
        pageViewControllers as! [RankingItemViewController]
    }
    
    private var rankingViewModel: RankingViewModel
    
    init(rankingViewModel: RankingViewModel,
         transitionStyle style: UIPageViewController.TransitionStyle,
         navigationOrientation: UIPageViewController.NavigationOrientation,
         options: [UIPageViewController.OptionsKey : Any]? = nil) {
        
        self.rankingViewModel = rankingViewModel
        
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers()
    }
    
    func setViewControllers() {
        
        // 各ページのVC作成
        RankingDisplayStyle.allCases.forEach {
            
            pageViewControllers.append(createVC(rankingDisplayStyle: $0))
        }
        
        // ランキング表示スタイルの選択値を取得
        let savedRankingDisplayStyle = RankingDisplayStyle.getEnumBy(rawValue: Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.RANKING_ITEM_STYLE))
        
        // 初期表示のViewControllerを指定
        setViewControllers([pageViewControllers[savedRankingDisplayStyle.getIndex()]], direction: .forward, animated: true)
    }

    func createVC(rankingDisplayStyle: RankingDisplayStyle) -> RankingItemViewController {
        
        RankingItemViewController(rankingViewModel: rankingViewModel, rankingDisplayStyle: rankingDisplayStyle)
    }
}
