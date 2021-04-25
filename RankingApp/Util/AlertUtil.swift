//
//  AlertUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/03/02.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

class AlertUtil {
    
    static func showAlert(vc: UIViewController,
                          message: String,
                          displayTime: Double,
                          callback: (() -> Void)? = nil) {
        
        let alertVC = OriginalAlertViewController(
            descriptionText: message,
            isCloseBackgroundTouch: false)
        
        vc.present(alertVC, animated: true) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + displayTime) {
                
                alertVC.dismiss(animated: true, completion: callback)
            }
        }
    }
    
    static func showNetworkAlert(vc: UIViewController) {
        showAlert(vc: vc, message: "ネットワークに接続してください。", displayTime: 0.5)
    }
}
