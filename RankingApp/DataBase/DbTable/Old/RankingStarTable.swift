//
//  RankingStarTable.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/02/11.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import Foundation
import RealmSwift

class RankingStarTable: Object {
    
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
  
    @objc dynamic var _starNum1: Int = 0
  
    @objc dynamic var _starTitle1: String = ""
  
    @objc dynamic var _starNum2: Int = 0
  
    @objc dynamic var _starTitle2: String = ""
  
    @objc dynamic var _starNum3: Int = 0
  
    @objc dynamic var _starTitle3: String = ""
  
    @objc dynamic var _starNum4: Int = 0
  
    @objc dynamic var _starTitle4: String = ""
  
    @objc dynamic var _starNum5: Int = 0
  
    @objc dynamic var _starTitle5: String = ""
}
