//
//  RankingMainViewPresenter.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/10.
//

import Foundation
import Photos
import GradientCircularProgress

class RankingMainViewPresenter: RankingMainViewPresenterProtocol {
    
    private weak var view: RankingMainViewProtocol?
    private let model: RankingMainModel
    
    private var rankingViewModel: RankingViewModel = RankingViewModel()
    private var fromCreateEdit: Bool = false
    private var toEditFlg: Bool = false
    
    private let rankingItemPageVC: RankingItemPageViewController
    
    private var cancelIdShare: Bool = false
    
    init(view: RankingMainViewProtocol, rankingViewModel: RankingViewModel, fromCreateEdit: Bool, rankingItemPageVC: RankingItemPageViewController) {
        
        self.rankingViewModel = rankingViewModel
        self.fromCreateEdit = fromCreateEdit
        self.rankingItemPageVC = rankingItemPageVC
        
        self.view = view
        
        model = RankingMainModel()
        model.delegate = self
    }
    
    func viewDidLoad() {
        
        // 新規作成編集画面からの遷移の場合
        if fromCreateEdit {
            
            fromCreateEdit = false
            
            view?.hidesBackButton()
            view?.setUpLeftBarButtonItem()
            
            // レビューをリクエスト
            requestStoreReview()
        }
    }
    
    func customBackTapped() {
        
        // 1番後ろの画面に戻る
        view?.popToRootVC()
    }
    
    func createTapped() {
        
        toEditFlg = false
        
        // 1番後ろの画面に戻る
        view?.popToRootVC()
    }
    
    func screenShotTapped() {
        
        // アルバム(Photo liblary)の閲覧権限の確認
        checkPermission()
    }
    
    func editTapped() {
        
        toEditFlg = true
        
        let nextVC = CreateEditViewController(rankingViewModel: rankingViewModel, isEdit: toEditFlg)
        
        view?.pushVC(nextVC: nextVC)
    }
    
