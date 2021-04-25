//
//  SearchImageWebViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/12/01.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit
import WebKit

class SearchImageWebViewController: BaseModalViewController {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.isEnabled = false
            backButton.alpha = 0.4
        }
    }
    
    @IBOutlet weak var forwardButton: UIButton! {
        didSet {
            forwardButton.isEnabled = false
            forwardButton.alpha = 0.4
        }
    }
    
    private let searchWord: String

    init(searchWord: String) {
        
        self.searchWord = searchWord
        
        super.init(nibName: "SearchImageWebViewController", bundle: nil, isCloseBackgroundTouch: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: WebImageType.getNowWebImageType().getSearchedUrl(word: searchWord)) else { fatalError() }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func loadView() {
        super.loadView()
        
        _ = WKWebViewConfiguration()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    @IBAction func tappedReload(_ sender: UIButton) {
        webView.reload()
    }
    
    @IBAction func tappedScrollTop(_ sender: UIButton) {
        webView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        webView.goBack()
    }
    
    @IBAction func tappedForward(_ sender: UIButton) {
        webView.goForward()
    }
}

// MARK: - WKUIDelegate
extension SearchImageWebViewController: WKUIDelegate {
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void) {
        
        // alert対応
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void) {
        
        // confirm対応
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(false)
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler(true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void) {
        
        // prompt対応
        let alertController  = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        
        let okHandler: () -> Void = {
            
            if let textField = alertController.textFields?.first {
                
                completionHandler(textField.text)
                
            } else {
                
                completionHandler("")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
            completionHandler(nil)
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            okHandler()
        }
        
        alertController.addTextField { $0.text = defaultText }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - WKNavigationDelegate
extension SearchImageWebViewController: WKNavigationDelegate {
    
    // https://qiita.com/t__nabe/items/4cc9650b1131f6d4d114
    // 認証対応
    func webView(
        _ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // SSL/TLS接続ならここで処理する
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                
                completionHandler(.rejectProtectionSpace, nil)
                
                return
            }
            
            var trustResult = SecTrustResultType.invalid
            guard SecTrustEvaluate(serverTrust, &trustResult) == noErr else {
                
                completionHandler(.rejectProtectionSpace, nil)
                
                return
            }
            
            switch trustResult {
            case .recoverableTrustFailure:
                
                // Safariのような認証書のエラーが出た時にアラートを出してそれでも信頼して接続する場合は続けるをタップしてください -> タップされたら強制的に接続のような実装はここで行う。
                return
                
            case .fatalTrustFailure:
                completionHandler(.rejectProtectionSpace, nil)
                return
                
            case .invalid:
                completionHandler(.rejectProtectionSpace, nil)
                return
                
            case .proceed:
                break
                
            case .deny:
                completionHandler(.rejectProtectionSpace, nil)
                return
                
            case .unspecified:
                break
                
            default:
                break
            }
            
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic
                    || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPDigest
                    || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodDefault
                    || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNegotiate
                    || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM {
            
            // Basic認証等の対応
            let alert = UIAlertController(
                title: "認証が必要です",
                message: "ユーザー名とパスワードを入力してください",
                preferredStyle: .alert
            )
            
            alert.addTextField { textField in
                
                textField.placeholder = "user name"
                textField.tag = 1
            }
            
            alert.addTextField { textField in
                
                textField.placeholder = "password"
                textField.isSecureTextEntry = true
                textField.tag = 2
            }
            
            let okAction = UIAlertAction(title: "ログイン", style: .default) { _ in
                
                var user = ""
                var password = ""
                
                if let textFields = alert.textFields {
                    for textField in textFields {
                        if textField.tag == 1 {
                            user = textField.text ?? ""
                        } else if textField.tag == 2 {
                            password = textField.text ?? ""
                        }
                    }
                }
                
                let credential = URLCredential(user: user, password: password, persistence: URLCredential.Persistence.forSession)
                completionHandler(.useCredential, credential)
            }
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { _ in
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
            
            return
        }
        
        completionHandler(.performDefaultHandling, nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.backButton.isEnabled = webView.canGoBack
            self.backButton.alpha = webView.canGoBack ? 1.0 : 0.4
            self.forwardButton.isEnabled = webView.canGoForward
            self.forwardButton.alpha = webView.canGoForward ? 1.0 : 0.4
        }
    }
}
