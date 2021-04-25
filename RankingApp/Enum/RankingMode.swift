//
//  RankingModeEnum.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/10/16.
//

enum RankingMode: String, CaseIterable {
    
    case normal = "normal"
    case star = "star"
    
    static func getEnumBy(rawValue: String) -> RankingMode {
        
        allCases.first { $0.rawValue == rawValue } ?? .star
    }
}
