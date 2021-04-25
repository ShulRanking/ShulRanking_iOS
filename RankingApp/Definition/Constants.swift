//
//  Constants.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/11/24.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import LocalAuthentication
import UIKit

class Constants {
    
    static let APP_VERSION = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    static let USER_DEFAULTS_STANDARD: UserDefaults = UserDefaults.standard
    
    static let LOGO_ICON_IMAGE: UIImage = UIImage(named: "appIconBackNothing")!
    static let LOGO_SIDE_IMAGE: UIImage = UIImage(named: "logoSide")!
    
    static var RANKING_SUM: Int {
        
        #if DEBUG || RELEASE || DEVELOP
        return 50
        #elseif ORIGINAL
        return 150
        #endif
    }
    
    static let ITEM_SUM = 5
    static let STAR_SUM = 7
    
    static let MAIL_ADDRESS = "shul.ranking@gmail.com"
    static let APP_STORE_URL = "https://apps.apple.com/us/app/shul-ranking/id1493982688?l=ja&ls=1"
    
    static let STAR_EMPTY = "☆"
    static let STAR_FILL = "★"
    
    // MARK: - ButtonName
    static let BUTTON_NAME_DELETE = "削除"
    static let BUTTON_NAME_CANCEL = "キャンセル"
    
    // MARK: - UserDufaultKeys
    static let IS_INSTALLED = "isInstalled"
    static let NOW_VERSION = "nowVersion"
    static let IS_LOCK = "isLock"
    static let DISPLAY_DIALOG = "displayDialog"
    static let SEARCH_ENGINE = "searchEngine"
    static let RANKING_MODE = "rankingMode"
    static let USER_ID = "userID"
//    static let HAS_REVIEWED = "hasReviewed"
    static let RANKING_DETAIL_IS_CHART = "rankingDetailIsChart"
    static let RANKING_ITEM_STYLE = "rankingItemStyle"
    static let IMAGE_SEARCH_REMAINING_NUM = "imageSearchRemainingNum"
    static let LAUNCH_APP_COUNT = "launchAppCount"
    static let IS_NEED_REQUEST_REVIEW = "isNeedRequestReview"
    
    static let TO_WEB_VIEW = "toWebView"
    static let TO_DETAIL_TABLE_VIEW = "toDetailTableView"
    static let TO_SETTING_RESULT = "toSettingResult"
    static let TO_MAIL = "toMail"
    static let TO_REVIEW = "toReview"
    static let TO_APP_SHARE = "toAppShare"
    
    // MARK: - NotificationLabels
    static let INTRODUCTION = "introduction"
    static let NEW_NOTIFICATION = "new function"
    static let GREETING = "greeting"
    
    // MARK: - HomeHeaderCollectionViewCellLabels
    static let NOTIFICATION = "notification"
    static let ORIGINAL = "original"
    
    static let ORIGINAL_RANKING = "< created"
    
    static let SETTING_SEARCH_ENGINE = "検索エンジン"
    
    static let RIBBON_TEXT: String = "ribbonText"
    static let CELL_TITLE: String = "cellTitle"
    static let URL_D: String = "urlD"
    static let URL_L: String = "urlL"
    
    static var isFirstEdit = true
    
