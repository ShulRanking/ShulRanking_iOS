//
//  RankingMainViewPresenterProtocol.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/17.
//

protocol RankingMainViewPresenterProtocol {
    
    func viewDidLoad()
    func customBackTapped()
    func createTapped()
    func screenShotTapped()
    func editTapped()
    func itemsTapped()
    func screenShotDecisionTapped(topIndex: Int, bottomIndex: Int)
}
