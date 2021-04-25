//
//  NotificationDetailsViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/12/01.
//

import UIKit

class NotificationDetailsViewController: BaseModalViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private let image: UIImage?
    
    init(image: UIImage?) {
        
        self.image = image
        
        super.init(nibName: "NotificationDetailsViewController", bundle: nil, isCloseBackgroundTouch: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        LogUtil.logAnalytics(logName: "NotDVC")
    }
}


