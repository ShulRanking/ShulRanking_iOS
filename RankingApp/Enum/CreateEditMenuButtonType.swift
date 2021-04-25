//
//  CreateEditMenuButtonType.swift
//  ShulRanking
//
//  Created by 佐々木英彦 on 2021/03/14.
//

enum CreateEditMenuButtonType: String, CaseIterable {
    
    case searchGoogle = "Google画像検索"
    case searchPremium = "画像検索(premium)"
    case selectAlbum = "アルバムから選択"
    case searchWebView = "Web画像検索"
    case edit = "現在の画像を編集"
    case delete = "現在の画像を削除"
    case cancel = "キャンセル" //Constants.BUTTON_NAME_CANCELを本当は設定したい。 ※Error -> Raw value for enum case must be a literal
    
    static func getEnumBy(rawValue: String?) -> CreateEditMenuButtonType {
        
        allCases.first { $0.rawValue == rawValue } ?? .cancel
    }
}
