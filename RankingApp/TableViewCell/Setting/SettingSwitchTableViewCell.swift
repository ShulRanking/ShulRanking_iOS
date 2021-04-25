//
//  SettingSwitchTableViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2019/09/16.
//  Copyright © 2019 Akihiko Sasaki. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingSwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nintendoSwitch: UISwitch!
    
    weak var delegate: SettingSwitchTableViewCellDelegate?
    
    func setData(index: Int, text: String, image: UIImage) {
        
        leftImageView.image = image
        titleLabel.text = text
        nintendoSwitch.tag = index
        
        switch index {
            case 0:
                nintendoSwitch.setOn(Constants.USER_DEFAULTS_STANDARD.bool(forKey: Constants.IS_LOCK), animated: false)
                
            case 1:
                nintendoSwitch.setOn(Constants.USER_DEFAULTS_STANDARD.bool(forKey: Constants.DISPLAY_DIALOG), animated: false)
                
            default:
                break
        }
    }
        
    @IBAction func tappedSwitch(_ sender: UISwitch) {
        
        switch sender.tag {
            case 0:
                if sender.isOn {
                    
                    Constants.USER_DEFAULTS_STANDARD.set(sender.isOn, forKey: Constants.IS_LOCK)
                    
                } else {
                    
                    let context = LAContext()
                    
                    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                        
                        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "ロックしているランキングの表示") { [weak self] success, error in
                            
                            guard let self = self else { return }
                            
                            if let error = error {
                                
                                switch LAError(_nsError: error as NSError) {
                                case LAError.userCancel,
                                     LAError.userFallback,
                                     LAError.authenticationFailed,
                                     LAError.passcodeNotSet,
                                     LAError.systemCancel:
                                    
                                    
                                    // キャンセル
                                    DispatchQueue.main.async {
                                        
                                        self.nintendoSwitch.setOn(true, animated: true)
                                    }
                                    
                                default:
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.nintendoSwitch.setOn(true, animated: true)
                                    }
                                }
                                
                            } else if success {
                                
                                DispatchQueue.main.async {
                                    
                                    Constants.USER_DEFAULTS_STANDARD.set(sender.isOn, forKey: Constants.IS_LOCK)
                                }
                            }
//                            else {
//                                DispatchQueue.main.async {
//                                    self.nintendoSwitch.setOn(true, animated: true)
//                                }
//                            }
                        }
                        
                    } else {
                        
                        delegate?.policyErrorOccurred()
                        
                        // 0.5秒待った後にメインスレッドで実行
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            self.nintendoSwitch.setOn(true, animated: true)
                        }
                    }
                }

                DataBaseManager.shared.isNeedFech = true
                
                LogUtil.logAnalytics(logName: "SetVC_Lock")
            
            case 1:
                
                Constants.USER_DEFAULTS_STANDARD.set(sender.isOn, forKey: Constants.DISPLAY_DIALOG)
                
                LogUtil.logAnalytics(logName: "SetVC_DisplayDialog")
            
            default:
                break
        }
    }
}

protocol SettingSwitchTableViewCellDelegate: class {
    
    func policyErrorOccurred()
}
