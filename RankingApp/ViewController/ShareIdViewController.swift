//
//  ShareIdViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/12/09.
//

import UIKit
import GradientCircularProgress

class ShareIdViewController: BaseModalViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var popupView: UIView!
    
    private let completion: (Bool) -> Void
    
    private var cancelIdShare: Bool = false
    
    init(completion: @escaping (Bool) -> Void) {
        
        self.completion = completion
        
        super.init(nibName: "ShareIdViewController", bundle: nil, isCloseBackgroundTouch: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.becomeFirstResponder()
        
        idTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneTapped))
        
        LogUtil.logAnalytics(logName: "ShareVC")
    }
    
    private func getSharedRanking() {
        
        if let idText = idTextField.text, !idText.isEmpty {
            
            // プログレスビュー
            let gcpVC = GCProgressViewController(message: "ダウンロード中", isDisplayAd: false) { [weak self] in
                
                self?.cancelIdShare = true
            }
            
            DispatchQueue.main.async { [weak self] in
                
                // プログレスビュー表示
                self?.present(gcpVC, animated: true)
            }
            
            FirebaseFirestoreUtil.shared.getSharedRanking(id: idText) { [weak self] isSuccess in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    
                    // プログレスビュー表示終了
                    gcpVC.dismiss(animated: true)
                    
                    self.dismiss(animated: true) {
                        
                        // 500m秒待った後に実行
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            // 途中でキャンセルされていた場合
                            if self.cancelIdShare {
                                
                                self.cancelIdShare = false
                                
                                return
                            }
                            
                            self.completion(isSuccess)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        
        idTextField.resignFirstResponder()
        
        getSharedRanking()
    }
}

// MARK: - UITextFieldDelegate
extension ShareIdViewController: UITextFieldDelegate {
    
    /// キーボード完了ボタンタップ
    @objc func doneTapped(_ sender: Any) {
        
        getSharedRanking()
    }
}
