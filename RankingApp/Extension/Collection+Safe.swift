//
//  Collection+Safe.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/12/11.
//

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
