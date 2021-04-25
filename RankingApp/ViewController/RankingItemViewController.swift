//
//  RankingItemViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/08/08.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit
import Photos

class RankingItemViewController: UIViewController {
    
    @IBOutlet weak var majorTitleLabel: UILabel!
    @IBOutlet weak var rankingTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var majorTitleLabelParentView: UIView!
    
    private var presenter: RankingItemViewPresenterProtocol!
    
    private var rankingViewModel: RankingViewModel {
        presenter.getRankingViewModel()
    }
    
    var rankingDisplayStyle: RankingDisplayStyle {
        presenter.getRankingDisplayStyle()
    }
    
    private var tableViewCellHeight: CGFloat = 0
    
    init(rankingViewModel: RankingViewModel, rankingDisplayStyle: RankingDisplayStyle) {
        
        super.init(nibName: "RankingItemViewController", bundle: nil)
        
        presenter = RankingItemViewPresenter(view: self, rankingViewModel: rankingViewModel, rankingDisplayStyle: rankingDisplayStyle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        majorTitleLabel.adjustsFontSizeToFitWidth = true
        
        setCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rankingTableView.flashScrollIndicators()
    }
    
    func setIsNeedReloadTableView(isNeed: Bool) {
        
        presenter.setIsNeedReloadTableView(isNeed: isNeed)
    }
    
    /// ランキングのスクリーンショットを取得
    /// - Parameters:
    ///   - isShare: シェアボタンからの取得か(任意での順位の範囲指定を行わない)
    ///   - rankingCellViewModelList: 各順位のリストデータ
    /// - Returns: スクリーンショットした画像
    func getContentImageForScreenShot(isShare: Bool,
                                      rankingCellViewModelList: [RankingCellViewModel],
                                      topIndex: Int? = nil,
                                      bottomIndex: Int? = nil) -> UIImage? {
        
        // スクロール量を保存
        let previousPoint = rankingTableView.contentOffset
        // スクショとるのに上の方にスクロールないと1位が切れる
        let indexPath = IndexPath(row: 0, section: 0)
        rankingTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
        // rankingTableViewをスクリーンショットする分だけ1画面に表示(一時的。ユーザーにはみせない)
        rankingTableView.contentSize = CGSize(width: rankingTableView.contentSize.width,
                                              height: tableViewCellHeight * CGFloat(rankingCellViewModelList.count))
        
        let rankinTableViewContentHeight = rankingTableView.contentSize.height
        
        // スクショする対象の順位の合計
        var itemCount: Int {
            
            if isShare {
                
                return rankingCellViewModelList.count
                
            } else {
                
                guard let topIndex = topIndex, let bottomIndex = bottomIndex else { return 0 }
                
                // ユーザーがスクショ範囲指定画面で指定した範囲
                return bottomIndex - topIndex + 1
            }
        }
        
        // ロゴ画像の高さを決める
        let logoImageHeight = 80 < tableViewCellHeight / 2 ? 80 / 2 : tableViewCellHeight / 2
        
        // 最終的なキャプチャサイズを計算
        // 高さ = タイトル部分の高さ + 各順位セルの高さ * 順位の数 + ロゴの高さ
        let captureSize = CGSize(
            width: rankingTableView.frame.size.width,
            height: majorTitleLabel.frame.size.height + tableViewCellHeight * CGFloat(itemCount) + logoImageHeight)
        
        // 元のframe.sizeを保存
        let previousFrame = rankingTableView.layer.frame.size
        
        // 画像を作成していく
        let renderer = UIGraphicsImageRenderer(size: captureSize)
        
        let resultImage = renderer.image { rendererContext in
            // 描画処理
            
            // タイトルLabelを描画
            // searchButtonを非表示
            searchButton.isHidden = true
            let majorTitleLabelImage = majorTitleLabelParentView.convertToUIImage()
            let majorTitleLabelImageRect = CGRect(x: 0,
                                                  y: 0,
                                                  width: captureSize.width,
                                                  height: majorTitleLabelImage.size.height)
            majorTitleLabelImage.draw(in: majorTitleLabelImageRect)
            
            // rankingTableView(各順位)を描画
            // frame.sizeを一時的に変更
            rankingTableView.layer.frame.size = CGSize(width: rankingTableView.contentSize.width,
                                                       height: rankinTableViewContentHeight)
            rankingTableView.reloadData()
            
            // rankingTableViewを指定された順位で切り取り、UIImageとして取得
            let rankingTableViewImage = rankingTableView.clipView(
                rect: CGRect(x: 0,
                             y: CGFloat(topIndex ?? 0) * tableViewCellHeight,
                             width: rankingTableView.frame.width,
                             height: tableViewCellHeight * CGFloat(itemCount)))
            
            let rankingTableViewImageRect = CGRect(x: 0,
                                                   y: majorTitleLabelImageRect.maxY,
                                                   width: captureSize.width,
                                                   height: tableViewCellHeight * CGFloat(itemCount))
            rankingTableViewImage?.draw(in: rankingTableViewImageRect)
            
            // ロゴ画像を作成
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: rankingTableView.contentSize.width, height: logoImageHeight))
            logoImageView.image = UIImage(named: "logoSide")!
            logoImageView.backgroundColor = rankingTableView.backgroundColor
            logoImageView.contentMode = .scaleAspectFit
            
            // ロゴ画像を描画
            let logoImageViewImage = logoImageView.convertToUIImage()
            let logoImageViewImageRect = CGRect(x: 0,
                                                y: rankingTableViewImageRect.maxY,
                                                width: captureSize.width,
                                                height: logoImageViewImage.size.height)
            logoImageViewImage.draw(in: logoImageViewImageRect)
        }
        
