//
//  RankingItemViewPresenter.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/19.
//

import GradientCircularProgress

class RankingItemViewPresenter: RankingItemViewPresenterProtocol {
    
    private weak var view: RankingItemViewProtocol?
    private let model: RankingItemModel

    private let rankingViewModel: RankingViewModel
    private let rankingDisplayStyle: RankingDisplayStyle
    
    private var isNeedReloadTableView: Bool = false
    
    init(view: RankingItemViewProtocol, rankingViewModel: RankingViewModel, rankingDisplayStyle: RankingDisplayStyle) {

        self.rankingViewModel = rankingViewModel
        self.rankingDisplayStyle = rankingDisplayStyle

        self.view = view

        model = RankingItemModel()
        model.delegate = self
    }
    
    func viewDidLoad() {
        
        view?.setTitleName(title: rankingViewModel.mainTitle)
    }
    
    func viewWillAppear() {

        // pageが切り替わって表示された際、tableViewの更新が必要な場合
        if isNeedReloadTableView {
            
            // tableView更新
            view?.reloadTableView()
            
            isNeedReloadTableView = false
        }
        
        // ランキング表示スタイルの選択値を保存
        model.saveRankingDisplayStyle(rankingDisplayStyle: rankingDisplayStyle)
    }
    
    func setIsNeedReloadTableView(isNeed: Bool) {
        isNeedReloadTableView = isNeed
    }
    
    func getRankingViewModel() -> RankingViewModel {
        rankingViewModel
    }
    
    func getRankingDisplayStyle() -> RankingDisplayStyle {
        rankingDisplayStyle
    }
    
    /// ランキングモード切り替え
    /// - Parameters:
    ///   - rankingViewModel: 切り替えるランキング
    ///   - callback: 切り替え後に行う処理
    func toggleMode(rankingViewModel: RankingViewModel,
                    callback: @escaping (RankingViewModel) -> Void) {
        
        switch rankingViewModel.rankingMode {
        case .normal:
            
            // プログレスビュー表示開始
            let gcp = GradientCircularProgress()
            gcp.showAtRatio(display: true, style: OfficialStyle())
            
            // ☆評価モードに変更
            rankingViewModel.rankingMode = .star
            let tableViewCellHeight = rankingDisplayStyle.getCellHeight(mode: rankingViewModel.rankingMode)
            view?.setTableViewCellHeight(height: tableViewCellHeight)
            
            // DB保存
            model.saveDBModeChange(gcp: gcp,
                             rankingViewModel: rankingViewModel,
                             callback: callback)
            
        case .star:
            // 項目に入力されている場合
            if RankingUtil.checkStarTitleExist(rankingViewModel: rankingViewModel) {
                
                // 項目と☆評価部分のデータのクリア確認アラート作成
                let alertVC = OriginalAlertViewController(
                    titleText: "クリア確認",
                    descriptionText: "項目と☆評価部分がクリアされます。\nよろしいですか?",
                    negativeButtonText: "キャンセル",
                    positiveButtonText: "クリア",
                    isCloseBackgroundTouch: false) { [weak self] alertButtonType in
                    
                    guard let self = self else { return }
                    
                    switch alertButtonType {
                    case .negative:
                        break
                        
                    case .positive:
                        // プログレスビュー表示開始
                        let gcp = GradientCircularProgress()
                        gcp.showAtRatio(display: true, style: OfficialStyle())
                        
                        // 項目と☆評価部分をクリア
                        RankingUtil.deleteStarData(rankingViewModel: rankingViewModel,
                                                   rankingCellViewModelList: rankingViewModel.rankingCellViewModelList)
                        
                        // ノーマルモードに変更
                        rankingViewModel.rankingMode = .normal
                        let tableViewCellHeight = self.rankingDisplayStyle.getCellHeight(mode: rankingViewModel.rankingMode)
                        self.view?.setTableViewCellHeight(height: tableViewCellHeight)
                        
                        // DB保存
                        self.model.saveDBModeChange(gcp: gcp,
                                              rankingViewModel: rankingViewModel,
                                              callback: callback)
                        
                    case .neutral:
                        break
                    }
                }
                
                // クリア確認アラート表示
                view?.presentVC(nextVC: alertVC, completion: nil)
                
            } else {
                
                // ノーマルモードに変更
                rankingViewModel.rankingMode = .normal
                let tableViewCellHeight = rankingDisplayStyle.getCellHeight(mode: rankingViewModel.rankingMode)
                view?.setTableViewCellHeight(height: tableViewCellHeight)
                
                // プログレスビュー表示開始
                let gcp = GradientCircularProgress()
                gcp.showAtRatio(display: true, style: OfficialStyle())
                
                // DB保存
                model.saveDBModeChange(gcp: gcp,
                                 rankingViewModel: rankingViewModel,
                                 callback: callback)
            }
        }
    }
    
    func cellTapped(index: Int) {
        
        let nextVc = RankingDetailsViewController(rankingViewModel: rankingViewModel,
                                                  rankingCellViewModel: rankingViewModel.rankingCellViewModelList[index],
                                                  rankingDisplayStyle: rankingDisplayStyle)
        
        view?.presentVC(nextVC: nextVc, completion: nil)
    }
    
    func searchTapped() {
        
        let searchRankVC = SearchRankViewController(
            rankingCellViewModelList: rankingViewModel.rankingCellViewModelList) { [weak self] index in
            
            guard let self = self else { return }
            
            // 選択したセルまでスクロール
            self.view?.scrollTableView(index: index, animated: false)
            
            // 選択したセルを点滅
            self.view?.flashCell(index: index)
        }
        
        // 検索画面へ
        view?.presentVC(nextVC: searchRankVC, completion: nil)
    }
}

extension RankingItemViewPresenter: RankingItemModelProtocol {
    
    func saveDBModeChangeCompleted(rankingViewModel: RankingViewModel) {
        
        DispatchQueue.main.async {
            
            self.view?.reloadTableView()
        }
    }
}
