//
//  GoogleSearchImageAPIModel.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/21.
//

import UIKit

class GoogleSearchImageAPIModel {
    
    weak var delegate: GoogleSearchImageAPIModelProtocol?
    
    /// APIのURL
    private let entryUrl: String = "https://www.googleapis.com/customsearch/v1"
    /// APIを利用するためのアプリケーションID
    private let apikey: String = ""
    /// APIを利用するためのサーチエンジンキー
    private let cx: String = ""
    /// 利用するAPIのサーチタイプ
    private let searchType: String = "image"
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
            
            // パラメータのstartを10追加(次の10件を要求)
            imageSub = imageSub + 10
            
        } else {
            
            // 初期化
            imageSub = 0
            imageList = []
        }
        
        // 検索ワードが入っていなければリクエストは行わない
        if searchText.isEmpty {
            
            // 画像リストを返却
            delegate?.imageSearchedResult(imageList: imageList)
            
            return
        }
        
        // パラメータを指定
        let parameter = [
            "key": apikey,
            "cx": cx,
            "searchType": searchType,
            "q": searchText,
            "start": String(imageSub)]
        
        // パラメータをエンコードしたURLを作成
        let requestUrlStr = createRequestUrl(parameter: parameter)
        
        // APIをリクエスト
        request(requestUrlStr: requestUrlStr) { [weak self] resultList in
            
            guard let self = self, let resultList = resultList, !resultList.isEmpty else { return }
            
            for element in resultList {
                
                if let url = URL(string: element) {
                    
                    let req = URLRequest(url: url)
                    let task = URLSession.shared.dataTask(with: req) { data, response, error in
                        
                        if let data = data, let anImage = UIImage(data: data) {
                            
                            DispatchQueue.main.async {
                                
                                self.imageList.append(anImage)
                                
                                self.delegate?.imageSearchedResult(imageList: self.imageList)
                            }
                        }
                    }
                    
                    task.resume()
                }
            }
        }
    }
    
    /// APIコール用のURL作成
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
        let request = URLRequest(url: url)
        
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
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any],
                  let resultSet = jsonData["items"] as? [Any] else {
                
                self.delegate?.responseErrorOccurred(error: error)
                
                resultHandler(nil)
                
                return
            }
            
            // 通信成功
            // 検索結果をパースして返却
            self.parseData(items: resultSet, resultHandler: resultHandler)
        }
        
        // 通信開始
        task.resume()
    }
    
    /// 検索結果をパースし、画像URLのリストを返却
    private func parseData(items: [Any], resultHandler: @escaping (([String]?) -> Void)) {
        
        var list = [String]()
        
        for item in items {
            
            // レスポンスデータから画像の情報を取得する
            guard let item = item as? [String : Any], let imageURL = item["link"] as? String else {
                
                resultHandler(nil)
                
                return
            }
            
            // リストに追加
            list.append(imageURL)
        }
        
        resultHandler(list)
    }
}
