//
//  PremiumSearchImageAPIModelProtocol.swift
//  ShulRanking
//
//  Created by 佐々木英彦 on 2021/02/20.
//

import UIKit

protocol PremiumSearchImageAPIModelProtocol: class {
    
    func impossibleSearhForCount()
    func responseErrorOccurred(error: Error?)
    func imageSearchedResult(imageList: [UIImage])
    func decreaseSearchable(count: Int)
}
