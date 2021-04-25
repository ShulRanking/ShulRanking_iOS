//
//  SummaryViewPresenterProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/20.
//

protocol SummaryViewPresenterProtocol {
    
    func viewDidLoad()
    func viewWillAppear()
    func getRankingViewModelList() -> [RankingViewModel]
    func sorted(sourceIndex: Int, destinationIndex: Int)
    func rankingDeleted(index: Int)
    func itemSelected(index: Int)
    func editOrSaveTapped()
}
