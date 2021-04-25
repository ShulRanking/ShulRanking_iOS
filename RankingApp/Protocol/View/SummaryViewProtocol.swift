//
//  SummaryViewProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/20.
//

import UIKit

protocol SummaryViewProtocol: class {
    
    func setEditMode(isEdit: Bool, image: UIImage)
    func reloadTableView()
    func deleteRow(index: Int)
    func pushVC(nextVC: UIViewController)
}
