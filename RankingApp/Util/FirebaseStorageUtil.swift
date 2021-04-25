//
//  FirebaseStorageUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/11/14.
//

import UIKit
import Firebase
import FirebaseUI
import GradientCircularProgress

final class FirebaseStorageUtil {
    
    static let shared = FirebaseStorageUtil()
    
    private init() {}
    
    /// 送信したランキングを削除
    func deleteData(rankingViewModel: RankingViewModel) {
        
        // structに変換
        let rankingForJson = rankingViewModel.createJsonData()
        
        // ストレージサーバのURLを取得
        let storage = Storage.storage(url: "gs://shul-ranking.appspot.com").reference()
        
        // ファイルパスとファイル名を設定
        let jsonRef = storage.child("ranking").child(rankingForJson.filePathAndName + ".json")
        
        // 削除の送信
        jsonRef.delete(completion: nil)
    }
    
    /// シェアするためランキングを送信
    func sentRankingForShare(rankingViewModel: RankingViewModel, completion: ((String) -> Void)? = nil) {
        
        // 4桁のランダムな数字
        let id = OtherUtil.randomString(length: 4)
        
        // idが既に発行しているものと被っていないかチェック
        FirebaseFirestoreUtil.shared.checkExistId(id: id) { isExist, id in
            
            // 被っていない場合
            if !isExist {
                
                // structに変換
                let rankingForJson = rankingViewModel.createJsonData()
                
                // ストレージサーバのURLを取得
                let storage = Storage.storage(url: "gs://shul-ranking-share").reference()
                
                let encoder = JSONEncoder()
                // JSONを読みやすくするため設定
                encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
                guard let jsonData = try? encoder.encode(rankingForJson) else { return }
                
                // ランキングのテキストデータ, メインの画像, 各順位の画像の全てを送信完了するまで待機させる
                // https://qiita.com/shtnkgm/items/d9b78365a12b08d5bde1
                // https://www.it-swarm-ja.tech/ja/swift/%E9%9D%9E%E5%90%8C%E6%9C%9F%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E8%A6%81%E6%B1%82%E3%82%92%E5%90%AB%E3%82%80swift-for-loop%E3%81%AE%E5%AE%9F%E8%A1%8C%E3%81%8C%E5%AE%8C%E4%BA%86%E3%81%99%E3%82%8B%E3%81%BE%E3%81%A7%E5%BE%85%E3%81%A4/823633444/
                
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                
                let jsonRef = storage.child(id).child("rankingJson.json")
                // 送信
                jsonRef.putData(jsonData, metadata: nil) { storageMetaData, error in
                    
                    dispatchGroup.leave()
                }
                
                dispatchGroup.enter()
                
                if let backgroundImage = rankingViewModel.mainImage {
                    
                    let mainImageRef = storage.child(id).child("mainImage.jpeg")
                    
                    // UIImageからJPEGに変換
                    guard let imageData = backgroundImage.jpegData(compressionQuality: 1.0) else { return }
                    // 送信
                    mainImageRef.putData(imageData, metadata: nil) { storageMetaData, error in
                        
                        dispatchGroup.leave()
                    }
                    
                } else {
                    
                    dispatchGroup.leave()
                }
                
                for rankingCellViewModel in rankingViewModel.rankingCellViewModelList {
                    
                    dispatchGroup.enter()
                    
                    if let rankImage = rankingCellViewModel.image {
                        
                        let rankImageRef = storage.child(id).child("rankImage" + String(rankingCellViewModel.num) + ".jpeg")
                        
                        // UIImageからJPEGに変換
                        guard let rankImageData = rankImage.jpegData(compressionQuality: 1.0) else { return }
                        
                        // 送信
                        rankImageRef.putData(rankImageData, metadata: nil) { storageMetaData, error in
                            
                            dispatchGroup.leave()
                        }
                    } else {
                        
                        dispatchGroup.leave()
                    }
                }
                
                // 全ての非同期処理終了後
                dispatchGroup.notify(queue: .main) {
                    
                    completion?(id)
                }
            }
            // 既に発行されていたidと同じだった場合
            else {
                // もう1回自分のメソッドを呼ぶ(ループ処理で記述しようとすると、非同期処理を待つ処理を記述しづらいためこの方法をとった)
                FirebaseStorageUtil.shared.sentRankingForShare(rankingViewModel: rankingViewModel, completion: completion)
            }
        }
    }
}
