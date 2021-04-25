//
//  SearchRankViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/02/06.
//

import UIKit

class SearchRankViewController: BaseModalViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var rankingTableView: UITableView!
    
    private let rankingCellViewModelList: [RankingCellViewModel]
    private let completion: (Int) -> Void
    
    private var filterList: [RankingCellViewModel]
    
    init(rankingCellViewModelList: [RankingCellViewModel], completion: @escaping (Int) -> Void) {
        
        self.rankingCellViewModelList = rankingCellViewModelList
        self.completion = completion
        filterList = self.rankingCellViewModelList
        
        super.init(nibName: "SearchRankViewController", bundle: nil, isCloseBackgroundTouch: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankingTableView.register(cellType: RankingItemTextTableViewCell.self)
        
        // textFieldにフォーカス当てる
        searchTextField.becomeFirstResponder()
        
        // textFiledの変更をリアルタイムで受け取るメソッドを設定
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        LogUtil.logAnalytics(logName: "SearchRankVC")
    }
    
    /// textFiledの変更をリアルタイムで受け取る
    @objc func textFieldDidChange(textField: UITextField) {
        
        fileter(text: textField.text)
    }
}

// MARK: - UITableViewDataSource
extension SearchRankViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: RankingItemTextTableViewCell.self, for: indexPath)
        cell.setData(rankinCellData: filterList[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchRankViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = rankingCellViewModelList.firstIndex { rankingCellViewModel -> Bool in
            
            rankingCellViewModel.num == filterList[indexPath.row].num
        }
        
        dismiss(animated: true)
        
        completion(index!)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        searchTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension SearchRankViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // キーボード閉じる
        view.endEditing(true)
        
        return true
    }
    
    private func fileter(text: String?) {
        
        guard let text = text else { return }
        
        if text.isEmpty {
            
            filterList = rankingCellViewModelList
            
            rankingTableView.reloadData()
            
        } else {
            
            filterList = rankingCellViewModelList.filter { rankingCellViewModel -> Bool in
                
                rankingCellViewModel.rankTitle.localizedCaseInsensitiveContains(text) ||
                    rankingCellViewModel.rankDescription.localizedCaseInsensitiveContains(text)
            }
            
            rankingTableView.reloadData()
        }
    }
}
