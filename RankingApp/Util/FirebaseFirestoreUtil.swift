//
//  FirebaseFirestoreUtil.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/12/05.
//

import Firebase
import GradientCircularProgress

final class FirebaseFirestoreUtil {
    
    static let shared = FirebaseFirestoreUtil()
    
    private init() {}
    
    /// ランキングを取得してDBに保存する
    func getSharedRanking(id: String, completion: @escaping (Bool) -> Void) {
        
        let db = Firestore.firestore()
        
        // ランキングのテキストデータ -> 画像URL -> メインの画像 -> 各順位の画像の順に全てを受信完了してから、DB保存とcompletion
        // https://qiita.com/shtnkgm/items/d9b78365a12b08d5bde1
        // https://www.it-swarm-ja.tech/ja/swift/%E9%9D%9E%E5%90%8C%E6%9C%9F%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E8%A6%81%E6%B1%82%E3%82%92%E5%90%AB%E3%82%80swift-for-loop%E3%81%AE%E5%AE%9F%E8%A1%8C%E3%81%8C%E5%AE%8C%E4%BA%86%E3%81%99%E3%82%8B%E3%81%BE%E3%81%A7%E5%BE%85%E3%81%A4/823633444/
        // https://dev.classmethod.jp/articles/gcd_swift/
        
        var mainImageURL: URL?
        var rankImageURLDic = [Int : URL?]()
        var rankingForJson: RankingForJson!
        
        let dispatchGroup0 = DispatchGroup()
        let dispatchQueue0 = DispatchQueue.global(qos: .default)
        
        dispatchGroup0.enter()
        dispatchQueue0.async(group: dispatchGroup0) {
            
            // ランキングのテキストデータを取得
            let jsonRef = db.collection("share").document("id").collection(id).document("rankingJson")
            jsonRef.getDocument { document, error in
                
                if let documentData = document?.data() {
                    
                    guard let url = URL(string: documentData["downloadUrl"] as! String) else { return }
                    
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        
                        guard error == nil, let jsonData = data else { return }
                        
                        let decoder = JSONDecoder()
                        
                        if let responceJson = try? decoder.decode(RankingForJson.self, from: jsonData) {
                            
                            rankingForJson = responceJson
                            
                        } else {
                            
                            // 取得失敗(jsonの中身がアプリのバージョンによって違うなどの原因)
                            completion(false)
                            
                            return
                        }
                        
                        dispatchGroup0.leave()
                        
                    }.resume()
                    
                } else {
                    
                    // idが存在しない
                    completion(false)
                    
                    return
                }
            }
            
            dispatchGroup0.notify(queue: .main) {
                
                let dispatchGroup1 = DispatchGroup()
                let dispatchQueue1 = DispatchQueue.global(qos: .default)
                
                dispatchGroup1.enter()
                dispatchQueue1.async(group: dispatchGroup1) {
                    
                    // メイン画像のURLを取得
                    let mainImageRef = db.collection("share").document("id").collection(id).document("mainImage")
                    mainImageRef.getDocument { document, error in
                        
                        if let documentData = document?.data() {
                            
                            mainImageURL = URL(string: documentData["downloadUrl"] as! String)
                        }
                        
                        dispatchGroup1.leave()
                    }
                }
                
                // 各順位画像のURLを取得
                for rankNum in 1 ... Constants.RANKING_SUM {
                    
                    dispatchGroup1.enter()
                    dispatchQueue1.async(group: dispatchGroup1) {
                        
                        let rankImageRef = db.collection("share").document("id").collection(id).document("rankImage" + String(rankNum))
                        rankImageRef.getDocument { document, error in
                            
                            if let documentData = document?.data() {
                                
                                rankImageURLDic[rankNum] = URL(string: documentData["downloadUrl"] as! String)
                            }
                            
                            dispatchGroup1.leave()
                        }
                    }
                }
                
                dispatchGroup1.notify(queue: .main) {
                    
                    let dispatchGroup2 = DispatchGroup()
                    let dispatchQueue2 = DispatchQueue.global(qos: .default)
                    
                    dispatchGroup2.enter()
                    dispatchQueue2.async(group: dispatchGroup2) {
                        
                        if let url = mainImageURL {
                            
                            URLSession.shared.dataTask(with: url) { data, response, error in
                                
                                guard error == nil, let imageData = data else { return }
                                
                                rankingForJson.mainImageData = imageData
                                
                                dispatchGroup2.leave()
                                
                            }.resume()
                            
                        } else {
                            
                            dispatchGroup2.leave()
                        }
                    }
                    
                    for (num, rankImageURL) in rankImageURLDic {
                        
                        dispatchGroup2.enter()
                        dispatchQueue2.async(group: dispatchGroup2) {
                            
                            if let url = rankImageURL {
                                
                                URLSession.shared.dataTask(with: url) { data, response, error in
                                    
                                    guard error == nil, let imageData = data else { return }
                                    
                                    rankingForJson.zzzRankingCellForJsonList[num - 1].imageData = imageData
                                    
                                    dispatchGroup2.leave()
                                    
                                }.resume()
                                
                            } else {
                                
                                dispatchGroup2.leave()
                            }
                        }
                    }
                    
                    dispatchGroup2.notify(queue: .main) {
                        
                        // DBに保存
                        DataBaseManager.shared.saveRankingViewModelToDB(rankingViewModel: rankingForJson.createRankingViewModel(), isEdit: false)
                        
                        completion(true)
                    }
                }
            }
        }
    }
    
    /// IDが既に発行されているものと被っているかチェック
    func checkExistId(id: String, completion: @escaping (Bool, String) -> Void) {
        
        let db = Firestore.firestore()
        
        let idRef = db.collection("share").document("id").collection(id).document("rankingJson")
        idRef.getDocument { document, error in
            
            completion(document?.exists ?? true, id)
        }
    }
}
