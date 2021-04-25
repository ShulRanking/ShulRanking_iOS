//
//  RankingItemModelProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/19.
//

protocol RankingItemModelProtocol: class {
    
    func saveDBModeChangeCompleted(rankingViewModel: RankingViewModel)
}
