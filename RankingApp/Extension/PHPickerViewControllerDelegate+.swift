//
//  PHPickerViewControllerDelegate+.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/10/11.
//

import PhotosUI

@available(iOS 14, *)
extension PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func makeUIViewController(selectionLimit: Int) -> PHPickerViewController {
        
        var configuration = PHPickerConfiguration()
        // 静止画(Live含)を選択
        configuration.filter = .images
        // 選択可能な枚数を設定
        configuration.selectionLimit = selectionLimit
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        return picker
    }
}
