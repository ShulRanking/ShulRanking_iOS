//
//  SettingViewProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/21.
//

import UIKit

protocol SettingViewProtocol: class {
    
    func showNetworkAlert()
    func pushVC(nextVC: UIViewController)
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?)
}
