//
//  NSObject+.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/10/11.
//

import Foundation

extension NSObject {
    
    /// クラス名
    static var className: String {
        String(describing: self)
    }
    
    var className: String {
        type(of: self).className
    }
}
