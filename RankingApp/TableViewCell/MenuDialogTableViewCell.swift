//
//  MenuDialogTableViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/04.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

class MenuDialogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
    func setData(itemName: String) {
        
        itemLabel.text = itemName
        
        if itemName.contains(Constants.BUTTON_NAME_DELETE) {
            
            itemLabel.textColor = .red
            
        } else if itemName.contains(Constants.BUTTON_NAME_CANCEL) {
            
            itemLabel.textColor = ConstantsColor.OFFICIAL_ORANGE_100
        }
    }
}
