//
//  SettingThisAppViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/12/05.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit
import MessageUI
import YMTGetDeviceName

class SettingThisAppViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellTitle: String = "title"
    private let icon: String = "icon"
    private let segue: String = "segue"
    private let url: String = "url"
    private let logName: String = "logName"
    
    private var titleIconDictionalyArray: [[String: Any]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cellType: SettingEntryTableViewCell.self)
        
        titleIconDictionalyArray = [
            [cellTitle: "バージョン", icon: UIImage(named: "version")!],
            [cellTitle: "オープンソースライブラリ", icon: UIImage(named: "library")!, segue: Constants.TO_WEB_VIEW, url: "https://shul-ranking.firebaseapp.com/open_source_library.html", logName: "SetVC_OpenSource"],
            [cellTitle: "使用しているアイコン", icon: UIImage(named: "icon")!, segue: Constants.TO_WEB_VIEW, url: "https://shul-ranking.firebaseapp.com/used_icon.html", logName: "SetVC_UsedIcon"],
            [cellTitle: "デペロッパーへご連絡", icon: UIImage(named: "comment")!, segue: Constants.TO_MAIL]
        ]

        navigationItem.title = "このアプリについて"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - UITableViewDataSource
extension SettingThisAppViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleIconDictionalyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: SettingEntryTableViewCell.self, for: indexPath)
        cell.setData(index: indexPath.row,
                     text: titleIconDictionalyArray[indexPath.row][cellTitle] as! String,
                     image: titleIconDictionalyArray[indexPath.row][icon] as! UIImage)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingThisAppViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        var selectedSegue: String = ""
            
        if let segue = titleIconDictionalyArray[indexPath.row][segue] {
            
             selectedSegue = segue as! String
        }
        
        if Constants.TO_SETTING_RESULT == selectedSegue {
            
        } else if Constants.TO_WEB_VIEW == selectedSegue {

            guard NetworkUtil.isOnline() else {
                
                AlertUtil.showNetworkAlert(vc: self)
                
                return
            }
            
            tabBarController?.tabBar.isHidden = true
            
            // 遷移後の戻るボタンの文字を消しておく
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            let urlStr = titleIconDictionalyArray[indexPath.row][url] as! String
            let navigationBarTitle = titleIconDictionalyArray[indexPath.row][cellTitle] as! String
            
            let settingWebVC = SettingWebViewController(url: urlStr, navigationBarTitle: navigationBarTitle)
            navigationController?.pushViewController(settingWebVC, animated: true)
            
            LogUtil.logAnalytics(logName: titleIconDictionalyArray[indexPath.row][logName] as! String)
            
        } else if Constants.TO_MAIL == selectedSegue {
            
            if MFMailComposeViewController.canSendMail() {
                
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                // 宛先アドレス
                mail.setToRecipients([Constants.MAIL_ADDRESS])
                
                // 件名
                mail.setSubject(titleIconDictionalyArray[indexPath.row][cellTitle] as! String)
                // 本文
                mail.setMessageBody(
                    "\n\n\n------------------------------------\n アプリバージョン: \(Constants.APP_VERSION)\n OSバージョン: \(UIDevice.current.systemVersion)\n デバイス: \(YMTGetDeviceName.share.getDeviceName())\n ID: \(Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.USER_ID)!)\n ------------------------------------"
                    , isHTML: false)
                
                present(mail, animated: true)
                
            } else {
                
                let alert = UIAlertController(title: "", message: "メールアプリを起動できませんでした。\n専用アプリをインストールしていないか、メール送信用のアカウントが設定されていない可能性があります。", preferredStyle: .alert)
                
                present(alert, animated: true) {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        
                        // アラートを閉じる
                        alert.dismiss(animated: true)
                    }
                }
            }
            
            return
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingThisAppViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
            
        case .saved:
            break
            
        case .sent:
            break
            
        default:
            break
        }
        
        dismiss(animated: true)
    }
}
