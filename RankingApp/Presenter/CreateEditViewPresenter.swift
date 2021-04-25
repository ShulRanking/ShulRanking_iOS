//
//  CreateEditViewPresenter.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/10.
//

import GradientCircularProgress
import Photos
import PhotosUI
import CropViewController

class CreateEditViewPresenter: CreateEditViewPresenterProtocol {
    
    private weak var view: CreateEditViewProtocol?
    private let model: CreateEditModel
    
    private var rankingViewModel: RankingViewModel
    /// tableViewに設定するためのリスト(50位までのデータが空の順位も含むリスト)
    private var tableViewDisplayList: [RankingCellViewModel] = []
    /// 編集フラグ(falseなら新規作成)
    private var isEdit: Bool
    
    /// 画像検索type
    private enum SearchImageType {
        
        case google
        case premium
    }
    
    init(view: CreateEditViewProtocol, rankingViewModel: RankingViewModel, isEdit: Bool) {
        
        self.view = view
        self.rankingViewModel = rankingViewModel
        self.isEdit = isEdit
        
        model = CreateEditModel()
        model.delegate = self
        
        model.logAnalytics(logName: "NotVC")
    }
    
    func viewDidLoad() {
        // tableView用のListを設定
        setTableViewDisplayList()
    }
    
    func viewWillAppear() {
        
        // 編集時
        if isEdit {
            
            view?.setEdit()
        }
        // 新規作成時
        else {
            
            view?.setCreate()
            
            // rankingModeは前回の選択値で初期表示
            rankingViewModel.rankingMode = RankingMode.getEnumBy(rawValue: Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.RANKING_MODE)!)
        }
        
        switch rankingViewModel.rankingMode {
        case .normal:
            view?.setSortButtonHidden(isHidden: true)
            
        case .star:
            view?.setSortButtonHidden(isHidden: false)
        }
        
