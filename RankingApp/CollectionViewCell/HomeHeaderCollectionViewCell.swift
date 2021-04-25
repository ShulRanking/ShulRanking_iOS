//
//  HomeHeaderCollectionViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/09/08.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

/// ホーム画面上部の横スクロール部分全体のセル
class HomeHeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: HomeHeaderCollectionViewCellDelegate?
    
    private var rankingViewModelList: [RankingViewModel] = []
    private var displayRankingViewModelList: [RankingViewModel] = []
    
    private var imageWidth: CGFloat = 0
    private var imageHeight: CGFloat = 0
    private var cardViews: [UIView] = []
    private var offsetX: CGFloat = 0
    private var timer: Timer?
    /// タップ開始時のスクロール位置格納用
    private var startPoint: CGPoint?
    
    private let maxPageCount: Int = 5
    
    private let notificationImageArray: [[String : String]] = [
        [Constants.URL_D: Constants.notificationTitleIconDictionalyArray[0][Constants.URL_D]!,
         Constants.URL_L: Constants.notificationTitleIconDictionalyArray[0][Constants.URL_L]!],
        
        [Constants.URL_D: Constants.notificationTitleIconDictionalyArray[1][Constants.URL_D]!,
         Constants.URL_L: Constants.notificationTitleIconDictionalyArray[1][Constants.URL_L]!],
        
        [Constants.URL_D: Constants.notificationTitleIconDictionalyArray[2][Constants.URL_D]!,
         Constants.URL_L: Constants.notificationTitleIconDictionalyArray[2][Constants.URL_L]!],
        
        [Constants.URL_D: Constants.notificationTitleIconDictionalyArray[3][Constants.URL_D]!,
         Constants.URL_L: Constants.notificationTitleIconDictionalyArray[3][Constants.URL_L]!]
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(cellTypes: [HomeHeaderHorizonalNormalCollectionViewCell.self,
                                            HomeHeaderHorizonalItemsCollectionViewICell.self])
        
        // タイマーを作成
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollPage), userInfo: nil, repeats: true)
    }
    
    func setData(rankingViewModelList: [RankingViewModel]) {
        
        self.rankingViewModelList = rankingViewModelList
        self.rankingViewModelList.shuffle()
        
        // 表示するListを作成
        displayRankingViewModelList.removeAll()
        for index in 0 ..< 4 {
            
            if index < self.rankingViewModelList.count {
                
                displayRankingViewModelList.append(self.rankingViewModelList[index])
                
            } else {
                
                break
            }
        }
        
        collectionView.reloadData()
    }
    
    /// offsetXの値を更新するとページを移動
    @objc func scrollPage() {
        
        // 画面の幅分offsetXを移動
        offsetX += collectionView.frame.width
        
        if offsetX < collectionView.frame.width * CGFloat(maxPageCount) {
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                
                guard let self = self else { return }
                
                let pageCount = Int(self.offsetX / self.collectionView.frame.width)
                self.collectionView.scrollToItem(at: [0, pageCount], at: .centeredHorizontally, animated: true)
            }
            
        }
        // maxPageCountページ目まで移動した場合
        else {
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                
                guard let self = self else { return }
                
                // 1ページ目まで戻る
                self.collectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: false)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeHeaderCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        maxPageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // お知らせ
        if 0 == indexPath.row || displayRankingViewModelList.count <= indexPath.row - 1 {
            
            let cell = collectionView.dequeueReusableCell(with: HomeHeaderHorizonalNormalCollectionViewCell.self, for: indexPath)
            
            cell.setNotificationCell(imageUrl: notificationImageArray[Int.random(in: notificationImageArray.indices)])
            
            return cell
            
        } else if 4 == indexPath.row {
            
            let cell = collectionView.dequeueReusableCell(with: HomeHeaderHorizonalItemsCollectionViewICell.self, for: indexPath)
            
            cell.setData(rankingViewModel: displayRankingViewModelList[indexPath.row - 1])
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(with: HomeHeaderHorizonalNormalCollectionViewCell.self, for: indexPath)
            
            cell.setRankingCell(rankingViewModel: displayRankingViewModelList[indexPath.row - 1])
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeHeaderCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // お知らせ
        if indexPath.row == 0 || displayRankingViewModelList[safe: indexPath.row - 1] == nil {
            
            delegate?.headerImageTapped(idDate: nil)
            
        } else {
            // 現在表示されているランキングのidDateを渡す
            delegate?.headerImageTapped(idDate: displayRankingViewModelList[indexPath.row - 1].idDate)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeHeaderCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension HomeHeaderCollectionViewCell: UIScrollViewDelegate {
    
    /// スクロール中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // pageControllの値を変更
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        // (ユーザーによって)左にスクロールされた場合
        if offsetX > scrollView.contentOffset.x {
            // タイマーを無効化
            timer?.invalidate()
            // タイマーを作成
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollPage), userInfo: nil, repeats: true)
        }
        
        // 1ページ目開いていて、まぁまぁ右に引っ張った場合
        if scrollView.contentOffset.x < -scrollView.frame.width * 0.15 {
            
            UIView.animate(withDuration: 0.3) {
                // maxPageCountページ目を表示
                self.offsetX = scrollView.frame.width * CGFloat((self.maxPageCount - 1))
                self.collectionView.scrollToItem(at: [0, (self.maxPageCount - 1)], at: .centeredHorizontally, animated: false)
            }
        }
        //        // maxPageCount目で左に引っ張った場合
        //        else if scrollView.frame.size.width * CGFloat(maxPageCount) < scrollView.contentOffset.x {
        //
        //            // 1ページ目を表示
        //            self.collectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: false)
        //
        //        }
        else {
            // offsetXの値を更新
            offsetX = scrollView.contentOffset.x
        }
    }
    
    /// ドラッグ開始時のスクロール位置記憶
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        startPoint = scrollView.contentOffset
    }
}
