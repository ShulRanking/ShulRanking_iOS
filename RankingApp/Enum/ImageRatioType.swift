//
//  ImageRatioType.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/02/13.
//

import UIKit

/// ランキングの画像比率
enum ImageRatioType: String, CaseIterable {
    
    case ratio4to3 = "4to3"
    case ratio1to1 = "1to1"
    
    func getIndex() -> Int {
        
        switch self {
        case .ratio4to3:
            return 0
            
        case .ratio1to1:
            return 1
        }
    }
    
    static func getEnumBy(index: Int) -> ImageRatioType {
        
        allCases.first { $0.getIndex() == index } ?? .ratio4to3
    }
    
    static func getEnumBy(rawValue: String?) -> ImageRatioType {
        
        allCases.first { $0.rawValue == rawValue } ?? .ratio4to3
    }
}
