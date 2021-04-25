//
//  WebImageType.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/11/04.
//

import Foundation

enum WebImageType: String, CaseIterable {
    
    case google = "https://www.google.co.jp/imghp?hl=ja"
    case yahoo = "https://search.yahoo.co.jp/image"
    case bing = "https://www.bing.com/images/"
    
    static func getNowWebImageType() -> WebImageType {
        
        getWebImageTypeForRawValue(rawValue: Constants.USER_DEFAULTS_STANDARD.string(forKey: Constants.SEARCH_ENGINE)!)
    }
    
    static func getWebImageTypeForIndex(index: Int) -> WebImageType {
        
        allCases.first { $0.getIndex() == index } ?? .google
    }
    
    func getIndex() -> Int {
        
        switch self {
        case .google:
            return 0
            
        case .yahoo:
            return 1
            
        case .bing:
            return 2
        }
    }
    
    func getSearchedUrl(word: String) -> String {
        
        let encodedWord = word.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        
        switch self {
        case .google:
            return "https://www.google.co.jp/search?q=" + encodedWord + "&tbm=isch"
            
        case .yahoo:
            return rawValue + "/search?p=" + encodedWord + "&ei=UTF-8"
            
        case .bing:
            return rawValue + "search?q=" + encodedWord + "&form=HDRSC2"
        }
    }
    
    private static func getWebImageTypeForRawValue(rawValue: String) -> WebImageType {
        
        allCases.first { $0.rawValue == rawValue } ?? .google
    }
}
