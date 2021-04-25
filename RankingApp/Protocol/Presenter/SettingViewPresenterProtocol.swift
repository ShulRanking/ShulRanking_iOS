//
//  SettingViewPresenterProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/21.
//

import MessageUI

protocol SettingViewPresenterProtocol {
    
    func policyErrorOccurred()
    func getSectionTitleArray() -> [String]
    func getTitleIconDictionalyArray() -> [[[String: Any]]]
    func itemSelected(indexSection: Int, indexRow: Int, mailComposeDelegate: MFMailComposeViewControllerDelegate)
}
