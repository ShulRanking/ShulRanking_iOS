//
//  MenuButtonType.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/12/16.
//

enum RankingMainMenuButtonType: String, CaseIterable {
    
    case shareByImage = "画像でシェア"
    case shareById = "IDでシェア"
    case lock = "ロック"
    case copy = "複製"
    case changeMode = "☆評価モードへ変更"
    case delete = "削除" //Constants.BUTTON_NAME_DELETEを本当は設定したい。 ※Error -> Raw value for enum case must be a literal
    case cancel = "キャンセル" //Constants.BUTTON_NAME_CANCELを本当は設定したい。 ※Error -> Raw value for enum case must be a literal
    
    static func getEnumBy(rawValue: String) -> RankingMainMenuButtonType {
        
        switch rawValue {
        case shareByImage.rawValue:
            return shareByImage
            
        case shareById.rawValue:
            return shareById
            
        case lock.rawValue, "ロック解除":
            return lock
            
        case copy.rawValue:
            return copy
            
        case changeMode.rawValue, "ノーマルモードへ変更":
            return changeMode
            
        case delete.rawValue:
            return delete
            
        case cancel.rawValue:
            return cancel
            
        default:
            return cancel
        }
    }
}
