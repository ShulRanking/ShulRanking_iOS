//
//  GoogleSearchImageAPIViewPresenterProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/21.
//

import UIKit

protocol GoogleSearchImageAPIViewPresenterProtocol {
    
    func viewDidLoad()
    func getImageRatioType() -> ImageRatioType
    func getImageList() -> [UIImage]
    func getIsFit() -> Bool
    func textFieldReturnTapped(searchWord: String)
    func itemSelected(index: Int)
    func fitTapped()
    func searchTapped()
    func suarchMoreTapped()
}
