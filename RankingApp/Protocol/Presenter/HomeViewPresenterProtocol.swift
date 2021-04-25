//
//  HomeViewPresenterProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/11/21.
//

protocol HomeViewPresenterProtocol {
    
    func viewWillAppear()
    func getRankingViewModelList() -> [RankingViewModel]
    func idTapped()
    func itemSelected(index: Int)
    func cellLongTapped(index: Int)
    func headerImageTapped(idDate: String?)
}
