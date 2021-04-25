//
//  NotificationViewPresenterProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/11.
//

import UIKit

protocol NotificationViewPresenterProtocol {
    
    func getTitleIconDictionalyArray() -> [[String: String]]
    func cellTapped(image: UIImage?)
}
