//
//  ForthViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/08.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var summaryTableView: UITableView!
    private var editBarButtonItem: UIBarButtonItem!
    
    private var presenter: SummaryViewPresenterProtocol!
    
    private var rankingViewModelList: [RankingViewModel] {
        presenter.getRankingViewModelList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = SummaryViewPresenter(view: self)
        
        presenter.viewDidLoad()
        
        setUpNavigationItem()
        
        summaryTableView.register(cellType: SummaryTableViewCell.self)
        
        //        summaryTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        summaryTableView.flashScrollIndicators()
    }
    
    private func setUpNavigationItem() {
        
        var titleImageView: UIImageView
        titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.tintColor = ConstantsColor.DARK_GRAY_CUSTOM_100
        titleImageView.image = UIImage(named: "logoSideForNavi")
        navigationItem.titleView = titleImageView
        
        // 編集ボタン(保存ボタン)作成
        editBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "lineSpacing"),
            style: .plain,
            target: self,
            action: #selector(editOrSaveTapped(_:)))
        editBarButtonItem.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
        
        // 両端に置くダミーのBarButtonItemを3つ作成(ロゴの画像サイズを他の画面と合わせるため)
        var dummyBarButtonItemList = [UIBarButtonItem]()
        for _ in 0 ..< 3 {
            // 適当な画像設定
            let dummyBarButtonItem = UIBarButtonItem(image: UIImage(named: "clear"), style: .plain, target: nil, action: nil)
            // クリアな色設定
            dummyBarButtonItem.tintColor = .clear
            
            dummyBarButtonItemList.append(dummyBarButtonItem)
        }
        // ナビゲーションバーの両端に4つボタン付与
        navigationItem.setLeftBarButtonItems([dummyBarButtonItemList[0], dummyBarButtonItemList[1]], animated: false)
        navigationItem.setRightBarButtonItems([editBarButtonItem, dummyBarButtonItemList[2]], animated: false)
    }
    
    @objc func editOrSaveTapped(_ sender: UIBarButtonItem) {
        
        presenter.editOrSaveTapped()
    }
}

// MARK: - UITableViewDataSource
extension  SummaryViewController: UITableViewDataSource {
    
    /// sectionの数を決める
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    /// 1つのsectionの中に入れるcellの数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rankingViewModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: SummaryTableViewCell.self, for: indexPath)
        
        cell.setData(rankingViewModel: rankingViewModelList[indexPath.row], isHiddenEnterIcon: tableView.isEditing)
        
        return cell
    }
    
    /// 並び替え時の処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // 変更がない場合
        if sourceIndexPath == destinationIndexPath {
            return
        }
        
        presenter.sorted(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
    
    /// 指定された行をテーブルビューの別の場所に移動できるかどうかをデータソースに問い合わせる
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    /// 削除時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            presenter.rankingDeleted(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

// MARK: - UITableViewDelegate
extension  SummaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65.0
    }
    
    /// 削除する所のレイアウトの範囲確保するかみたいな？
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        tableView.isEditing ? .delete : .none
    }
    
    /// セルをタップされると呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        if summaryTableView.isEditing {
            return
        }
        
        presenter.itemSelected(index: indexPath.row)
    }
}

// MARK: - SummaryViewProtocol
extension SummaryViewController: SummaryViewProtocol {
    
    func setEditMode(isEdit: Bool, image: UIImage) {
        
        summaryTableView.isEditing = isEdit
        
        editBarButtonItem.image = image
    }
    
    func reloadTableView() {
        
        summaryTableView.reloadData()
    }
    
    func deleteRow(index: Int) {
        
        summaryTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    func pushVC(nextVC: UIViewController) {
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
