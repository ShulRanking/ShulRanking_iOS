//
//  RankingCellRealmModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/27.
//

import RealmSwift

class RankingCellRealmModel: Object {
    
    @objc dynamic var num: Int = 0
    
    @objc dynamic var rankTitle: String?
    
    @objc dynamic var rankDescription: String?
    
    @objc dynamic var imageData: Data?
    
    var imageRectX: RealmOptional<Float> = RealmOptional<Float>()
    
    var imageRectY: RealmOptional<Float> = RealmOptional<Float>()
    
    var imageRectWidth: RealmOptional<Float> = RealmOptional<Float>()
    
    var imageRectHeight: RealmOptional<Float> = RealmOptional<Float>()
            
    @objc dynamic var starNum1: Int = 0
    
    @objc dynamic var starNum2: Int = 0
    
    @objc dynamic var starNum3: Int = 0
    
    @objc dynamic var starNum4: Int = 0
    
    @objc dynamic var starNum5: Int = 0
}