        // rankingTableViewの表示を元に戻す
        rankingTableView.layer.frame.size = previousFrame
        rankingTableView.contentOffset = previousPoint
        
        // searchButtonを再表示
        searchButton.isHidden = false
        
        return resultImage
    }
    
    /// ランキングモード変更
    /// - Parameters:
    ///   - rankingViewModel: モード変更するランキング
    ///   - callback: 切り替え後に行う処理
    func toggleMode(rankingViewModel: RankingViewModel,
                    callback: @escaping (RankingViewModel) -> Void) {
        
        presenter.toggleMode(rankingViewModel: rankingViewModel, callback: callback)
    }
    
    private func setCell() {
        
        switch rankingDisplayStyle {
        
        case .title:
            
            rankingTableView.register(cellTypes: [RankingItemTitleTableViewCell.self, RankingItemStarTitleTableViewCell.self])
            
        case .text:
            
            rankingTableView.register(cellTypes: [RankingItemTextTableViewCell.self, RankingItemStarTextTableViewCell.self])
            
        case .imageMain:
            
            rankingTableView.register(cellTypes: [RankingItemImageMainTableViewCell.self, RankingItemStarImageMainTableViewCell.self])
            
        case .standard:
            
            rankingTableView.register(cellTypes: [RankingItemStandardTableViewCell.self, RankingItemStarStandardTableViewCell.self])
            
        case .image11:
            
            rankingTableView.register(cellTypes: [RankingItemImage11TableViewCell.self, RankingItemStarImage11TableViewCell.self])
            
        case .nankaKakkoii:
            
            rankingTableView.register(cellTypes: [RankingItemNankaKakkoiiTableViewCell.self, RankingItemStarNankaKakkoiiTableViewCell.self])
            
            if #available(iOS 13.0, *) {
                
                view.backgroundColor = .systemBackground
                rankingTableView.backgroundColor = .systemBackground
                majorTitleLabelParentView.backgroundColor = .systemBackground
                
            } else {
                
                view.backgroundColor = .white
                rankingTableView.backgroundColor = .white
                majorTitleLabelParentView.backgroundColor = .white
            }
        }
        
        tableViewCellHeight = CGFloat(rankingDisplayStyle.getCellHeight(mode: rankingViewModel.rankingMode))
        
        rankingTableView.estimatedRowHeight = tableViewCellHeight
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        
        presenter.searchTapped()
    }
}

// MARK: - UITableViewDataSource
extension RankingItemViewController: UITableViewDataSource {
    
    /// sectionの数を決める
    func numberOfSections(in tableView: UITableView) -> Int {
        rankingViewModel.rankingCellViewModelList.count
    }
    
    /// 1つのsectionの中に入れるcellの数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var resultCell: UITableViewCell
        
        let rankingCellViewModelList = rankingViewModel.rankingCellViewModelList
        
        switch rankingDisplayStyle {
        case .title:
            
            switch rankingViewModel.rankingMode {
            case .normal:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemTitleTableViewCell.self, for: indexPath)
                cell.setData(rankinCellData: rankingCellViewModelList[indexPath.section])
                
                resultCell = cell
                
            case .star:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemStarTitleTableViewCell.self, for: indexPath)
                cell.setData(selectedIndexPath: indexPath.section, rankingViewModelData: rankingViewModel)
                
