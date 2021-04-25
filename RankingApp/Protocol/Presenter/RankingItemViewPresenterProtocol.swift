//
//  RankingItemViewPresenterProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/19.
//

protocol RankingItemViewPresenterProtocol {
    
    func viewDidLoad()
    func viewWillAppear()
    func setIsNeedReloadTableView(isNeed: Bool)
    func getRankingViewModel() -> RankingViewModel
    func getRankingDisplayStyle() -> RankingDisplayStyle
    func toggleMode(rankingViewModel: RankingViewModel, callback: @escaping (RankingViewModel) -> Void)
    func cellTapped(index: Int)
    func searchTapped()
}