    static let notificationTitleIconDictionalyArray: [[String: String]] = [
        
        [Constants.RIBBON_TEXT: Constants.NEW_NOTIFICATION,
         Constants.CELL_TITLE: "ランキングから検索ができるようになりました。\n検索を利用することで目的の順位を素早く特定し、似たような項目の重複があるかもチェックできます。\n各順位のタイトルとコメントが検索対象です。\n検索結果をタップするとその順位までスクロールされます。",
         Constants.URL_D: "https://shul-ranking.firebaseapp.com/notificationSearchRankD.png",
         Constants.URL_L: "https://shul-ranking.firebaseapp.com/notificationSearchRankL.png"],
        
        [Constants.RIBBON_TEXT: Constants.INTRODUCTION,
         Constants.CELL_TITLE: "ランキングをデータでシェアできます。\nデータでシェアすることで、家族や恋人やご学友と一緒にランキングを編集できます。\n\n[シェアする人の手順]\n- シェアしたいランキング画面の右上のボタンをタップ\n- \"IDでシェア\"をタップ\n- IDが発行されるのでシェアしたい人に教える\n\n[シェアされた人の手順]\n- ホーム画面左下のIDボタンをタップ\n- IDを入力し、検索ボタンをタップ\n- ランキングの保存完了\n\nシェアされた相手も、Shul Rankingのアプリ(iOSのみ)をインストールしている必要があります。\nIDの発行，ランキングの取得には、通信状況，データのサイズによってしばらく時間がかかります。",
         Constants.URL_D: "https://shul-ranking.firebaseapp.com/notificationShareIdD.png",
         Constants.URL_L: "https://shul-ranking.firebaseapp.com/notificationShareIdL.png"],
        
        [Constants.RIBBON_TEXT: Constants.INTRODUCTION,
         Constants.CELL_TITLE: "ランキング50位まで作成できます。\n既存のランキングでも編集画面から50位まで作成可能です。",
         Constants.URL_D: "https://shul-ranking.firebaseapp.com/notificationRanking50D.png",
         Constants.URL_L: "https://shul-ranking.firebaseapp.com/notificationRanking50L.png"],
        
        [Constants.RIBBON_TEXT: Constants.INTRODUCTION,
         Constants.CELL_TITLE: "作成したランキングの表示スタイルを選べます。\nスタイルの変更方法は、画面中央をスワイプ，または上部のタブをタップ，スクロールの3通りです。\nデザイン，レイアウトのリクエストがありましたら、”新機能のリクエスト”からお待ちしています。",
         Constants.URL_D: "https://shul-ranking.firebaseapp.com/notificationTabStyleD.png",
         Constants.URL_L: "https://shul-ranking.firebaseapp.com/notificationTabStyleL.png"],
        
        [Constants.RIBBON_TEXT: Constants.INTRODUCTION,
         Constants.CELL_TITLE: "個別のランキング画面の右上のボタンをタップするとこちらのメニュー画面が表示されます。\n既存のランキングを利用して新しいランキングが作りやすくなります。",
         Constants.URL_D: "https://shul-ranking.firebaseapp.com/notificationRankingItemD.png",
         Constants.URL_L: "https://shul-ranking.firebaseapp.com/notificationRankingItemL.png"],
        
        [Constants.RIBBON_TEXT: Constants.INTRODUCTION,
         Constants.CELL_TITLE: "項目ごとの評価を設定して、レーダーチャートで確認できます。\nあなたのお気に入りの飲食店や宿を評価してみてください。\n作成画面の左下のボタンでモードが切り替わります。\n右下にあるソートボタンを押すことで星の数に応じて順番が入れ替わります。",
         Constants.URL_D: "https://shul-ranking.firebaseapp.com/notificationStarD.png",
         Constants.URL_L: "https://shul-ranking.firebaseapp.com/notificationStarL.png"],
        
        [Constants.RIBBON_TEXT: Constants.INTRODUCTION,
         Constants.CELL_TITLE: "デペロッパーに新機能のリクエストを送ることができます。\nあなたのアイデアやご希望をお気軽に送ってみてください。",
         Constants.URL_D: "https://shul-ranking.firebaseapp.com/notificationReqD.png",
         Constants.URL_L: "https://shul-ranking.firebaseapp.com/notificationReqL.png"],
        
        [Constants.RIBBON_TEXT: Constants.GREETING,
         Constants.CELL_TITLE: "インストールして頂きありがとうございます。\n自分だけのランキングをたくさん作ってお楽しみください。",
         Constants.URL_D: "https://shul-ranking.firebaseapp.com/notificationLogoD.png",
         Constants.URL_L: "https://shul-ranking.firebaseapp.com/notificationLogoL.png"]
    ]
}
