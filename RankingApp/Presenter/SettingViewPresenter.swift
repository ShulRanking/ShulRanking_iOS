//
//  SettingViewPresenter.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/10.
//

import UIKit
import MessageUI
import YMTGetDeviceName

class SettingViewPresenter: SettingViewPresenterProtocol {
    
    private weak var view: SettingViewProtocol?
    private let model: SettingModel
    
    private let cellTitle: String = "title"
    private let icon: String = "icon"
    private let nextType: String = "nextType"
    private let url: String = "url"
    
    private let sectionTitleArray: [String] = [
        "オプション",
        "サポート",
        "その他"
    ]
    
    private lazy var titleIconDictionalyArray: [[[String: Any]]] = [
            [[cellTitle: "ロックとパスコード", icon: UIImage(named: "lock")!],
             [cellTitle: "編集時メッセージ", icon: UIImage(named: "lawLisk")!],
             [cellTitle: Constants.SETTING_SEARCH_ENGINE, icon: UIImage(named: "searchWeb")!]],
            [[cellTitle: "新機能のリクエスト", icon: UIImage(named: "idea")!, nextType: Constants.TO_MAIL],
             [cellTitle: "不具合のご報告", icon: UIImage(named: "support")!, nextType: Constants.TO_MAIL],
             [cellTitle: "レビューをする", icon: UIImage(named: "like")!, nextType: Constants.TO_REVIEW]],
            [[cellTitle: "アプリをシェア", icon: UIImage(named: "share")!, nextType: Constants.TO_APP_SHARE],
             [cellTitle: "プライバシーポリシー", icon: UIImage(named: "privacy")!, nextType: Constants.TO_WEB_VIEW, url: "https://shul-ranking.firebaseapp.com/privacy_policy.html"],
             [cellTitle: "このアプリについて", icon: UIImage(named: "info")!, nextType: Constants.TO_DETAIL_TABLE_VIEW]]
        ]
    
    init(view: SettingViewProtocol) {
        
        self.view = view
        
        model = SettingModel()
        model.delegate = self
    }
    
    func policyErrorOccurred() {
        
        let alertVC = OriginalAlertViewController(
            descriptionText: "現在利用できません。",
            isCloseBackgroundTouch: true)
        
        view?.presentVC(nextVC: alertVC) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                alertVC.dismiss(animated: true)
            }
        }
    }
    
    func getSectionTitleArray() -> [String] {
        sectionTitleArray
    }
    
    func getTitleIconDictionalyArray() -> [[[String: Any]]] {
        titleIconDictionalyArray
    }
    
    func itemSelected(indexSection: Int, indexRow: Int, mailComposeDelegate: MFMailComposeViewControllerDelegate) {
        
        if let segueType = titleIconDictionalyArray[indexSection][indexRow][nextType] as? String {
            
            switch segueType {
            case Constants.TO_WEB_VIEW:
                
                guard NetworkUtil.isOnline() else {
                    
                    view?.showNetworkAlert()
                    
                    return
                }
                
                let urlStr = titleIconDictionalyArray[indexSection][indexRow][url] as! String
                let navigationBarTitle = titleIconDictionalyArray[indexSection][indexRow][cellTitle] as! String
                
                switch navigationBarTitle {
                case "プライバシーポリシー":
                    
                    let settingWebVC = SettingWebViewController(url: urlStr, navigationBarTitle: navigationBarTitle)
                    view?.pushVC(nextVC: settingWebVC)
                    
                    model.logAnalytics(logName: "SetVC_PrivacyPolicy")
                    
                default:
                    break
                }
                
            case Constants.TO_DETAIL_TABLE_VIEW:
                
                let settingThisAppVC = SettingThisAppViewController()
                view?.pushVC(nextVC: settingThisAppVC)
                
            //            case Constants.SEGUE_SETTING_RESULT:
            //                break
            
            case Constants.TO_MAIL:
                
                if MFMailComposeViewController.canSendMail() {
                    
                    let mailVC = MFMailComposeViewController()
                    mailVC.mailComposeDelegate = mailComposeDelegate
                    // 宛先アドレス
                    mailVC.setToRecipients([Constants.MAIL_ADDRESS])
                    
                    let mode = titleIconDictionalyArray[indexSection][indexRow][cellTitle] as! String
                    // 件名
                    mailVC.setSubject(mode)
                    
                    switch mode {
                    case "新機能のリクエスト":
                        // 本文
                        mailVC.setMessageBody(
                            "\n\n\n------------------------------------\n アプリバージョン: \(Constants.APP_VERSION)\n OSバージョン: \(UIDevice.current.systemVersion)\n デバイス: \(YMTGetDeviceName.share.getDeviceName())\n ID: \(Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.USER_ID)!)\n ------------------------------------",
                            isHTML: false)
                        
                    case "不具合のご報告":
                        // 本文
                        mailVC.setMessageBody(
                            "\n\n\n------------------------------------\n アプリバージョン: \(Constants.APP_VERSION)\n OSバージョン: \(UIDevice.current.systemVersion)\n デバイス: \(YMTGetDeviceName.share.getDeviceName())\n ID: \(Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.USER_ID)!)\n ------------------------------------",
                            isHTML: false)
                        
                    default:
                        break
                    }
                    
                    view?.presentVC(nextVC: mailVC, completion: nil)
                    
                } else {
                    
                    let alertVC = OriginalAlertViewController(
                        descriptionText: "メールアプリを起動できませんでした。\n専用アプリをインストールしていないか、メール送信用のアカウントが設定されていない可能性があります。",
                        isCloseBackgroundTouch: false)
                    
                    view?.presentVC(nextVC: alertVC) {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            
                            alertVC.dismiss(animated: true)
                        }
                    }
                }
                
            case Constants.TO_REVIEW:
                
                guard NetworkUtil.isOnline() else {
                    
                    view?.showNetworkAlert()
                    
                    return
                }
                
                Constants.USER_DEFAULTS_STANDARD.set(false, forKey: Constants.IS_NEED_REQUEST_REVIEW)
                
                if let url = URL(string: "https://itunes.apple.com/us/app/itunes-u/id1493982688?action=write-review") {
                    
                    UIApplication.shared.open(url)
                }
                
                model.logAnalytics(logName: "SetVC_Review")
                
            case Constants.TO_APP_SHARE:
                
                guard NetworkUtil.isOnline() else {
                    
                    view?.showNetworkAlert()
                    
                    return
                }
                
                let activityVC = UIActivityViewController(
                    activityItems: [Constants.APP_STORE_URL, UIImage(named: "appIconImage")!],
                    applicationActivities: nil)
                
                view?.presentVC(nextVC: activityVC, completion: nil)
                
                model.logAnalytics(logName: "SetVC_Share")
                
            default :
                break
            }
        }
    }
}

// MARK: - SettingModelProtocol
extension SettingViewPresenter: SettingModelProtocol {
}
