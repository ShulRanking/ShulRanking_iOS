//
//  CreateEditViewProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/12.
//

import UIKit
import GradientCircularProgress

protocol CreateEditViewProtocol: class {
    
    func setEdit()
    func setCreate()
    func setRankingModeButton(isHidden: Bool)
    func setSortButtonHidden(isHidden: Bool)
    func reloadTableView()
    func reloadRowsExceptStarHeader()
    func reloadRow(index: Int)
    func deleteRow(index: Int)
    func insertRow(index: Int)
    func showNetworkAlert()
    func pushVC(nextVC: UIViewController)
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?)
    func backVC()
    func showProgress(gcp: GradientCircularProgress)
    func endEditing()
}
