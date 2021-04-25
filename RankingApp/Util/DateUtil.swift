//
//  DateUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/01/11.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import Foundation

class DateUtil {
    
    static func getNowDate() -> String {

        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        return formatter.string(from: now as Date)
    }
    
    /// String -> Date
    static func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    /// Date -> String
    static func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

