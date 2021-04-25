//
//  RankingRealmModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/27.
//

import RealmSwift

class RankingRealmModel: Object {
    
    @objc dynamic var idDate: String?
        
    @objc dynamic var updateDate: String?
    
    @objc dynamic var mainTitle: String?
    
    @objc dynamic var rankingModeStr: String!
    
    @objc dynamic var displayOrder: Int = 0
    
    @objc dynamic var isDisplay: Bool = true
    
    @objc dynamic var imageRatioType: String?
    
    @objc dynamic var mainImageData: Data?
    
    var mainImageRectX: RealmOptional<Float> = RealmOptional<Float>()
    
    var mainImageRectY: RealmOptional<Float> = RealmOptional<Float>()
    
    var mainImageRectWidth: RealmOptional<Float> = RealmOptional<Float>()
    
    var mainImageRectHeight: RealmOptional<Float> = RealmOptional<Float>()
    
    @objc dynamic var starTitle1: String?
    
    @objc dynamic var starTitle2: String?
    
    @objc dynamic var starTitle3: String?
    
    @objc dynamic var starTitle4: String?
    
    @objc dynamic var starTitle5: String?
    
    var rankingCellRealmModelList: List<RankingCellRealmModel> = List<RankingCellRealmModel>()
    
    /// プライマリーキーの定義
    override public static func primaryKey() -> String? {
        "idDate"
    }

//    private enum CodingKeys: String, CodingKey {
//
//        case idDate
//        case updateDate
//        case mainTitle
//        case rankingModeStr
//        case displayOrder
//        case isDisplay
//        case mainImageData
//        case mainImageRectX
//        case mainImageRectY
//        case mainImageRectWidth
//        case mainImageRectHeight
//        case starTitle1
//        case starTitle2
//        case starTitle3
//        case starTitle4
//        case starTitle5
//        case rankingCellRealmModelList
//    }
//
//    required convenience public init(from decoder: Decoder) throws {
//        self.init()
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        id = try container.decode(Int.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        isFromJapan = try container.decode(Bool.self, forKey: .isFromJapan)
//        favoriteSong = try container.decodeIfPresent(String.self, forKey: .favoriteSong)
//        age.value = try container.decodeIfPresent(Int.self, forKey: .age)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//        let birthdayStr = try container.decode(String.self, forKey: .birthday)
//        birthday = dateFormatter.date(from: birthdayStr)!
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(isFromJapan, forKey: .isFromJapan)
//        try container.encode(favoriteSong, forKey: .favoriteSong)
//        try container.encode(age.value, forKey: .age)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//        dateFormatter.timeZone = TimeZone.current
//        let bitrhdayStr = dateFormatter.string(from: birthday)
//        try container.encode(bitrhdayStr, forKey: .birthday)
//
//    }
}
