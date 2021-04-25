//
//  NetworkUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/12/24.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import Reachability

class NetworkUtil {
    
    /// ネットワークに接続されているかチェックする
    /// - Returns: true: 接続できている
    static func isOnline() -> Bool {
        
        guard let reachability = try? Reachability() else { return false }
        
        return reachability.connection != .unavailable
    }
    
//    static func isOnline() -> Bool {
//
//        let reachability = SCNetworkReachabilityCreateWithName(nil, "https://www.yahoo.co.jp/")!
//        var flags = SCNetworkReachabilityFlags.connectionAutomatic
//
//        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
//            return false
//        }
//
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//
//        return isReachable && !needsConnection
//    }
}
