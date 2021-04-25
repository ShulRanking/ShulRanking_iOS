//
//  ThirdViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/08.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit
import RealmSwift
import GradientCircularProgress

class CreateEditViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rankingModeButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    
    private var presenter: CreateEditViewPresenterProtocol!
    
    private var rankingViewModel: RankingViewModel {
        presenter.getRankingViewModel()
    }
    
    private var imageRatioType: ImageRatioType {
        rankingViewModel.imageRatioType
    }
    
    private var tableViewDisplayList: [RankingCellViewModel] {
        presenter.getTableViewDisplayList()
    }
    
    init(rankingViewModel: RankingViewModel?, isEdit: Bool) {
        
        super.init(nibName: "CreateEditViewController", bundle: nil)
        
        let rankingViewModel = rankingViewModel == nil ? RankingViewModel() : rankingViewModel!
        presenter = CreateEditViewPresenter(view: self, rankingViewModel: rankingViewModel, isEdit: isEdit)
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        setUpTableView()
        
        setUpItemButton()
        
        setUpNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
        
        tableView.flashScrollIndicators()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setUpTableView() {
        
        tableView.isEditing = true
        // cellをタップ選択可能に
        tableView.allowsSelectionDuringEditing = true
        
        let createEditSectionHeaerViewNib = UINib(nibName: CreateEditSectionHeaerView.className, bundle: nil)
        tableView.register(createEditSectionHeaerViewNib, forHeaderFooterViewReuseIdentifier: CreateEditSectionHeaerView.className)
        
        tableView.register(cellTypes: [CreateEditTableViewCell.self,
                                       CreateEditStarHeaderTableViewCell.self,
                                       CreateEditStarTableViewCell.self])
    }
    
    private func setUpItemButton() {
        
        // 動的につけないと影がつかない
        rankingModeButton.layer.cornerRadius = rankingModeButton.bounds.width / 2
        // 影の設定
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        rankingModeButton.layer.shadowOffset = CGSize(width: 0.75, height: 1.0)
        // 影の色
        rankingModeButton.layer.shadowColor = ConstantsColor.REVERSE_SYSTEM_BACKGROUND_100.cgColor
        // 影の濃さ
        rankingModeButton.layer.shadowOpacity = 0.2
        // 影をぼかし
        rankingModeButton.layer.shadowRadius = 3
        
        sortButton.layer.cornerRadius = sortButton.bounds.width / 2
        // 影の設定
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        sortButton.layer.shadowOffset = CGSize(width: 0.75, height: 1.0)
        // 影の色
        sortButton.layer.shadowColor = ConstantsColor.REVERSE_SYSTEM_BACKGROUND_100.cgColor
        // 影の濃さ
        sortButton.layer.shadowOpacity = 0.2
        // 影をぼかし
        sortButton.layer.shadowRadius = 3
    }
    
    private func setUpNavigationItem() {
        
        // 戻るボタン作成
        let backButton = UIBarButtonItem(
            image: UIImage(named: "exit"),
            style: .plain,
            target: self,
            action: #selector(leftBarTapped))
        backButton.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
        
        // ナビゲーションバーの左側にボタン付与
        navigationItem.setLeftBarButtonItems([backButton], animated: false)
        
        // 保存ボタン作成
        let saveButton = UIBarButtonItem(
            image: UIImage(named: "save"),
            style: .plain,
            target: self,
            action: #selector(saveTapped))
        saveButton.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
        
        // 設定ボタン作成
        let settingButton = UIBarButtonItem(
            image: UIImage(named: "setting"),
            style: .plain,
            target: self,
            action: #selector(settingBarTapped))
        settingButton.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
        
        // ナビゲーションバーの右側にボタン付与
        navigationItem.setRightBarButtonItems([saveButton, settingButton], animated: false)
    }
    
    /// クリア, 戻るボタンタップ
    @objc func leftBarTapped(_ sender: UIBarButtonItem) {
        
        presenter.leftBarTapped()
    }
    
    /// 設定ボタンタップ
    @objc func settingBarTapped(_ sender: UIBarButtonItem) {
        
        presenter.settingBarTapped()
    }
    
    /// 保存ボタンタップ
    @objc func saveTapped(_ sender: UIBarButtonItem) {
        
        presenter.saveTapped()
    }
    
    @IBAction func rankingModeTapped(_ sender: UIButton) {
        
        presenter.rankingModeTapped()
    }
    
    @IBAction func sortTapped(_ sender: UIButton) {
        
        presenter.sortTapped()
    }
}

// MARK: - UITableViewDataSource
extension CreateEditViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewDisplayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch rankingViewModel.rankingMode {
        case .normal:
            
            let cell = tableView.dequeueReusableCell(with: CreateEditTableViewCell.self, for: indexPath)
            cell.setData(rankinCellData: tableViewDisplayList[indexPath.row], imageRatioType: imageRatioType)
            cell.baseCreateEditCellDelegate = self
            
            return cell
            
        case .star:
            
            let starTitleTextArray: [String] = [rankingViewModel.starTitle1, rankingViewModel.starTitle2, rankingViewModel.starTitle3, rankingViewModel.starTitle4, rankingViewModel.starTitle5]
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(with: CreateEditStarHeaderTableViewCell.self, for: indexPath)
                cell.setData(rankinCellData: tableViewDisplayList[indexPath.row], imageRatioType: imageRatioType, itemTextArray: starTitleTextArray)
                cell.baseCreateEditCellDelegate = self
                cell.starDelegate = self
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(with: CreateEditStarTableViewCell.self, for: indexPath)
                cell.setData(rankinCellData: tableViewDisplayList[indexPath.row], imageRatioType: imageRatioType, itemTextArray: starTitleTextArray)
                cell.baseCreateEditCellDelegate = self
                cell.starDelegate = self
                
                return cell
            }
        }
    }
    
    /// 並び替え時の処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        presenter.dragSorted(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
    
    /// 指定された行をテーブルビューの別の場所に移動できるかどうかをデータソースに問い合わせる
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

// MARK: - UITableViewDelegate
extension CreateEditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let createEditTableViewCellHeight: CGFloat = 85
        let createEditStarTableViewCellHeight: CGFloat = 250
        
        switch rankingViewModel.rankingMode {
        case .normal:
            return createEditTableViewCellHeight
            
        case .star:
            return createEditStarTableViewCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: CreateEditSectionHeaerView.className)
        
        if let createEditSectionHeaerView = view as? CreateEditSectionHeaerView {
            
            createEditSectionHeaerView.setData(rankingViewModel: rankingViewModel)
            createEditSectionHeaerView.delegate = self
            
            return createEditSectionHeaerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }
}

