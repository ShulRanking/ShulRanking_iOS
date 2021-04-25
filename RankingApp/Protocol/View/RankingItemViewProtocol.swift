//
//  RankingItemViewProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/19.
//

import UIKit

protocol RankingItemViewProtocol: class {
    
    func setTitleName(title: String)
    func setTableViewCellHeight(height: Float)
    func flashCell(index: Int)
    func scrollTableView(index: Int, animated: Bool)
    func reloadTableView()
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?)
}
