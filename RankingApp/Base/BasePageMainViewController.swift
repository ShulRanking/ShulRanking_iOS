//
//  BasePageMainViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/08/11.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

/// ページングを管理するVCのbase
class BasePageMainViewController: UIViewController {
    
    @IBOutlet weak var pageViewControllerSpaceView: UIView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var selectBarView: UIView!
    
    /// 選択バーの幅(制約)
    @IBOutlet weak var selectBarViewWidth: NSLayoutConstraint!
    
    private let pageVC: BaseTabPageViewController
    private let titleArray: [String]
    
    private var selectedIndex: Int
    
    private var pageTabItemsWidth: CGFloat = 0.0
    private var cellWidth: CGFloat = 0.0
    
    private var selectingBarWidth: CGFloat {
        cellWidth - 20
    }
    
    private var noSelectingBarWidth: CGFloat {
        cellWidth + 20
    }
    
    /// 無限スクロール実現のため、itemsCollectionViewに表示したい要素数の何倍用意するか
    let dummyElementDouble = 5
    
    init(pageVc: BaseTabPageViewController, titleArray: [String], selectedIndex: Int) {
        
        self.pageVC = pageVc
        self.titleArray = titleArray
        self.selectedIndex = selectedIndex + titleArray.count
        
        super.init(nibName: "BasePageMainViewController", bundle: nil)
        
        pageVc.pageDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewController(vc: pageVC, container: pageViewControllerSpaceView)
        
        setCellWidth()
        
        itemsCollectionView.register(cellType: PageCollectionViewCell.self)
        
        navigationController?.navigationBar.barTintColor = itemsCollectionView.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ナビゲーションバーの下部ボーダーを消す
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // ここでスクロールさせないとスクロールできない(これ以前は、collecitionViewがまだ完成してないため)
        itemsCollectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        
        // ユーザーにスクロールする様子を見せたくないため、ごまかすためにanimation
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseIn]) { [weak self] in
            
            self?.itemsCollectionView.alpha = 1.0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.shadowImage = nil
    }
    
    private func setCellWidth() {
        
        let minimumCellWidth: CGFloat = 95.0
        
        if minimumCellWidth <= itemsCollectionView.frame.width / CGFloat(titleArray.count) {
            
            cellWidth = itemsCollectionView.frame.width / CGFloat(titleArray.count)
            
        } else {
            
            cellWidth = minimumCellWidth
        }
        
        selectBarViewWidth.constant = selectingBarWidth
    }
    
    /// ページvcの選択VCを変更
    private func changePageVc(indexPath: IndexPath) {
        
        // itemsCollectionViewの要素数に対してpageViewControllerで表示するvcの要素は3分の1しかないため、調整
        var indexForPageVc = indexPath.item
        while titleArray.count <= indexForPageVc {
            
            indexForPageVc -= titleArray.count
        }
        
        // 左のページを開く場合
        if indexPath.item < selectedIndex {
            
            pageVC.setViewControllers([pageVC.pageViewControllers[indexForPageVc]], direction: .reverse, animated: true)
        }
        // 右のページを開く場合
        else if selectedIndex < indexPath.item {
            
            pageVC.setViewControllers([pageVC.pageViewControllers[indexForPageVc]], direction: .forward, animated: true)
        }
        
        selectedIndex = indexPath.item
    }
}

// MARK: - UICollectionViewDataSource
extension BasePageMainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 無限スクロール実現のため、表示したい要素数の3倍を返す
        titleArray.count * dummyElementDouble
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = itemsCollectionView.dequeueReusableCell(with: PageCollectionViewCell.self, for: indexPath)
        
        // itemsCollectionViewの要素数に対して表示するリストの要素は3分の1しかないため、調整
        var index = indexPath.item
        while titleArray.count <= index {
            
            index -= titleArray.count
        }
        
        cell.setData(pageTitle: titleArray[index])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BasePageMainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        itemsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // ページVCの選択を変更
        changePageVc(indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BasePageMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: cellWidth,
               height: itemsCollectionView.frame.height)
    }
}

// MARK: - PageViewControllerDelegate
extension BasePageMainViewController: PageViewControllerDelegate {
    
    func pageChanged(isAfter: Bool) {
        
        let addIndex = isAfter ? 1 : -1
        
        selectedIndex += addIndex
        
        if selectedIndex < 0 {
            
            selectedIndex = titleArray.count * dummyElementDouble - 1
            
        } else if titleArray.count * dummyElementDouble <= selectedIndex {
            
            selectedIndex = 0
        }

        itemsCollectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension BasePageMainViewController: UIScrollViewDelegate {
    
    /// タップしスクロール開始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        // 選択バーの幅を広げる
        selectBarViewWidth.constant = noSelectingBarWidth
        UIView.animate(withDuration: 0.35) { [weak self] in
            
            self?.view.layoutIfNeeded()
        }
    }
    
    /// タップ終了時
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // スクロールが終了している場合
        if !decelerate {
            
            fitSelectBarAndCell(scrollView)
        }
    }

    /// スクロール中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentSize.width == 0 {
            
            return
        }

        if pageTabItemsWidth == 0.0 {
            // 表示したい要素群のwidthを計算
            pageTabItemsWidth = floor(scrollView.contentSize.width / CGFloat(dummyElementDouble))
        }

        // 無限スクロール実現のため、スクロールした位置がしきい値を超えたら中央に戻す
        // (参考)https://techblog.zozo.com/entry/tab_page_viewcontroller
        if scrollView.contentOffset.x <= cellWidth {

            selectedIndex += titleArray.count
            scrollView.contentOffset.x = pageTabItemsWidth + cellWidth

        } else if pageTabItemsWidth * 2.0 - cellWidth <= scrollView.contentOffset.x {

            selectedIndex -= titleArray.count
            scrollView.contentOffset.x = pageTabItemsWidth - cellWidth
        }
    }

    /// 慣性によるスクロール停止時(完全停止)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        fitSelectBarAndCell(scrollView)
    }
    
    /// 選択バーとタブが合うように調整
    private func fitSelectBarAndCell(_ scrollView: UIScrollView) {
        
        var cellCount: Int = 0
        // 各セルの中央位置とスクロール量からどのセルを選択するか計算
        while cellWidth * CGFloat(cellCount + 1) - cellWidth / 2 <= itemsCollectionView.contentOffset.x + itemsCollectionView.frame.width / 2 + cellWidth / 2 {
            
            cellCount += 1
        }

        itemsCollectionView.scrollToItem(at: IndexPath(item: cellCount - 1, section: 0),
                                         at: .centeredHorizontally,
                                         animated: true)

        // ページvcの選択を変更
        changePageVc(indexPath: [0, cellCount - 1])

        // 選択バーの幅を元に戻す
        selectBarViewWidth.constant = selectingBarWidth
        UIView.animate(withDuration: 0.35) { [weak self] in
            
            self?.view.layoutIfNeeded()
        }
    }
}
