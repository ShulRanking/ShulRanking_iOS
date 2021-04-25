//
//  PremiumSearchImageAPIViewProtocol.swift
//  ShulRanking
//
//  Created by 佐々木英彦 on 2021/02/20.
//

import UIKit

protocol PremiumSearchImageAPIViewProtocol: class {
    
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?)
    func dismissSelfVC(completion: (() -> Void)?)
    func hideKeyboard()
    func reloadCollectionView()
    func setSearchWord(word: String)
    func setFitFillButtonImage(image: UIImage)
    func setDecreaseImageSearchRemainingCount(text: String)
}
