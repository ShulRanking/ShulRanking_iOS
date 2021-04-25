//
//  LogUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/19.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import Firebase

class LogUtil {
    
    static func logAnalytics(logName: String) {
        
        #if RELEASE
        Analytics.logEvent(logName, parameters: nil)
        #endif
    }
}
