//
//  SettingViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/08.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    
    private var presenter: SettingViewPresenterProtocol!
    
    private let cellTitle: String = "title"
    private let icon: String = "icon"
    
    private var sectionTitleArray: [String] {
        presenter.getSectionTitleArray()
    }
    
    private var titleIconDictionalyArray: [[[String: Any]]] {
        presenter.getTitleIconDictionalyArray()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = SettingViewPresenter(view: self)
        
        settingTableView.register(cellTypes: [SettingSwitchTableViewCell.self,
                                              SettingSegmentedSearchCell.self,
                                              SettingEntryTableViewCell.self])
        
        navigationItem.title = "設定"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    
    /// sectionの数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitleArray.count
    }
    
    /// sectionに情報を載せる
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitleArray[section]
    }
    
    /// cellの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleIconDictionalyArray[section].count
    }
    
    /// cellに情報を載せる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0, 1:
                
                let cell = tableView.dequeueReusableCell(with: SettingSwitchTableViewCell.self, for: indexPath)
                
                cell.setData(index: indexPath.row,
                             text: titleIconDictionalyArray[indexPath.section][indexPath.row][cellTitle] as! String,
                             image: titleIconDictionalyArray[indexPath.section][indexPath.row][icon] as! UIImage)
                
                return cell
                
            case 2:
                
                let cell = tableView.dequeueReusableCell(with: SettingSegmentedSearchCell.self, for: indexPath)
                
                cell.setData(text: titleIconDictionalyArray[indexPath.section][indexPath.row][cellTitle] as! String,
                             image: titleIconDictionalyArray[indexPath.section][indexPath.row][icon] as! UIImage)
                
                return cell
                
            default:
                
                let cell = tableView.dequeueReusableCell(with: SettingSwitchTableViewCell.self, for: indexPath)
                
                return cell
            }
            
        default:
            
            let cell = tableView.dequeueReusableCell(with: SettingEntryTableViewCell.self, for: indexPath)
            
            cell.setData(index: indexPath.row, text: titleIconDictionalyArray[indexPath.section][indexPath.row][cellTitle] as! String,
                         image: titleIconDictionalyArray[indexPath.section][indexPath.row][icon] as! UIImage)
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.itemSelected(indexSection: indexPath.section, indexRow: indexPath.row, mailComposeDelegate: self)
    }
    
    /// セクションの設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        
        if #available(iOS 13.0, *) {
            
            label.backgroundColor = .systemBackground
            
        } else {
            
            label.backgroundColor = .white
        }
        
        label.textColor = ConstantsColor.DARK_GRAY_CUSTOM_100
        label.text = " " + sectionTitleArray[section]
        label.font = .boldSystemFont(ofSize: 15.0)
        
        return label
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
            
        case .saved:
            break
            
        case .sent:
            break
            
        default:
            break
        }
        
        controller.dismiss(animated: true)
    }
}

// MARK: - SettingViewProtocol
extension SettingViewController: SettingViewProtocol {
    
    func showNetworkAlert() {
        
        AlertUtil.showNetworkAlert(vc: self)
    }
    
    func pushVC(nextVC: UIViewController) {
        
        tabBarController?.tabBar.isHidden = true
        
        // 遷移後の戻るボタンの文字を消しておく
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?) {
        
        present(nextVC, animated: true) {
            
            completion?()
        }
    }
}

// MARK: - SettingSwitchTableViewCellDelegate
extension SettingViewController: SettingSwitchTableViewCellDelegate {
    
    func policyErrorOccurred() {
        
        presenter.policyErrorOccurred()
    }
}