    func itemsTapped() {
        
        // ロックボタン文言
        var lockButtonName: String {
            
            if rankingViewModel.isDisplay {
                
                return "ロック"
                
            } else {
                
                return "ロック解除"
            }
        }
        
        // モード切替ボタン文言
        var modeButtonName: String {
            
            if rankingViewModel.rankingMode == .normal {
                
                return "☆評価モードへ変更"
                
            } else {
                
                return "ノーマルモードへ変更"
            }
        }
        
        // ボタン名の配列を作成
        let buttonNameArray = RankingMainMenuButtonType.allCases.map { menuButtonType -> String in
            
            if menuButtonType == .lock {
                
                return lockButtonName
                
            } else if menuButtonType == .changeMode {
                
                return modeButtonName
            }
            
            return menuButtonType.rawValue
        }
        
        let menuVC = MenuDialogViewController(dataArray: buttonNameArray) { [weak self] buttonName in
            
            guard let self = self else { return }
            
            // ボタン名をenumに変換
            let menuButtonType = RankingMainMenuButtonType.getEnumBy(rawValue: buttonName)
            
            switch menuButtonType {
            // 画像でシェア
            case .shareByImage:
                // アルバム(Photo liblary)の閲覧権限の確認
                self.checkPermissionForShare()
                
                self.model.logAnalytics(logName: "RanIVC_Items_Share_Image")
                
            // IDでシェア
            case .shareById:
                
                guard NetworkUtil.isOnline() else {
                    
                    self.view?.showNetworkAlert()
                    
                    return
                }
                
                // 広告付きプログレスビュー
                let gcpVC = GCProgressViewController(message: "アップロード中", isDisplayAd: true) {
                    
                    self.cancelIdShare = true
                }
                
                // 広告付きプログレスビュー表示
                self.view?.presentVC(nextVC: gcpVC, completion: nil)
                
                FirebaseStorageUtil.shared.sentRankingForShare(rankingViewModel: self.rankingViewModel) { id in
                    
                    DispatchQueue.main.async {
                        
                        // 広告付きプログレスビュー表示終了
                        self.view?.dismissVC(targetVC: gcpVC, completion: nil)
                    }
                    
                    if self.cancelIdShare {
                        
                        self.cancelIdShare = false
                        
                        return
                    }
                    
                    let alertVC = OriginalAlertViewController(
                        titleText: "\"\(id)\"",
                        descriptionText: "上記のIDが発行されました。\n有効期限: 72時間以内",
                        neutralButtonText: "紹介文をコピー",
                        positiveButtonText: "IDをコピー",
                        isCloseBackgroundTouch: true) { alertButtonType in
                        
                        switch alertButtonType {
                        case .negative:
                            break
                            
                        case .neutral:
                            // ペーストボートにシェア文言設定
                            UIPasteboard.general.string = "\"\(self.rankingViewModel.mainTitle)\"を作成しました。\n\nShul Rankingアプリのホーム画面左下のボタンから、下記のIDを入力して取得可能です。\n\nID→ \(id)\n\nインストールをされていない場合、下記URLから取得可能です(iOSのみ)。\n\(Constants.APP_STORE_URL)"
                            
                        case .positive:
                            // ペーストボートにid設定
                            UIPasteboard.general.string = id
                        }
                        
                        self.model.logAnalytics(logName: "RanIVC_Items_Share_ID_\(alertButtonType.rawValue)")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        self.view?.presentVC(nextVC: alertVC, completion: nil)
                    }
                }
                
                self.model.logAnalytics(logName: "RanIVC_Items_Share_ID")
                
            // ロックボタン
            case .lock:
                
                // 表示フラグを更新
                DataBaseManager.shared.updateIsDisplay(idDate: self.rankingViewModel.idDate)
                self.rankingViewModel.isDisplay = !self.rankingViewModel.isDisplay
                
                self.model.logAnalytics(logName: "RanIVC_Items_Lock")
                
            // 複製
            case .copy:
                
                // プログレスビュー
                let gcp = GradientCircularProgress()
                // プログレスビュー表示開始
                self.view?.showProgressView(gcp: gcp, isAtRatio: true, message: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    DataBaseManager.shared.saveRankingViewModelToDB(
                        rankingViewModel: self.rankingViewModel,
                        isEdit: false,
                        gcp: gcp) { rankingViewModel in
                        
                        DispatchQueue.main.sync {
                            
                            // プログレスビュー非表示
                            self.view?.dismissProgressView(gcp: gcp)
                        }
                        
                        // 複製完了メッセージ
                        var alertVC: OriginalAlertViewController!
                        
                        DispatchQueue.main.sync {
                            
                            alertVC = OriginalAlertViewController(
                                descriptionText: "\"\(rankingViewModel.mainTitle)\"を複製しました。",
                                isCloseBackgroundTouch: false)
                            
                            self.view?.presentVC(nextVC: alertVC, completion: nil)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.view?.dismissVC(targetVC: alertVC) {
                                
                                self.view?.popToRootVCIfCreate()
                            }
                        }
                    }
                }
                
                self.model.logAnalytics(logName: "RanIVC_Items_Copy")
                
            // モード切替
            case .changeMode:
                
                self.rankingItemPageVC.nowRankingVc.toggleMode(
                    rankingViewModel: self.rankingViewModel) { rankingViewModel -> Void in
                    
                    self.rankingViewModel = rankingViewModel
                }
                
                for rankingItemVC in self.rankingItemPageVC.rankingItemViewControllers {
                    
                    rankingItemVC.setIsNeedReloadTableView(isNeed: true)
                }
                
                self.model.logAnalytics(logName: "RanIVC_Items_Mode")
                
            // 削除
            case .delete:
                
                // 削除確認アラート
                let alertVC = OriginalAlertViewController(
                    titleText: "削除確認",
                    descriptionText: "このランキングを削除します。\nよろしいですか?",
                    negativeButtonText: "キャンセル",
                    positiveButtonText: "削除",
                    isCloseBackgroundTouch: true) { [weak self] buttonName in
                    
                    guard let self = self else { return }
                    
                    switch buttonName {
                    case .negative:
                        break
                        
                    case .positive:
                        
                        // データ削除
                        FirebaseStorageUtil.shared.deleteData(rankingViewModel: self.rankingViewModel)
                        DataBaseManager.shared.delete(idDate: self.rankingViewModel.idDate)
                        
                        // 1番後ろの画面に戻る
                        self.view?.popToRootVC()
                        
                        self.model.logAnalytics(logName: "RanIVC_Items_Delete")
                        
                    case .neutral:
                        break
                    }
                }
                
                DispatchQueue.main.async {
                    // 削除確認アラート表示
                    self.view?.presentVC(nextVC: alertVC, completion: nil)
                }
                
            // キャンセル
            case .cancel:
                break
            }
        }
        
        view?.presentVC(nextVC: menuVC, completion: nil)
        
        model.logAnalytics(logName: "RanIVC_Items")
    }
    
    func screenShotDecisionTapped(topIndex: Int, bottomIndex: Int) {
        
        guard let image = getContentImageForScreenShot(isShare: false, topIndex: topIndex, bottomIndex: bottomIndex) else { return }
        
        view?.writeToSavedPhotosAlbum(image: image)
    }
    
