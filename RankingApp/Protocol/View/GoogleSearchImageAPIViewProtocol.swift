//
//  GoogleSearchImageAPIViewProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/21.
//

import UIKit

protocol GoogleSearchImageAPIViewProtocol: class {
    
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?)
    func dismissSelfVC(completion: (() -> Void)?)
    func reloadCollectionView()
    func setSearchWord(word: String)
    func setFitFillButtonImage(image: UIImage)
    func hideKeyboard()
}
