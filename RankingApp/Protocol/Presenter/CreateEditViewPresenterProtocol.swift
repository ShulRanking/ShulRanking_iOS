//
//  CreateEditViewPresenterProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/12.
//

import UIKit

protocol CreateEditViewPresenterProtocol {
    
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func getRankingViewModel() -> RankingViewModel
    func getTableViewDisplayList() -> [RankingCellViewModel]
    func leftBarTapped()
    func settingBarTapped()
    func saveTapped()
    func rankingModeTapped()
    func sortTapped()
    func textFieldDidEndEditing(index: Int?, value: String)
    func descriptionTextViewDidEndEditing(index: Int, value: String)
    func imageDidEndEditing(index: Int?, image: UIImage, cropRect: CGRect?)
    func imageTapped(albumCropDelegate: Any, titleText: String, index: Int?, imageViewSize: CGSize)
    func deleteTapped(index: Int)
    func dragSorted(sourceIndex: Int, destinationIndex: Int)
    func scrollViewDidScroll(scrollBottom: Bool)
    func starEditing(index: Int, starNumArray: [Int])
    func starTextFieldDidEndEditing(text: String, titleIndex: Int)
}
