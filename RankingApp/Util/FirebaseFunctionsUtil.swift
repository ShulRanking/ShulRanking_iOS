//
//  FirebaseFunctionsUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/12/08.
//

import Firebase
import FirebaseFunctions

final class FirebaseFunctionsUtil {
    
    static let shared = FirebaseFunctionsUtil()
    
    private init() {}
    
    func callGetServerTime() {
        
        let functions = Functions.functions()
        
        functions.httpsCallable("serverTime").call() { result, error in
            
            if let error = error as NSError? {
                
                if error.domain == FunctionsErrorDomain {
                    
                    return
                }
            }
        }
    }
}
