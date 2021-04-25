//
//  RankingMainViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/10/15.
//

import UIKit
import Photos
import GradientCircularProgress
import StoreKit

class RankingMainViewController: BasePageMainViewController {
    
    private var screenShotBarButtonItem: UIBarButtonItem!
    
    private var presenter: RankingMainViewPresenterProtocol!
    
    init(rankingViewModel: RankingViewModel, fromCreateEdit: Bool) {
        
        let titleArray = RankingDisplayStyle.allCases.map { $0.rawValue }
        
        let rankingItemPageVC = RankingItemPageViewController(
            rankingViewModel: rankingViewModel,
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        // ランキング表示スタイルの選択値を取得
        let savedRankingDisplayStyle = RankingDisplayStyle.getEnumBy(rawValue: Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.RANKING_ITEM_STYLE))
        
        super.init(pageVc: rankingItemPageVC,
                   titleArray: titleArray,
                   selectedIndex: savedRankingDisplayStyle.getIndex())
        
        presenter = RankingMainViewPresenter(view: self, rankingViewModel: rankingViewModel, fromCreateEdit: fromCreateEdit, rankingItemPageVC: rankingItemPageVC)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.tintColor = ConstantsColor.DARK_GRAY_CUSTOM_100
        titleImageView.image = UIImage(named: "logoSideForNavi")
        navigationItem.titleView = titleImageView
        
        // スクリーンショットボタン作成
        screenShotBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "screenShot"),
            style: .plain,
            target: self,
            action: #selector(screenShotTapped))
        screenShotBarButtonItem.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
        
        // LeftBarButtonItemsとBackButtonを共存させる
        navigationItem.leftItemsSupplementBackButton = true
        // ナビゲーションバーの左側にボタン付与
        navigationItem.setLeftBarButtonItems([screenShotBarButtonItem], animated: true)
        
        // 編集ボタン作成
        let editButton = UIBarButtonItem(
            image: UIImage(named: "edit"),
            style: .plain,
            target: self,
            action: #selector(editTapped))
        editButton.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
        
        // メニューボタン作成
        let itemsButton = UIBarButtonItem(
            image: UIImage(named: "moremenu"),
            style: .plain,
            target: self,
            action: #selector(itemsTapped))
        itemsButton.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
        
        // ナビゲーションバーの右側にボタン付与
        navigationItem.setRightBarButtonItems([itemsButton, editButton], animated: true)
        
        presenter.viewDidLoad()
    }
    
    /// 保存を試みた結果を受け取る
    @objc func didFinishSavingImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        let alert = UIAlertController(title: "", message: "カメラロールに保存しました。", preferredStyle: .alert)
        
        present(alert, animated: true) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                // アラートを閉じる
                alert.dismiss(animated: true)
            }
        }
    }
    
    @objc func customBackTapped() {
        presenter.customBackTapped()
    }
    
    @objc func createTapped() {
        presenter.createTapped()
    }
    
    @objc func screenShotTapped() {
        presenter.screenShotTapped()
    }
    
    @objc func editTapped() {
        presenter.editTapped()
    }
    
    @objc func itemsTapped() {
        presenter.itemsTapped()
    }
}

// MARK: - RankingMainViewProtocol
extension RankingMainViewController: RankingMainViewProtocol {
    
    func hidesBackButton() {
        
        navigationItem.hidesBackButton = true
    }
    
    func setUpLeftBarButtonItem() {
        
        // 新規作成タブ以外を選択中の場合
        if tabBarController!.selectedIndex != 2 {
            
            // 戻るボタン作成
            let backButton = UIBarButtonItem(
                image: UIImage(named: "back"),
                style: .plain,
                target: self,
                action: #selector(customBackTapped))
            backButton.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
            // ナビゲーションバーの左側にボタン付与
            navigationItem.setLeftBarButtonItems([backButton, screenShotBarButtonItem], animated: true)
            
        } else {
            
            // 新規作成ボタン作成
            let plusButton = UIBarButtonItem(
                image: UIImage(named: "plus"),
                style: .plain,
                target: self,
                action: #selector(createTapped))
            plusButton.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
            // ナビゲーションバーの左側にボタン付与
            navigationItem.setLeftBarButtonItems([plusButton, screenShotBarButtonItem], animated: true)
        }
    }
    
    func requestStoreReview() {
        // ユーザーにストアのレビューをリクエスト
        SKStoreReviewController.requestReview()
    }
    
    func pushVC(nextVC: UIViewController) {
        
        // 遷移後の戻るボタンの文字を消しておく
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?) {
        
        present(nextVC, animated: true) {
            
            completion?()
        }
    }
    
    func dismissVC(targetVC: UIViewController, completion: (() -> Void)?) {
        
        targetVC.dismiss(animated: true, completion: completion)
    }
    
    func popToRootVC() {
        // 1番後ろの画面に戻る
        navigationController?.popToRootViewController(animated: true)
    }
    
    func popToRootVCIfCreate() {
        
        // 新規作成タブ以外を選択中の場合
        if self.tabBarController!.selectedIndex != 2 {
            // 1番後ろの画面に戻る
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func showProgressView(gcp: GradientCircularProgress, isAtRatio: Bool, message: String?) {
        
        if isAtRatio {
            // プログレスビュー表示開始
            gcp.showAtRatio(display: true, style: OfficialStyle())
            
        } else {
            
            guard let message = message else { return }
            
            // プログレスビュー表示開始
            gcp.show(message: message, style: OfficialStyle())
        }
    }
    
    func dismissProgressView(gcp: GradientCircularProgress) {
        // プログレスビュー表示終了
        gcp.dismiss()
    }
    
    func showNetworkAlert() {
        // ネットワーク未接続アラート表示
        AlertUtil.showNetworkAlert(vc: self)
    }
    
    func writeToSavedPhotosAlbum(image: UIImage) {
        // カメラロールに保存する
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(didFinishSavingImage(_:didFinishSavingWithError:contextInfo:)),
            nil)
    }
}
