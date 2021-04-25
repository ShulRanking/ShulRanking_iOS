//
//  NotificationViewPresenter.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/10.
//

import UIKit

class NotificationViewPresenter: NotificationViewPresenterProtocol {
    
    private weak var view: NotificationViewProtocol?
    private let model: NotificationModel
    
    /// お知らせの説明とアイコン
    private static let titleIconDictionalyArray: [[String: String]] = Constants.notificationTitleIconDictionalyArray
    
    required init(view: NotificationViewProtocol) {
        
        self.view = view
        
        model = NotificationModel()
        model.delegate = self
        
        model.logAnalytics(logName: "NotVC")
    }
    
    func getTitleIconDictionalyArray() -> [[String: String]] {
        NotificationViewPresenter.titleIconDictionalyArray
    }
    
    /// セルタップ
    func cellTapped(image: UIImage?) {
        
        // NotificationDetailsViewControllerへ
        let notificationDetailsVC = NotificationDetailsViewController(image: image)
        view?.presentVC(nextVC: notificationDetailsVC, completion: nil)
    }
}

// MARK: - NotificationModelProtocol
extension NotificationViewPresenter: NotificationModelProtocol {
    
}
