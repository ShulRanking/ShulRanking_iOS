//
//  HomeDetailsViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/12/24.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class HomeDetailsViewController: BaseModalViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    private let rankingViewModel: RankingViewModel
    
    init(rankingViewModel: RankingViewModel) {
        
        self.rankingViewModel = rankingViewModel
        
        super.init(nibName: "HomeDetailsViewController", bundle: nil, isCloseBackgroundTouch: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainImageView.setImageViewRect(targetImage: rankingViewModel.mainImage, rect: rankingViewModel.mainImageRect)
        
        LogUtil.logAnalytics(logName: "HDVC")
    }
}


