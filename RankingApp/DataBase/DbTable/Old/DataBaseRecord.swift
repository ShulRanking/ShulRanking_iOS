//
//  RankingTable.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/28.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseRecord: Object {
    
    @objc dynamic var _idDate: String = ""
 
    @objc dynamic var _updateDate: String = ""
 
    @objc dynamic var _sequence: String = ""
 
    @objc dynamic var _displayOrder: Int = 0
 
    @objc dynamic var _displayFlg: Bool = true
 
    @objc dynamic var _majorTitle: String = ""
 
    @objc dynamic var _backgroundImage: Data?
 
    @objc dynamic var _num: String = ""
 
    @objc dynamic var _image: Data?
 
    @objc dynamic var _cellTitle: String = ""
 
    @objc dynamic var _explanation: String = ""
     
    @objc dynamic var _additionalData: String = ""
         
    @objc dynamic var _isExistData: Bool = true
}
