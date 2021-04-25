//
//  GCProgressViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/02/03.
//

import UIKit
import GoogleMobileAds
import GradientCircularProgress

class GCProgressViewController: BaseModalViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressSpaceView: UIView!
    @IBOutlet weak var adBannerView: GADBannerView!
    
    private let message: String?
    private let isDisplayAd: Bool
    private let completion: () -> Void
    
    init(titleText: String? = nil, message: String? = nil, isDisplayAd: Bool, completion: @escaping () -> Void) {
        
        self.message = message
        self.isDisplayAd = isDisplayAd
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil, isCloseBackgroundTouch: false)
        
        guard isDisplayAd else { return }
        
        #if DEBUG || ORIGINAL || DEVELOP
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "66b0f5a761a31fddb448877f49d2eb5d" ]
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // プログレスビュー
        let gcp = GradientCircularProgress()
        let gcpView = gcp.show(frame: progressSpaceView.bounds, message: message ?? "", style: OfficialStyle())!
        progressSpaceView.addSubview(gcpView)
        
        adBannerView.isHidden = !isDisplayAd
        
        if isDisplayAd {
            
            adBannerView.rootViewController = self
            
            adBannerView.load(GADRequest())
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        dismiss(animated: true)
        
        completion()
    }
}

// MARK: - GADBannerViewDelegate
extension GCProgressViewController: GADBannerViewDelegate {
}