                resultCell = cell
            }
            
        case .text:
            
            switch rankingViewModel.rankingMode {
            case .normal:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemTextTableViewCell.self, for: indexPath)
                cell.setData(rankinCellData: rankingCellViewModelList[indexPath.section])
                
                resultCell = cell
                
            case .star:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemStarTextTableViewCell.self, for: indexPath)
                cell.setData(selectedIndexPath: indexPath.section, rankingViewModelData: rankingViewModel)
                
                resultCell = cell
            }
            
        case .imageMain:
            
            switch rankingViewModel.rankingMode {
            case .normal:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemImageMainTableViewCell.self, for: indexPath)
                cell.setData(rankinCellData: rankingCellViewModelList[indexPath.section])
                
                resultCell = cell
                
            case .star:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemStarImageMainTableViewCell.self, for: indexPath)
                cell.setData(selectedIndexPath: indexPath.section, rankingViewModelData: rankingViewModel)
                
                resultCell = cell
            }
            
        case .standard:
            
            switch rankingViewModel.rankingMode {
            case .normal:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemStandardTableViewCell.self, for: indexPath)
                cell.setData(rankinCellData: rankingCellViewModelList[indexPath.section])
                
                resultCell = cell
                
            case .star:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemStarStandardTableViewCell.self, for: indexPath)
                cell.setData(selectedIndexPath: indexPath.section, rankingViewModelData: rankingViewModel)
                
                resultCell = cell
            }
            
        case .image11:
            
            switch rankingViewModel.rankingMode {
            case .normal:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemImage11TableViewCell.self, for: indexPath)
                cell.setData(rankinCellData: rankingCellViewModelList[indexPath.section])
                
                resultCell = cell
                
            case .star:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemStarImage11TableViewCell.self, for: indexPath)
                cell.setData(selectedIndexPath: indexPath.section, rankingViewModelData: rankingViewModel)
                
                resultCell = cell
            }
            
        case .nankaKakkoii:
            
            switch rankingViewModel.rankingMode {
            case .normal:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemNankaKakkoiiTableViewCell.self, for: indexPath)
                cell.setData(rankinCellData: rankingCellViewModelList[indexPath.section])
                
                resultCell = cell
                
            case .star:
                
                let cell = tableView.dequeueReusableCell(with: RankingItemStarNankaKakkoiiTableViewCell.self, for: indexPath)
                cell.setData(selectedIndexPath: indexPath.section, rankingViewModelData: rankingViewModel)
                
                resultCell = cell
            }
        }
        
        // cell選択時にハイライトさせない
        resultCell.selectionStyle = .none
        
        return resultCell
    }
}

// MARK: - UITableViewDelegate
extension RankingItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        CGFloat(rankingDisplayStyle.getCellHeight(mode: rankingViewModel.rankingMode))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        presenter.cellTapped(index: indexPath.section)
    }
}

// MARK: - RankingItemViewProtocol
extension RankingItemViewController: RankingItemViewProtocol {
    
    func setTitleName(title: String) {
        
        majorTitleLabel.text = title
    }
    
    func setTableViewCellHeight(height: Float) {
        
        tableViewCellHeight = CGFloat(height)
    }
    
    func flashCell(index: Int) {
        
        let indexPath = IndexPath(row: 0, section: index)
        
        // 選択したセルを取得
        guard let selectedCell = rankingTableView.cellForRow(at: indexPath) else { return }
        
        let cellColor = selectedCell.backgroundColor
        
        // 選択したセルを点滅
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveLinear, .repeat, .allowUserInteraction], animations: {
            
            selectedCell.backgroundColor = ConstantsColor.OFFICIAL_ORANGE_20
        })
        
        // リピート終了
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            
            // 点滅終了
            selectedCell.backgroundColor = cellColor
        }
    }
    
    func scrollTableView(index: Int, animated: Bool) {
        
        let indexPath = IndexPath(row: 0, section: index)
        
        // 選択した位置までスクロール
        rankingTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
    }
    
    func reloadTableView() {
        
        rankingTableView.reloadData()
    }
    
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?) {
        
        present(nextVC, animated: true) {
            
            completion?()
        }
    }
}
