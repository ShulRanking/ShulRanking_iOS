//
//  NotificationViewProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/11.
//

import UIKit

protocol NotificationViewProtocol: class {
    
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?)
}
