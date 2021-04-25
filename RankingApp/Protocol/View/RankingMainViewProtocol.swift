//
//  RankingMainViewProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/17.
//

import UIKit
import GradientCircularProgress

protocol RankingMainViewProtocol: class {
    
    func hidesBackButton()
    func setUpLeftBarButtonItem()
    func requestStoreReview()
    func pushVC(nextVC: UIViewController)
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?)
    func dismissVC(targetVC: UIViewController, completion: (() -> Void)?)
    func popToRootVC()
    func popToRootVCIfCreate()
    func showProgressView(gcp: GradientCircularProgress, isAtRatio: Bool, message: String?)
    func dismissProgressView(gcp: GradientCircularProgress)
    func showNetworkAlert()
    func writeToSavedPhotosAlbum(image: UIImage)
}
