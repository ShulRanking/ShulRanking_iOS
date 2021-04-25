//
//  CreateEditStarTableViewCellDelegate.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/12.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

protocol CreateEditStarTableViewCellDelegate: class {
    
    func starEditing(cell: BaseEditTableViewCell, starNumArray: [Int])
    func starTextFieldDidEndEditing(text: String, titleIndex: Int)
}