        view?.reloadTableView()
    }
    
    func viewDidAppear() {
        
        if Constants.isFirstEdit && Constants.USER_DEFAULTS_STANDARD.bool(forKey: Constants.DISPLAY_DIALOG) {
            
            Constants.isFirstEdit = false
            
            let alertVC = OriginalAlertViewController(
                descriptionText: "編集中に画面を離れる場合は、\n一度保存することをおすすめします。\n(このメッセージは設定で非表示にできます)",
                isCloseBackgroundTouch: true)
            
            view?.presentVC(nextVC: alertVC) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
                    alertVC.dismiss(animated: true)
                }
            }
        }
    }
    
    func getRankingViewModel() -> RankingViewModel {
        rankingViewModel
    }
    
    func getTableViewDisplayList() -> [RankingCellViewModel] {
        tableViewDisplayList
    }
    
    func textFieldDidEndEditing(index: Int?, value: String) {
        
        if let index = index {
            
            tableViewDisplayList[index].rankTitle = value
            
        } else {
            
            rankingViewModel.mainTitle = value
        }
    }
    
    func descriptionTextViewDidEndEditing(index: Int, value: String) {
        
        tableViewDisplayList[index].rankDescription = value
    }
    
    func imageDidEndEditing(index: Int?, image: UIImage, cropRect: CGRect?) {
        
        if let index = index {
            
            tableViewDisplayList[index].image = image
            
            if let cropRect = cropRect {
                
                tableViewDisplayList[index].imageRectX = Float(cropRect.minX)
                tableViewDisplayList[index].imageRectY = Float(cropRect.minY)
                tableViewDisplayList[index].imageRectWidth = Float(cropRect.width)
                tableViewDisplayList[index].imageRectHeight = Float(cropRect.height)
                
            } else {
                
                tableViewDisplayList[index].clearImageRect()
            }
            
            view?.reloadRow(index: index)
            
        } else {
            
            rankingViewModel.mainImage = image
            
            if let cropRect = cropRect {
                
                rankingViewModel.mainImageRectX = Float(cropRect.minX)
                rankingViewModel.mainImageRectY = Float(cropRect.minY)
                rankingViewModel.mainImageRectWidth = Float(cropRect.width)
                rankingViewModel.mainImageRectHeight = Float(cropRect.height)
                
            } else {
                
                rankingViewModel.clearImageRect()
            }
            
            view?.reloadTableView()
        }
    }
    
    func starEditing(index: Int, starNumArray: [Int]) {
        
        tableViewDisplayList[index].starNum1 = starNumArray[0]
        tableViewDisplayList[index].starNum2 = starNumArray[1]
        tableViewDisplayList[index].starNum3 = starNumArray[2]
        tableViewDisplayList[index].starNum4 = starNumArray[3]
        tableViewDisplayList[index].starNum5 = starNumArray[4]
    }
    
    func starTextFieldDidEndEditing(text: String, titleIndex: Int) {
        
        switch titleIndex {
        case 0:
            rankingViewModel.starTitle1 = text
            
        case 1:
            rankingViewModel.starTitle2 = text
            
        case 2:
            rankingViewModel.starTitle3 = text
            
        case 3:
            rankingViewModel.starTitle4 = text
            
        case 4:
            rankingViewModel.starTitle5 = text
            
        default:
            break
        }
        
        // CreateEditStarHeaderTableViewCell以外のcellを更新
        view?.reloadRowsExceptStarHeader()
    }
    
    func deleteTapped(index: Int) {
        
        let alertVC = OriginalAlertViewController(
            titleText: "削除確認",
            descriptionText: "\(String(index + 1))位を削除します。\nよろしいですか?",
            negativeButtonText: "キャンセル",
            positiveButtonText: "削除",
            isCloseBackgroundTouch: true) { [weak self] alertButtonType in
            
            guard let self = self else { return }
            
            switch alertButtonType {
            case .negative:
                break
                
            case .positive:
                
                self.tableViewDisplayList.remove(at: index)
                
                for (index, rankingCellViewModel) in self.tableViewDisplayList.enumerated() {
                    
                    rankingCellViewModel.num = index + 1
                }
                
                self.view?.deleteRow(index: index)
                self.view?.reloadTableView()
                
                // 上記のUI関連処理を行うため、10m秒待った後にメインスレッドで実行
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    
                    let rankingCellViewModel = RankingCellViewModel()
                    rankingCellViewModel.num = Constants.RANKING_SUM
                    
                    self.tableViewDisplayList.append(rankingCellViewModel)
                    // セルを削除した分、末尾に空のセルを追加
                    self.view?.insertRow(index: Constants.RANKING_SUM - 1)
                }
                
            case .neutral:
                break
            }
        }
        
        view?.presentVC(nextVC: alertVC, completion: nil)
    }
    
    func dragSorted(sourceIndex: Int, destinationIndex: Int) {
        
        // 選択したセルのランキングが下がる場合
        if destinationIndex > sourceIndex {
            
            for rankingCellViewModel in tableViewDisplayList {
                
                if sourceIndex + 1 < rankingCellViewModel.num && rankingCellViewModel.num <= destinationIndex + 1 {
                    // ランキングを上げる
                    rankingCellViewModel.num = rankingCellViewModel.num - 1
                }
                // 選択したセル
                else if rankingCellViewModel.num == sourceIndex + 1 {
                    // ランキングを下げる
                    rankingCellViewModel.num = destinationIndex + 1
                }
            }
        }
        // 選択したセルのランキングが上がる場合
        else {
            
            for rankingCellViewModel in tableViewDisplayList {
                
                if destinationIndex + 1 <= rankingCellViewModel.num && rankingCellViewModel.num < sourceIndex + 1 {
                    // ランキングを下げる
                    rankingCellViewModel.num = rankingCellViewModel.num + 1
                }
                // 選択したセル
                else if rankingCellViewModel.num == sourceIndex + 1 {
                    // ランキングを上げる
                    rankingCellViewModel.num = destinationIndex + 1
                }
            }
        }
        
        // rankingViewModelListをnumで昇順にソートする
        tableViewDisplayList = tableViewDisplayList.sorted() { a, b -> Bool in
            
            a.num < b.num
        }
        
        view?.reloadTableView()
    }
    
    /// スクロールが最下部にある場合ボタンを非表示にする
    func scrollViewDidScroll(scrollBottom: Bool) {
        
        if scrollBottom {
            
            if !isEdit {
                
                view?.setRankingModeButton(isHidden: true)
            }
            
            if rankingViewModel.rankingMode == .star {
                
                view?.setSortButtonHidden(isHidden: true)
            }
            
        } else {
            
            if !isEdit {
                
                view?.setRankingModeButton(isHidden: false)
            }
            
            if rankingViewModel.rankingMode == .star {
                
                view?.setSortButtonHidden(isHidden: false)
            }
        }
    }
    
    func imageTapped(albumCropDelegate: Any, titleText: String, index: Int?, imageViewSize: CGSize) {
        
        // アルバム(Photo liblary)の閲覧権限の確認
        checkPermission(albumCropDelegate: albumCropDelegate, titleText: titleText, index: index, imageViewSize: imageViewSize)
    }
    
    func leftBarTapped() {
        
        var alertTitle: String
        var alertDescription: String
        var alertPositiveButtonText: String
        
        if isEdit {
            
            alertTitle = "確認"
            alertDescription = "編集中の内容を保存せずに移動します。\nよろしいですか?"
            alertPositiveButtonText = "保存せずに移動"
            
        } else {
            
            alertTitle = "クリア確認"
            alertDescription = "入力されている内容を全てクリアします。\nよろしいですか?"
            alertPositiveButtonText = "全てクリア"
        }
        
        let alertVC = OriginalAlertViewController(
            titleText: alertTitle,
            descriptionText: alertDescription,
            negativeButtonText: "キャンセル",
            positiveButtonText: alertPositiveButtonText,
            isCloseBackgroundTouch: true) { [weak self] alertButtonType in
            
            guard let self = self else { return }
            
            switch alertButtonType {
            case .negative:
                break
                
            case .positive:
                
                if self.isEdit {
                    
                    // ランキングデータを編集前のデータに戻す
                    self.rankingViewModel.overwrite(
                        rankingViewModel: DataBaseManager.shared.getRankingViewModel(
                            idDate: self.rankingViewModel.idDate
                        )
                    )
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        self.view?.backVC()
                    }
                    
                } else {
                    
                    // 各データを空にする
                    let prevRankingMode = self.rankingViewModel.rankingMode
                    self.rankingViewModel = RankingViewModel()
                    self.rankingViewModel.rankingMode = prevRankingMode
                    self.setTableViewDisplayList()
                    
                    self.view?.reloadTableView()
                }
                
            case .neutral:
                break
            }
        }
        
        view?.presentVC(nextVC: alertVC, completion: nil)
    }
    
    func settingBarTapped() {
        
        let createEditSettingVC = CreateEditSettingViewController(
            imageRatioType: rankingViewModel.imageRatioType) { imageRatioType in
                
            self.rankingViewModel.imageRatioType = imageRatioType
            
            self.view?.reloadTableView()
        }
        
        // 編集設定画面へ
        self.view?.presentVC(nextVC: createEditSettingVC, completion: nil)
    }
    
    func saveTapped() {
        
        saveRankingDataInDB()
    }
    
    func rankingModeTapped() {
        
        switch rankingViewModel.rankingMode {
        
        case .normal:
            Constants.USER_DEFAULTS_STANDARD.set(RankingMode.star.rawValue, forKey: Constants.RANKING_MODE)
            rankingViewModel.rankingMode = .star
            
            view?.setSortButtonHidden(isHidden: false)
            
        case .star:
            // 項目に入力されている場合
            if RankingUtil.checkStarTitleExist(rankingViewModel: self.rankingViewModel) {
                
                let alertVC = OriginalAlertViewController(
                    titleText: "クリア確認",
                    descriptionText: "項目と☆評価部分がクリアされます。\nよろしいですか?",
                    negativeButtonText: "キャンセル",
                    positiveButtonText: "クリア",
                    isCloseBackgroundTouch: true) { [weak self] alertButtonType in
                    
                    guard let self = self else { return }
                    
                    switch alertButtonType {
                    case .negative:
                        break
                        
                    case .positive:
                        // 項目と☆評価部分をクリア
                        RankingUtil.deleteStarData(
                            rankingViewModel: self.rankingViewModel,
                            rankingCellViewModelList: self.tableViewDisplayList)
                        
                        Constants.USER_DEFAULTS_STANDARD.set(RankingMode.normal.rawValue, forKey: Constants.RANKING_MODE)
                        self.rankingViewModel.rankingMode = .normal
                        self.view?.setSortButtonHidden(isHidden: true)
                        self.view?.reloadTableView()
                        
                    case .neutral:
                        break
                    }
                }
                
                view?.presentVC(nextVC: alertVC, completion: nil)
                
            } else {
                
                Constants.USER_DEFAULTS_STANDARD.set(RankingMode.normal.rawValue, forKey: Constants.RANKING_MODE)
                self.rankingViewModel.rankingMode = .normal
                view?.setSortButtonHidden(isHidden: true)
            }
        }
        
        view?.reloadTableView()
    }
    
    func sortTapped() {
        
        // rankingViewModelListをstarSumで降順にソートする
        tableViewDisplayList = tableViewDisplayList.sorted { a, b -> Bool in
            
            a.starSum > b.starSum
        }
        
        // starSumの順にnumを振る
        var index = 1
        for rankingCellViewModel in tableViewDisplayList {
            
            rankingCellViewModel.num = index
            index += 1
        }
        
        view?.reloadTableView()
    }
    
    /// アルバム(Photo liblary)の閲覧権限の確認
    private func checkPermission(albumCropDelegate: Any, titleText: String, index: Int?, imageViewSize: CGSize) {
        
        var pHAuthorizationStatus: PHAuthorizationStatus
        
        if #available(iOS 14, *) {
            
            pHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
        } else {
            
            pHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        }
        
        switch pHAuthorizationStatus {
        
        case .authorized, .limited:
            displayImageMenu(albumCropDelegate: albumCropDelegate, titleText: titleText, index: index, imageViewSize: imageViewSize)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                
                if newStatus == PHAuthorizationStatus.authorized {
                    
                    DispatchQueue.main.async {
                        
                        self.displayImageMenu(albumCropDelegate: albumCropDelegate, titleText: titleText, index: index, imageViewSize: imageViewSize)
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
                isCloseBackgroundTouch: true) { [weak self] alertButtonType in
                
                guard let self = self else { return }
                
                switch alertButtonType {
                case .negative:
                    break
                    
                case .neutral:
                    break
                    
                case .positive:
                    
                    // 一旦DBに保存(アクセス設定が変更されるとアプリが再起動されるため)
                    self.saveRankingDataInDB()
                    
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    UIApplication.shared.open(settingsURL)
                }
            }
            
            view?.presentVC(nextVC: alertVC, completion: nil)
            
        @unknown default:
            break
        }
    }
    
    /// Photo Libraryを表示
    private func displayAlbum(albumDelegate: Any) {
        
        if #available(iOS 14, *) {
            
            var configuration = PHPickerConfiguration()
            // 静止画(Live含)を選択
            configuration.filter = .images
            // 選択可能な枚数を設定
            configuration.selectionLimit = 1
            
            let imagePickerVC = PHPickerViewController(configuration: configuration)
            imagePickerVC.delegate = albumDelegate as? PHPickerViewControllerDelegate
            
            // Photo Libraryを表示
            view?.presentVC(nextVC: imagePickerVC, completion: nil)
            
        } else {
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePickerVC = UIImagePickerController()
                imagePickerVC.delegate = albumDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePickerVC.sourceType = .photoLibrary
                imagePickerVC.allowsEditing = true
                
                // Photo Libraryを表示
                view?.presentVC(nextVC: imagePickerVC, completion: nil)
            }
        }
    }
    
    private func displayImageMenu(albumCropDelegate: Any, titleText: String, index: Int?, imageViewSize: CGSize) {
        
        var buttonNameArray: [String] {
            
            CreateEditMenuButtonType.allCases.compactMap { createEditMenuButtonType -> String? in
                
                if createEditMenuButtonType == .searchGoogle ||
                    createEditMenuButtonType == .searchPremium {
                    
                    #if DEBUG || RELEASE
                    return nil
                    #endif
                }
                
                return createEditMenuButtonType.rawValue
            }
        }
        
        let menuVC = MenuDialogViewController(dataArray: buttonNameArray) { [weak self] itemName in
            
            guard let self = self else { return }
            
            let createEditMenuButtonType = CreateEditMenuButtonType.getEnumBy(rawValue: itemName)
            
            switch createEditMenuButtonType {
            case .searchGoogle:
                
                // 検索ワードはセルタイトルからとる
                self.displaySearchImageVC(searchWord: titleText, index: index, searchImageType: .google)
                
            case .searchPremium:
                
                // 検索利用可能かチェック
                guard self.checkSearchable() else {
                    
                    // 利用不可能アラート
                    let alertVC = OriginalAlertViewController(
                        descriptionText: "検索利用可能回数を超えています",
                        isCloseBackgroundTouch: true)
                    
                    DispatchQueue.main.async {
                        
                        // 利用不可能アラート表示
                        self.view?.presentVC(nextVC: alertVC) {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                
                                // 利用不可能アラート閉じる
                                alertVC.dismiss(animated: true)
                            }
                        }
                    }
                    
                    return
                }
                
                // 検索ワードはセルタイトルからとる
                self.displaySearchImageVC(searchWord: titleText, index: index, searchImageType: .premium)
                
            case .selectAlbum:
                
                self.displayAlbum(albumDelegate: albumCropDelegate)
                
                self.model.logAnalytics(logName: "CEVC_Image_Album")
                
            case .searchWebView:
                
                guard NetworkUtil.isOnline() else {
                    
                    self.view?.showNetworkAlert()
                    
                    return
                }
                
                self.model.logAnalytics(logName: "CEVC_Image_Web")
                
                let searchImageWebVC = SearchImageWebViewController(searchWord: titleText)
                self.view?.presentVC(nextVC: searchImageWebVC, completion: nil)
                
            case .edit:
                
                var imageOrNil: UIImage? {
                    
                    if let index = index {
                        
                        return self.tableViewDisplayList[safe: index]?.image
                        
                    } else {
                        
                        return self.rankingViewModel.mainImage
                    }
                }
                
                guard let image = imageOrNil else { return }
                
                let cropVC = CropViewController(image: image)
                // cropBoxのサイズを固定
                cropVC.cropView.cropBoxResizeEnabled = false
                // AspectRatioのサイズをimageViewのサイズに合わせる
                cropVC.customAspectRatio = imageViewSize
                
                cropVC.resetAspectRatioEnabled = false
                // 使用しない機能は非表示
                cropVC.aspectRatioPickerButtonHidden = true
                cropVC.rotateButtonsHidden = true
                
                cropVC.doneButtonTitle = "完了"
                cropVC.cancelButtonTitle = "キャンセル"
                cropVC.cancelButtonColor = ConstantsColor.OFFICIAL_ORANGE_100
                cropVC.doneButtonColor = ConstantsColor.OFFICIAL_ORANGE_100
                
                cropVC.delegate = albumCropDelegate as? CropViewControllerDelegate
                
                self.view?.presentVC(nextVC: cropVC, completion: nil)
                
                self.model.logAnalytics(logName: "CEVC_Image_Edit")
                
            case .delete:
                
                if let index = index {
                    
                    self.tableViewDisplayList[safe: index]?.image = nil
                    self.tableViewDisplayList[safe: index]?.clearImageRect()
                    
                    self.view?.reloadRow(index: index)
                    
                } else {
                    
                    self.rankingViewModel.mainImage = nil
                    self.rankingViewModel.clearImageRect()
                    
                    self.view?.reloadTableView()
                }
                
                self.model.logAnalytics(logName: "CEVC_Image_Delete")
                
            case .cancel:
                break
            }
        }
        
        view?.presentVC(nextVC: menuVC, completion: nil)
        
        model.logAnalytics(logName: "CEVC_Image")
    }
    
    /// tableViewに設定するためのリストを作成
    private func setTableViewDisplayList() {
        
        var resultList = [RankingCellViewModel]()
        
        // サイズがRANKING_SUMのListを作成する
        for i in 1...Constants.RANKING_SUM {
            
            var rankingCellViewModel: RankingCellViewModel
            
            // 既に順位にデータが入っている場合
            if i <= rankingViewModel.rankingCellViewModelList.count {
                
                rankingCellViewModel = rankingViewModel.rankingCellViewModelList[i - 1]
                
            } else {
                
                rankingCellViewModel = RankingCellViewModel()
                rankingCellViewModel.num = i
            }
            
            resultList.append(rankingCellViewModel)
        }
        
        tableViewDisplayList = resultList
    }
    
    /// DBへ登録
    private func saveRankingDataInDB() {
        
        // プログレスビュー表示開始
        let gcp = GradientCircularProgress()
        view?.showProgress(gcp: gcp)
        
        // 編集中のテキストを完了させる
        view?.endEditing()
        
        // 10m秒待った後にバックグラウンドで実行
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.01) {
            
            self.rankingViewModel.rankingCellViewModelList = RankingUtil.getExistDataList(rankingCellViewModelList: self.tableViewDisplayList)
            
            self.model.saveRankingViewModelToDB(
                rankingViewModel: self.rankingViewModel,
                isEdit: self.isEdit,
                gcp: gcp) { resultRankingViewModel in
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else { return }
                    
                    self.isEdit = false
                    // 各データを空にする
                    self.rankingViewModel = RankingViewModel()
                    self.setTableViewDisplayList()
                    
                    self.view?.reloadTableView()
                    
                    let rankingMainVC = RankingMainViewController(rankingViewModel: resultRankingViewModel, fromCreateEdit: true)
                    self.view?.pushVC(nextVC: rankingMainVC)
                }
            }
        }
        
        model.logAnalytics(logName: "CEVC_save_isEdit_\(isEdit)")
    }
    
    private func displaySearchImageVC(searchWord: String, index: Int?, searchImageType: SearchImageType) {
        
        guard NetworkUtil.isOnline() else {
            
            view?.showNetworkAlert()
            
            return
        }
        
        let completion: (UIImage) -> Void = { [weak self] selectedImage in
            
            guard let self = self else { return }
            
            if let index = index {
                
                self.tableViewDisplayList[index].image = selectedImage
                self.tableViewDisplayList[index].clearImageRect()
                
                self.view?.reloadRow(index: index)
                
            } else {
                
                self.rankingViewModel.mainImage = selectedImage
                self.rankingViewModel.clearImageRect()
                
                self.view?.reloadTableView()
            }
        }
        
        var nextVC: UIViewController
        
        switch searchImageType {
        case .google:
            // 遷移先のインスタンスをsegueから取り出す
            nextVC = GoogleSearchImageAPIViewController(
                searchText: searchWord,
                imageRatioType: rankingViewModel.imageRatioType,
                isCloseBackgroundTouch: true,
                completion: completion)
            
        case .premium:
            // 遷移先のインスタンスをsegueから取り出す
            nextVC = PremiumSearchImageAPIViewController(
                searchText: searchWord,
                imageRatioType: rankingViewModel.imageRatioType,
                isCloseBackgroundTouch: true,
                completion: completion)
        }
        
        view?.presentVC(nextVC: nextVC, completion: nil)
    }
    
    /// 検索利用可能かチェック(検索利用可能回数に達していないか)
    private func checkSearchable() -> Bool {
        
        #if ORIGINAL
        return true
        #endif
        
        // 検索利用回数を取得
        let imageSearchCount = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.IMAGE_SEARCH_REMAINING_NUM)
        
        // 検索利用可能回数に達していればfalseを返す
        return 0 < imageSearchCount
    }
}

extension CreateEditViewPresenter: CreateEditModelProtocol {
}
