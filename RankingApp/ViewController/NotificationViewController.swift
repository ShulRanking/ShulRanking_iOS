//
//  NotificationViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/08.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    private var presenter: NotificationViewPresenterProtocol!
    
    /// お知らせの説明とアイコン
    private var titleIconDictionalyArray: [[String: String]] {
        presenter.getTitleIconDictionalyArray()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = NotificationViewPresenter(view: self)
        
        notificationTableView.register(cellType: NotificationTableViewCell.self)
        
        navigationItem.title = "お知らせ"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notificationTableView.flashScrollIndicators()
    }
}

// MARK: - UITableViewDataSource
extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleIconDictionalyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: NotificationTableViewCell.self, for: indexPath)
        
        cell.setData(index: indexPath.row,
                     ribbon: titleIconDictionalyArray[indexPath.row][Constants.RIBBON_TEXT]!,
                     text: titleIconDictionalyArray[indexPath.row][Constants.CELL_TITLE]!)
        
        cell.mainImageView.setImageUrl(urlD: titleIconDictionalyArray[indexPath.row][Constants.URL_D]!,
                                       urlL: titleIconDictionalyArray[indexPath.row][Constants.URL_L]!)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let notificationTableViewCell = tableView.cellForRow(at: indexPath) as? NotificationTableViewCell {
            
            presenter.cellTapped(image: notificationTableViewCell.mainImageView.image)
        }
    }
}

// MARK: - NotificationViewProtocol
extension NotificationViewController: NotificationViewProtocol {
    
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?) {
        
        present(nextVC, animated: true) {
            
            completion?()
        }
    }
}