// MARK: - UIScrollViewDelegate
extension CreateEditViewController: UIScrollViewDelegate {
    
    /// スクロール中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // tableViewを一番下までスクロールしているか
        let scrollBottom = tableView.contentSize.height <= tableView.contentOffset.y + tableView.frame.size.height
        
        presenter.scrollViewDidScroll(scrollBottom: scrollBottom)
    }
}

// MARK: - CreateEditTableViewCellDelegate
extension CreateEditViewController: CreateEditTableViewCellDelegate {
    
    /// セルのタイトル入力終了時
    func textFieldDidEndEditing(cell: BaseEditTableViewCell?, text: String) -> () {
        
        var index: Int?
        
        if let cell = cell {
            
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            index = indexPath.row
        }
        
        presenter.textFieldDidEndEditing(index: index, value: text)
    }
    
    /// セルの説明欄入力時
    func descriptionTextViewDidEndEditing(cell: BaseEditTableViewCell, text: String) {
        
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        
        presenter.descriptionTextViewDidEndEditing(index: index, value: text)
    }
    
    /// セルの写真入力時
    func imageDidEndEditing(cell: BaseEditTableViewCell?, image: UIImage?, cropRect: CGRect?) {
        
        guard let image = image else { return }
        
        var index: Int?
        
        if let cell = cell {
            
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            index = indexPath.row
        }
        
        presenter.imageDidEndEditing(index: index, image: image, cropRect: cropRect)
        
    }
    
    func deleteButtonTapped(cell: BaseEditTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter.deleteTapped(index: indexPath.row)
    }
    
    func displayItemMenu(menuVC: MenuDialogViewController) {
        
        present(menuVC, animated: true)
    }
    
    func imageTapped(albumCropDelegate: Any, titleText: String, cell: BaseEditTableViewCell?, imageViewSize: CGSize) {
        
        var index: Int?
        
        if let cell = cell {
            
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            index = indexPath.row
        }
        
        presenter.imageTapped(albumCropDelegate: albumCropDelegate, titleText: titleText, index: index, imageViewSize: imageViewSize)
    }
}

// MARK: - CreateEditStarTableViewCellDelegate
extension CreateEditViewController: CreateEditStarTableViewCellDelegate {
    
    func starEditing(cell: BaseEditTableViewCell, starNumArray: [Int]) {
        
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        
        presenter.starEditing(index: index, starNumArray: starNumArray)
    }
    
    func starTextFieldDidEndEditing(text: String, titleIndex: Int) {
        
        presenter.starTextFieldDidEndEditing(text: text, titleIndex: titleIndex)
    }
}

extension CreateEditViewController: CreateEditViewProtocol {
    
    func setEdit() {
        
        navigationItem.title = "編集"
        rankingModeButton.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    func setCreate() {
        
        navigationItem.title = "新規作成"
        rankingModeButton.isHidden = false
        tabBarController?.tabBar.isHidden = false
        
        // クリアボタン作成
        let plusButton = UIBarButtonItem(
            image: UIImage(named: "clear"),
            style: .plain,
            target: self,
            action: #selector(leftBarTapped))
        plusButton.tintColor = ConstantsColor.OFFICIAL_ORANGE_100
        
        // ナビゲーションバーの左側にボタン付与
        navigationItem.setLeftBarButtonItems([plusButton], animated: false)
    }
    
    func setRankingModeButton(isHidden: Bool) {
        rankingModeButton.isHidden = isHidden
    }
    
    func setSortButtonHidden(isHidden: Bool) {
        sortButton.isHidden = isHidden
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func reloadRowsExceptStarHeader() {
        
        for i in 1 ..< tableViewDisplayList.count {
            
            guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) else { break }
            
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            // CreateEditStarHeaderTableViewCell(indexが0)以外のcellを更新
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func reloadRow(index: Int) {
        
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func deleteRow(index: Int) {
        
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    func insertRow(index: Int) {
        
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
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
    
    func showNetworkAlert() {
        
        AlertUtil.showNetworkAlert(vc: self)
    }
    
    func backVC() {
        
        tabBarController?.tabBar.isHidden = false
        // 1つ前の画面に戻る
        navigationController?.popViewController(animated: true)
    }
    
    func endEditing() {
        // 編集中のテキストを完了させる
        view.endEditing(true)
    }
    
    func showProgress(gcp: GradientCircularProgress) {
        // プログレスビュー表示開始
        gcp.showAtRatio(display: true, style: OfficialStyle())
    }
}