    /// アルバム(Photo liblary)の閲覧権限の確認
    private func checkPermission() {
        
        var pHAuthorizationStatus: PHAuthorizationStatus
        
        if #available(iOS 14, *) {
            
            pHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: PHAccessLevel.readWrite)
            
        } else {
            
            pHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        }
        
        let captureCompletion = screenShotDecisionTapped
        
        switch pHAuthorizationStatus {
        
        case .authorized, .limited:
            // キャプチャ範囲設定画面
            let captureSettingRangeVC = CaptureSettingRangeViewController(
                rankingViewModel: rankingViewModel,
                rankingDisplayStyle: rankingItemPageVC.nowRankingVc.rankingDisplayStyle,
                completion: captureCompletion)
            
            view?.presentVC(nextVC: captureSettingRangeVC, completion: nil)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                
                guard let self = self else { return }
                
                if newStatus == PHAuthorizationStatus.authorized {
                    
                    DispatchQueue.main.async {
                        
                        let captureSettingRangeVC = CaptureSettingRangeViewController(
                            rankingViewModel: self.rankingViewModel,
                            rankingDisplayStyle: self.rankingItemPageVC.nowRankingVc.rankingDisplayStyle,
                            completion: captureCompletion)
                        self.view?.presentVC(nextVC: captureSettingRangeVC, completion: nil)
                    }
                }
            }
            
        case .restricted:
            break
            
        case .denied:
            // フォトライブラリへのアクセスが許可されていないためアラートを作成
            let alertVC = OriginalAlertViewController(
                descriptionText: "写真へのアクセスを許可してください",
                negativeButtonText: "キャンセル",
                positiveButtonText: "設定",
                isCloseBackgroundTouch: true) { alertButtonType in
                
                switch alertButtonType {
                case .negative:
                    break
                    
                case .neutral:
                    break
                    
                case .positive:
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    UIApplication.shared.open(settingsURL)
                }
            }
            
            self.view?.presentVC(nextVC: alertVC, completion: nil)
            
        @unknown default:
            break
        }
    }
    
    /// アルバム(Photo liblary)の閲覧権限の確認(シェア用)
    private func checkPermissionForShare() {
        
        var pHAuthorizationStatus: PHAuthorizationStatus
        
        if #available(iOS 14, *) {
            
            pHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: PHAccessLevel.readWrite)
            
        } else {
            
            pHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        }
        
        switch pHAuthorizationStatus {
        
        case .authorized, .limited:
            // キャプチャ画像を取得し、シェアメニューを表示
            let image = getContentImageForScreenShot(isShare: true)
            let nextVC = UIActivityViewController(activityItems: [rankingViewModel.mainTitle + "\n\n" + "#ShulRanking", image!], applicationActivities: nil)
            view?.presentVC(nextVC: nextVC, completion: nil)
            
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                
                guard let self = self else { return }
                
                if newStatus == PHAuthorizationStatus.authorized {
                    
                    DispatchQueue.main.async {
                        
                        // キャプチャ画像を取得し、シェアメニューを表示
                        guard let image = self.getContentImageForScreenShot(isShare: true) else { return }
                        let nextVC = UIActivityViewController(activityItems: [self.rankingViewModel.mainTitle + "\n\n" + "#ShulRanking", image], applicationActivities: nil)
                        
                        self.view?.presentVC(nextVC: nextVC, completion: nil)
                    }
                }
            }
            
        case .restricted:
            break
            
        case .denied:
            // フォトライブラリへのアクセスが許可されていないためアラートを作成
            let alertVC = OriginalAlertViewController(
                descriptionText: "写真へのアクセスを許可してください",
                negativeButtonText: "キャンセル",
                positiveButtonText: "設定",
                isCloseBackgroundTouch: true) { alertButtonType in
                
                switch alertButtonType {
                case .negative:
                    break
                    
                case .neutral:
                    break
                    
                case .positive:
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    UIApplication.shared.open(settingsURL)
                }
            }
            
            self.view?.presentVC(nextVC: alertVC, completion: nil)
            
        @unknown default:
            break
        }
    }
    
    private func getContentImageForScreenShot(isShare: Bool, topIndex: Int? = nil, bottomIndex: Int? = nil) -> UIImage? {
        
        rankingItemPageVC.nowRankingVc.getContentImageForScreenShot(
            isShare: isShare,
            rankingCellViewModelList: rankingViewModel.rankingCellViewModelList,
            topIndex: topIndex,
            bottomIndex: bottomIndex)
    }
    
    // レビューをリクエスト
    private func requestStoreReview() {
        
        // ストアレビューをリクエストする必要があるか(アプリ起動回数に応じて設定)
        let isNeedRequestReview = Constants.USER_DEFAULTS_STANDARD.bool(forKey: Constants.IS_NEED_REQUEST_REVIEW)
        
        // ストアレビューをリクエストする必要がある場合
        if isNeedRequestReview {
            
            // ストアレビューをリクエスト
            view?.requestStoreReview()
            
            // レビューリクエスト済みに登録
            Constants.USER_DEFAULTS_STANDARD.set(false, forKey: Constants.IS_NEED_REQUEST_REVIEW)
            
            model.logAnalytics(logName: "RanIVC_Review")
        }
    }
}

// MARK: - RankingMainModelProtocol
extension RankingMainViewPresenter: RankingMainModelProtocol {
    
}
