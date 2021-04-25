//
//  Data+UIImage.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/28.
//

import UIKit

extension Data {
    
    /// Data -> UIImage
    func toUIImage() -> UIImage? {
        
        UIImage(data: self)
    }
}
