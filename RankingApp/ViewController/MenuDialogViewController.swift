//
//  MenuDialogViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/04.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

class MenuDialogViewController: BaseModalViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private let titleText: String?
    private let dataArray: [String]
    private let callback: (String) -> Void
    
    init(titleText: String? = nil,
         dataArray: [String],
         isCloseBackgroundTouch: Bool = true,
         callback: @escaping (String) -> Void) {
        
        self.titleText = titleText
        self.dataArray = dataArray
        self.callback = callback
        
        super.init(nibName: "MenuDialogViewController", bundle: nil, isCloseBackgroundTouch: isCloseBackgroundTouch)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 表示時のアニメーション設定
        setPopupViewForAnimation(modalView: popupView)
        
        tableView.register(cellType: MenuDialogTableViewCell.self)
        
        if let titleText = titleText {
            
            titleLabel.text = titleText
            
        } else {
            
            titleLabel.isHidden = true
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableViewHeightConstraint.constant = CGFloat(tableView.contentSize.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.flashScrollIndicators()
    }
}

// MARK: - UITableViewDataSource
extension MenuDialogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: MenuDialogTableViewCell.self, for: indexPath)
        
        cell.setData(itemName: dataArray[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MenuDialogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true)
        
        // ボタン選択結果返却
        callback(dataArray[indexPath.row])
    }
}
