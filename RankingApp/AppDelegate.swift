//
//  AppDelegate.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/07/08.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 本番環境の場合
        #if RELEASE // || ORIGINAL // || DEVELOP
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        #endif

        // DBのバージョンに応じてMigration
        RealmMigrationManager.shared.checkDatabaseVersion()
        
        // アプリの起動回数を保存
        setAppLauchCount()
        
        // UIの初期設定
        setUpUI()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // DBの中間データの履歴を解放
        DataBaseManager.shared.compactRealm()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /// アプリの起動回数を保存
    private func setAppLauchCount() {
        
        // アプリの起動回数を取得
        let launchAppCount = Constants.USER_DEFAULTS_STANDARD.integer(forKey: Constants.LAUNCH_APP_COUNT) + 1
        
        // アプリの起動回数を保存
        Constants.USER_DEFAULTS_STANDARD.set(launchAppCount, forKey: Constants.LAUNCH_APP_COUNT)
        
        // 起動回数に応じてレビューリクエストフラグを設定
        switch launchAppCount {
        case let count where count == 12 || count % 25 == 0:
            
            Constants.USER_DEFAULTS_STANDARD.set(true, forKey: Constants.IS_NEED_REQUEST_REVIEW)
            
            LogUtil.logAnalytics(logName: "AppDel_LaunchAppCount_\(launchAppCount)")
            
        default:
            break
        }
    }
    
    /// UIの初期設定
    private func setUpUI() {
        
        // キーボードはIQKeyboardManagerを利用
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = ConstantsColor.OFFICIAL_ORANGE_100
        
        // UINavigationBarの背景を設定
        let changedColorImage = UIImage(named: "left")!.chageImageColor(color: ConstantsColor.OFFICIAL_ORANGE_100)
        UINavigationBar.appearance().backIndicatorImage = changedColorImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = changedColorImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        // UITextViewのテキストにリンクが存在した場合の色を設定
        UITextView.appearance().linkTextAttributes = [.foregroundColor : ConstantsColor.OFFICIAL_ORANGE_70]
        
        // UITextViewのcaretの色を変更
        UITextView.appearance().tintColor = ConstantsColor.OFFICIAL_ORANGE_70
        // UITextFieldのcaretの色を変更
        UITextField.appearance().tintColor = ConstantsColor.OFFICIAL_ORANGE_70
        
        // UINavigationBarの背景色が実際より薄い色になるので対処
        // https://program-life.com/66
        UINavigationBar.appearance().isTranslucent = false
    }
}
