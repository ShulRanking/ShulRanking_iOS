//
//  HomeViewPresenter.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/11/21.
//

import Foundation

class HomeViewPresenter: HomeViewPresenterProtocol {
    
    private weak var view: HomeViewProtocol?
    private let model: HomeModel
    
    private var rankingViewModelList: [RankingViewModel]!
    private var idMissCount = 0
    
    private let idMissMessageArray: [String] = [
        "IDが間違っているか、有効期限が切れているなどの原因が考えられます。\nまたシェアする方もシェアされる方もアプリの最新のバージョンをご利用ください。",
        "えっと、IDをお間違いか有効期限が切れているようです。\nまたシェアする方もシェアされる方もアプリの最新のバージョンをご利用ください。",
        "だから有効期限切れか間違えてるっていってるじゃないですか...",
        "おい4回目やぞ。サーバーに負荷かかるから無駄なことすんじゃねぇ",
        "きいとんか?ごらぁぁぁああああ",
        "どうしたものか",
        "○▼※△☆▲※◎★●・▲☆＝￥！＞♂×＆◎♯￡!?",
        "これでもだめか",
        "なるほどね",
        "いいこと思いついた",
        "おら、もっかいやってみ？"]
    
    init(view: HomeViewProtocol) {
        
        self.view = view
        
        model = HomeModel()
        model.delegate = self
        
        // DBから全ランキングデータを取り出し
        fetchDataList()
    }
    
    func viewWillAppear() {
        
        // DBから全ランキングデータを取り出し
        fetchDataList()
    }
    
    /// 全ランキングデータを取得
    func getRankingViewModelList() -> [RankingViewModel] {
        rankingViewModelList
    }
    
    func idTapped() {
        
        guard NetworkUtil.isOnline() else {
            
            view?.showNetworkAlert()
            
            return
        }
        
        let shareIdVC = ShareIdViewController { [weak self] isSuccess in
            
            guard let self = self else { return }
            
            if isSuccess {
                
                self.idMissCount = 0
                
                // DBから全ランキングデータを取り出し
                self.fetchDataList()
                
                self.view?.reloadCollectionView()
                
                // rankingViewModelListの先頭に、IDで取得したランキングが追加されている
                let newRankingViewModel = self.rankingViewModelList.first { $0.displayOrder == 0 }
                
                guard let rankingViewModel = newRankingViewModel else { return }
                
                let alertVC = OriginalAlertViewController(
                    titleText: "",
                    descriptionText: "\"\(rankingViewModel.mainTitle)\"が追加されました",
                    isCloseBackgroundTouch: false)
                
                self.view?.presentVC(nextVC: alertVC) {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        
                        alertVC.dismiss(animated: true)
                        
                        self.view?.scrollTop()
                    }
                }
                
                self.model.logAnalytics(logName: "HorVC_ID_Success")
                
            } else {
                
                if self.idMissCount == self.idMissMessageArray.count {
                    
                    let alertExitVC = OriginalAlertViewController(
                        titleText: "異常発生",
                        descriptionText: "アプリケーションに異常はありませんが、ユーザーに異常を発見しました。\nアプリケーションを終了します。\nよろしいですか？",
                        negativeButtonText: "終了する",
                        positiveButtonText: "もうしない",
                        isCloseBackgroundTouch: false) { [weak self] buttonType in
                        
                        guard let self = self else { return }
                        
                        self.model.logAnalytics(logName: "HorVC_exitVC")
                        
                        switch buttonType {
                        case .negative:
                            // アプリ終了
                            self.view?.finishApp()
                            
                        case .positive:
                            self.idMissCount = 0
                            
                        default:
                            break
                        }
                        
                        self.model.logAnalytics(logName: "HorVC_exitVC_\(buttonType.rawValue)")
                    }
                    
                    self.view?.presentVC(nextVC: alertExitVC, completion: nil)
                    
                } else {
                    
                    let alertVC = OriginalAlertViewController(
                        titleText: "取得失敗",
                        descriptionText: self.idMissMessageArray[self.idMissCount],
                        isCloseBackgroundTouch: false)
                    
                    self.idMissCount += 1
                    
                    self.view?.presentVC(nextVC: alertVC) {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                            
                            alertVC.dismiss(animated: true)
                        }
                    }
                }
            }
        }
        
        view?.presentVC(nextVC: shareIdVC, completion: nil)
    }
    
    func itemSelected(index: Int) {
        
        // RankingMainViewControllerへ
        let rankingMainVC = RankingMainViewController(rankingViewModel: rankingViewModelList[index], fromCreateEdit: false)
        view?.pushVC(nextVC: rankingMainVC)
        
        model.logAnalytics(logName: "RanIVC_HorVC_HCVC")
    }
    
    func cellLongTapped(index: Int) {
        
        // HomeDetailsViewControllerへ
        let homeDetailsVC = HomeDetailsViewController(rankingViewModel: rankingViewModelList![index])
        view?.presentVC(nextVC: homeDetailsVC, completion: nil)
    }
    
    func headerImageTapped(idDate: String?) {
        
        if let idDate = idDate {
            
            // idDateが一致するrankingViewModelを検索
            let resultRankingViewModel = rankingViewModelList.first { idDate == $0.idDate }
            
            if let resultRankingViewModel = resultRankingViewModel {
                
                // RankingMainViewControllerへ
                let rankingMainVc = RankingMainViewController(rankingViewModel: resultRankingViewModel, fromCreateEdit: false)
                view?.pushVC(nextVC: rankingMainVc)
                
                model.logAnalytics(logName: "RanIVC_HorVC_HHCVC")
            }
            
        }
        // ランキングIDが入っていない場合
        else {
            
            // お知らせとみなす
            // NotificationViewControllerへ
            let notificationVc = NotificationViewController()
            view?.pushVC(nextVC: notificationVc)
            
            model.logAnalytics(logName: "NotVC_HorVC")
        }
    }
    
    /// DBから全ランキングデータを取り出し
    private func fetchDataList() {
        
        model.fetchDataList()
    }
}

// MARK: - HomeModelProtocol
extension HomeViewPresenter: HomeModelProtocol {
    
    func sentRankingViewModelList(rankingViewModelList: [RankingViewModel]) {
        
        self.rankingViewModelList = rankingViewModelList
    }
}
