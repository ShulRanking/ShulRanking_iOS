//
//  GoogleSearchImageAPIModelProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/21.
//

import UIKit

protocol GoogleSearchImageAPIModelProtocol: class {
    
    func responseErrorOccurred(error: Error?)
    func imageSearchedResult(imageList: [UIImage])
}
