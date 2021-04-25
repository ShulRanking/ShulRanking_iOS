//
//  NotificationModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/11.
//

class NotificationModel {
    
    weak var delegate: NotificationModelProtocol?
    
    func logAnalytics(logName: String) {
        
        LogUtil.logAnalytics(logName: logName)
    }
}
