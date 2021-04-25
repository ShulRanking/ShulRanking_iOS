//
//  SecondViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/08.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var idButton: UIButton!
    
    private var presenter: HomeViewPresenterProtocol!
    
    private var rankingViewModelList:[RankingViewModel] {
        presenter.getRankingViewModelList()
    }
    /// セルの数(ダミー含む)
    private var cellAmount: Int = 0
    /// HomeHeaderCollectionViewCellとHomeCollectionViewLabelCellの合計
    private let headerAndLabel: Int = 2
    
    init() {
        super.init(nibName: "HomeViewController", bundle: nil)
        
        presenter = HomeViewPresenter(view: self)
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCollectionView.register(cellTypes: [HomeHeaderCollectionViewCell.self,
                                                HomeCollectionViewLabelCell.self,
                                                HomeCollectionViewCell.self,
                                                DummyCollectionViewCell.self,
                                                HomeFooterCollectionViewCell.self])
        
        setUpNavigationItem()
        
        setUpItemButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.viewWillAppear()
        
        tabBarController?.tabBar.isHidden = false
        
        homeCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        homeCollectionView.flashScrollIndicators()
    }
    
    private func setUpNavigationItem() {
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.tintColor = ConstantsColor.DARK_GRAY_CUSTOM_100
        titleImageView.image = UIImage(named: "logoSideForNavi")
        navigationItem.titleView = titleImageView
        
        // 両端に置くダミーのBarButtonItemを4つ作成(ロゴの画像サイズを他の画面と合わせるため)
        var dummyBarButtonItemList = [UIBarButtonItem]()
        for _ in 0 ..< 4 {
            // 適当な画像設定
            let dummyBarButtonItem = UIBarButtonItem(image: UIImage(named: "clear"), style: .plain, target: nil, action: nil)
            // クリアな色設定
            dummyBarButtonItem.tintColor = .clear
            
            dummyBarButtonItemList.append(dummyBarButtonItem)
        }
        
        // ナビゲーションバーの両端に4つボタン付与
        navigationItem.setLeftBarButtonItems([dummyBarButtonItemList[0], dummyBarButtonItemList[1]], animated: false)
        navigationItem.setRightBarButtonItems([dummyBarButtonItemList[2], dummyBarButtonItemList[3]], animated: false)
    }
    
    private func setUpItemButton() {
        
        // 動的につけないと影がつかない
        idButton.layer.cornerRadius = idButton.bounds.width / 2
        // 影の設定
        // 影の方向(width=右方向、height=下方向、CGSize.zero=方向指定なし)
        idButton.layer.shadowOffset = CGSize(width: 0.75, height: 1.0)
        // 影の色
        idButton.layer.shadowColor = ConstantsColor.REVERSE_SYSTEM_BACKGROUND_100.cgColor
        // 影の濃さ
        idButton.layer.shadowOpacity = 0.2
        // 影をぼかし
        idButton.layer.shadowRadius = 3
    }
    
    @IBAction func idTapped(_ sender: UIButton) {
        
        presenter.idTapped()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // HomeHeaderCollectionViewCellとHomeCollectionViewLabelCellとHomeFooterCollectionViewCellの合計値
        let headerAndLabelAndFooter = 3
        
        cellAmount = rankingViewModelList.count + headerAndLabelAndFooter
        
        // ランキングの数が3で割り切れない場合はダミーのセルを加えて調整
        if rankingViewModelList.count % 3 == 1 {
            
            cellAmount += 2
            
        } else if rankingViewModelList.count % 3 == 2 {
            
            cellAmount += 1
        }
        
        return cellAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            
            let cell = collectionView.dequeueReusableCell(with: HomeHeaderCollectionViewCell.self, for: indexPath)
            
            cell.setData(rankingViewModelList: rankingViewModelList)
            cell.delegate = self
            
            return cell
            
        case 1:
            
            let cell = collectionView.dequeueReusableCell(with: HomeCollectionViewLabelCell.self, for: indexPath)
            
            return cell
            
        case 1 ..< rankingViewModelList.count + headerAndLabel:
            
            let cell = collectionView.dequeueReusableCell(with: HomeCollectionViewCell.self, for: indexPath)
            
            cell.setData(rankingViewModel: rankingViewModelList[indexPath.item - headerAndLabel])
            cell.delegate = self
            
            return cell
            
        case cellAmount - 1:
            // フッターセル
            let cell = collectionView.dequeueReusableCell(with: HomeFooterCollectionViewCell.self, for: indexPath)
            
            return cell
            
        default:
            // ダミーのセル
            let cell = collectionView.dequeueReusableCell(with: DummyCollectionViewCell.self, for: indexPath)
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // (正方形のセルの)ランキングの場合
        if 1 < indexPath.item && indexPath.item < rankingViewModelList.count + headerAndLabel {
            
            presenter.itemSelected(index: indexPath.item - headerAndLabel)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize
        
        switch indexPath.item {
        case 0:
            
            let cellWidth: CGFloat = view.bounds.width
            let pageControlSpace: CGFloat = 19
            cellSize = CGSize(width: cellWidth, height: cellWidth / 4 * 3 + pageControlSpace)
            
        case 1:
            
            let cellWidth: CGFloat = view.bounds.width
            let heightSpace: CGFloat = 20
            cellSize = CGSize(width: cellWidth, height: heightSpace)
            
        case 1 ..< rankingViewModelList.count + headerAndLabel:
            
            let horizontalSpace: CGFloat = 1
            let cellWidth: CGFloat = view.bounds.width / 3 - horizontalSpace
            let cellTitleTextViewSpace: CGFloat = 1.5
            cellSize = CGSize(width: cellWidth, height: cellWidth + cellTitleTextViewSpace)
            
        case cellAmount - 1:
            
            cellSize = CGSize(width: view.bounds.width, height: view.bounds.width / 4 - 2)
            
        default:
            
            // ダミーのセル
            let horizontalSpace: CGFloat = 1
            let cellWidth = view.bounds.width / 3 - horizontalSpace
            let cellTitleTextViewSpace: CGFloat = 1.5
            cellSize = CGSize(width: cellWidth, height: cellWidth + cellTitleTextViewSpace)
        }
        
        return cellSize
    }
}

// MARK: - HomeHeaderCollectionViewCellDelegate
extension HomeViewController: HomeHeaderCollectionViewCellDelegate {
    
    /// HomeHeaderCollectionViewCellの画像がタップされた場合
    func headerImageTapped(idDate: String?) {
        
        presenter.headerImageTapped(idDate: idDate)
    }
}

// MARK: - HomeCollectionViewCellDelegate
extension HomeViewController: HomeCollectionViewCellDelegate {
    
    /// cellが長押しされた場合
    func homeCollectionViewCellLongTapped(cell: HomeCollectionViewCell) {
        
        guard let path = homeCollectionView.indexPath(for: cell) else { return }
        
        presenter.cellLongTapped(index: path.row - headerAndLabel)
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    
    func showNetworkAlert() {
        // ネットワーク未接続アラート表示
        AlertUtil.showNetworkAlert(vc: self)
    }
    
    func reloadCollectionView() {
        // homeCollectionView更新
        homeCollectionView.reloadData()
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
    
    func scrollTop() {
        // homeCollectionViewスクロール最上部へ
        homeCollectionView.scrollToItem(at: [0, 0], at: .top, animated: true)
    }
    
    func finishApp() {
        // アプリ終了
        exit(1)
    }
}
