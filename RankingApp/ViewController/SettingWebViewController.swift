//
//  SettingWebViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/11/18.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit
import WebKit

class SettingWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    private let navigationBarTitle: String
    private let url: String
    
    init(url: String, navigationBarTitle: String) {
        
        self.url = url
        self.navigationBarTitle = navigationBarTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = WKWebViewConfiguration()
        webView.uiDelegate = self
        
        guard let url = URL(string: url) else { fatalError() }
        let request = URLRequest(url: url)
        webView.load(request)

        navigationItem.title = navigationBarTitle
    }
}

// MARK: - WKUIDelegate
extension SettingWebViewController: WKUIDelegate {
}
