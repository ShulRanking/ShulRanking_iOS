//
//  PremiumSearchImageAPIViewPresenterProtocol.swift
//  ShulRanking
//
//  Created by 佐々木英彦 on 2021/02/20.
//

import UIKit

protocol PremiumSearchImageAPIViewPresenterProtocol {
    
    func viewDidLoad()
    func getImageRatioType() -> ImageRatioType
    func getImageList() -> [UIImage]
    func getIsFit() -> Bool
    func textFieldReturnTapped(searchWord: String)
    func itemSelected(index: Int)
    func scrollViewWillBeginDragging()
    func fitTapped()
    func searchTapped()
    func suarchMoreTapped()
}
