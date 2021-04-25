//
//  RankingDisplayStyle.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/10/16.
//

enum RankingDisplayStyle: String, CaseIterable {
    
    case title = "タイトル"
    case text = "テキスト"
    case imageMain = "イメージメイン"
    case standard = "スタンダード"
    case image11 = "イメージ(1:1)"
    case nankaKakkoii = "なんかかっこいい"
    
    static func getEnumBy(rawValue: String?) -> RankingDisplayStyle {
        
        allCases.first { $0.rawValue == rawValue } ?? .standard
    }
    
    func getIndex() -> Int {
        
        switch self {
        case .title:
            return 0
            
        case .text:
            return 1
            
        case .imageMain:
            return 2
            
        case .standard:
            return 3
            
        case .image11:
            return 4
            
        case .nankaKakkoii:
            return 5
        }
    }
    
    func getCellHeight(mode: RankingMode) -> Float {
        
        switch self {
        case .title:
            switch mode {
            case .normal:
                return 25
            case .star:
                return 110
            }
            
        case .text:
            switch mode {
            case .normal:
                return 80
            case .star:
                return 160
            }
            
        case .imageMain:
            switch mode {
            case .normal:
                return 110
            case .star:
                return 190
            }
            
        case .standard:
            switch mode {
            case .normal:
                return 80
            case .star:
                return 160
            }
            
        case .image11:
            switch mode {
            case .normal:
                return 80
            case .star:
                return 160
            }
            
        case .nankaKakkoii:
            switch mode {
            case .normal:
                return 80
            case .star:
                return 160
            }
        }
    }
    
    func isImage4to3() -> Bool {
        
        switch self {
        case .imageMain, .standard, .nankaKakkoii:
            return true
            
        default:
            return false
        }
    }
    
    func getNameForLog() -> String {
        
        switch self {
        case .title:
            return "title"
            
        case .text:
            return "text"
            
        case .imageMain:
            return "imageMain"
            
        case .standard:
            return "standard"
            
        case .image11:
            return "image11"
            
        case .nankaKakkoii:
            return "nankaKakkoii"
        }
    }
}
