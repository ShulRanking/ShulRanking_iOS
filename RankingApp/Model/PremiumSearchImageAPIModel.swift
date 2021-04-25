//
//  PremiumSearchImageAPIModel.swift
//  ShulRanking
//
//  Created by 佐々木英彦 on 2021/02/20.
//

import UIKit

class PremiumSearchImageAPIModel {
    
    weak var delegate: PremiumSearchImageAPIModelProtocol?
    
    /// APIのURL
    private let entryUrl: String = "https://api.bing.microsoft.com/v7.0/images/search"
    /// APIを利用するためのサブスクリプションキー
    private let apikey: String = ""
    /// 現在表示している画像の添字を格納する変数
    private var imageSub: Int = 0
    
    /// 画像を格納する配列
    private var imageList: [UIImage] = []
    
    func logAnalytics(logName: String) {
        
        LogUtil.logAnalytics(logName: logName)
    }
    
    func searchImage(searchText: String, isMore: Bool) {
        
        // "もっと見る"をタップからきた場合
        if isMore {
            
            // パラメータのstartを150追加(次の150件を要求)
            imageSub = imageSub + 150
            
        } else {
            
            // 初期化
            imageSub = 0
            imageList = []
        }
        
        // 検索ワードが入っていなければリクエストは行わない
        if searchText.isEmpty {
            
            // 画像リストを空にして返却
            delegate?.imageSearchedResult(imageList: imageList)
            
            return
        }
        
        // 検索利用可能かチェック
        guard checkSearchable() else {
            
            // 検索不可能で返却(回数制限に達しているため)
            delegate?.impossibleSearhForCount()
            
            return
        }
        
        // 検索利用回数を取得
        let imageSearchCount = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.IMAGE_SEARCH_REMAINING_NUM)
        // 検索利用回数を保存
        Constants.USER_DEFAULTS_STANDARD.set(imageSearchCount - 1, forKey: Constants.IMAGE_SEARCH_REMAINING_NUM)
        
        // カウント減らす
        delegate?.decreaseSearchable(count: Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.IMAGE_SEARCH_REMAINING_NUM))
        
        // パラメータを指定
        let parameter = [
            "q" : searchText,
            "imageType" : "photo",
//            "mkt" : "ja-JP",
            "count" : "150",
            "offset": String(imageSub)]
        
        // パラメータをエンコードしたURLを作成
        let requestUrlStr = createRequestUrl(parameter: parameter)
        
        // APIをリクエスト
        request(requestUrlStr: requestUrlStr) { [weak self] imageURLList in
            
            guard let self = self, let imageURLList = imageURLList, !imageURLList.isEmpty else { return }
            
            for imageURL in imageURLList {
                
                if let url = URL(string: imageURL) {
                    
                    let request = URLRequest(url: url)
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        
                        if let data = data, let anImage = UIImage(data: data) {
                            
                            DispatchQueue.main.async {
                                
                                self.imageList.append(anImage)
                                
                                // 画像リストを返却
                                self.delegate?.imageSearchedResult(imageList: self.imageList)
                            }
                        }
                    }
                    
                    task.resume()
                }
            }
        }
    }
    
    /// パラメータをAPIコール用のURL作成
    private func createRequestUrl(parameter: [String : String]) -> String {
        
        var parameterStr = ""
        
        for key in parameter.keys {
            
            // 値の取り出し
            // 値をエンコードする
            guard let value = parameter[key],
                  let encodeValue = encodeParameter(key: key, value: value) else {
                // 値なし。次のループ
                continue
            }
            
            // 既にパラメータが設定されていた場合
            if 0 < parameterStr.lengthOfBytes(using: .utf8) {
                
                // パラメータ同士のセパレータである"&"を追加
                parameterStr += "&"
            }
            
            // エンコードした値をパラメータとして追加
            parameterStr += encodeValue
        }
        
        let requestUrlStr = entryUrl + "?" + parameterStr
        
        return requestUrlStr
    }
    
    /// パラメータのURLエンコード処理
    private func encodeParameter(key: String, value: String) -> String? {
        
        // 値をエンコードする
        guard let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // エンコード失敗
            return nil
        }
        
        // エンコードした値を"key=value"の形式で返却
        return key + "=" + escapedValue
    }
    
    /// APIをリクエストして画像URLの取得
    private func request(requestUrlStr: String, resultHandler: @escaping (([String]?) -> Void)) {
        
        // URL生成
        guard let url = URL(string: requestUrlStr) else {
            
            // URL生成失敗
            resultHandler(nil)
            
            return
        }
        
        // リクエスト生成
        var request = URLRequest(url: url)
        request.headers = ["Ocp-Apim-Subscription-Key" : apikey]
        
        // APIをコールして検索を行う
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            
            guard let self = self else {
                
                resultHandler(nil)
                
                return
            }
            
            // エラーチェック
            // JSONで返却されたデータをパースして格納する
            // JSON形式への変換処理
            // データを解析
            guard error == nil,
                  let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                
                self.delegate?.responseErrorOccurred(error: error)
                
                resultHandler(nil)
                
                return
            }
            
            // 通信成功
            // 検索結果をパースして返却
            self.parseData(json: jsonData, resultHandler: resultHandler)
        }
        
        // 通信開始
        task.resume()
    }
    
    /// 検索結果をパースし、画像URLのリストを返却
    private func parseData(json: Any, resultHandler: @escaping (([String]?) -> Void)) {
        
        guard let dataDic = json as? [String : Any],
              let valueList = dataDic["value"] as? [Any] else {
            
            resultHandler(nil)
            
            return
        }
        
        var imageURLList = [String]()
        
        for value in valueList {
            
            let itemInfoDic = value as? [String : Any]
            guard let imageURL = itemInfoDic?["contentUrl"] as? String else { continue }
            
            // リストに追加
            imageURLList.append(imageURL)
        }
        
        resultHandler(imageURLList)
    }
    
    /// 検索利用可能かチェック(検索利用可能回数に達していないか)
    private func checkSearchable() -> Bool {
        
        #if ORIGINAL
        return true
        #endif
        
        // 検索利用回数を取得
        let imageSearchCount = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.IMAGE_SEARCH_REMAINING_NUM)
        
        // 検索利用可能回数に達していればfalseを返す
        return 0 < imageSearchCount
    }
}

