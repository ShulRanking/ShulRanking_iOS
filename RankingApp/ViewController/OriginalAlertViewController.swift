//
//  OriginalAlertViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/07.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

class OriginalAlertViewController: BaseModalViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    private let titleText: String?
    private let descriptionText: String
    private let negativeButtonText: String?
    private let positiveButtonText: String?
    private let neutralButtonText: String?
    private let callback: ((AlertButtonType) -> Void)?
    
    init(titleText: String? = nil,
         descriptionText: String,
         negativeButtonText: String? = nil,
         neutralButtonText: String? = nil,
         positiveButtonText: String? = nil,
         isCloseBackgroundTouch: Bool,
         callback: ((AlertButtonType) -> Void)? = nil) {
        
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.negativeButtonText = negativeButtonText
        self.positiveButtonText = positiveButtonText
        self.neutralButtonText = neutralButtonText
        self.callback = callback
        
        super.init(nibName: "OriginalAlertViewController", bundle: nil, isCloseBackgroundTouch: isCloseBackgroundTouch)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setPopupViewForAnimation(modalView: popupView)
        
        descriptionTextView.text = descriptionText
        
        if let titleText = titleText {
            titleLabel.text = titleText
        } else {
            titleLabel.isHidden = true
        }
        
        if let negativeButtonText = negativeButtonText {
            negativeButton.titleLabel?.adjustsFontSizeToFitWidth = true
            negativeButton.setTitle(negativeButtonText, for: .normal)
        } else {
            negativeButton.isHidden = true
        }
        
        if let neutralButtonText = neutralButtonText {
            neutralButton.titleLabel?.adjustsFontSizeToFitWidth = true
            neutralButton.setTitle(neutralButtonText, for: .normal)
        } else {
            neutralButton.isHidden = true
        }
        
        if let positiveButtonText = positiveButtonText {
            positiveButton.titleLabel?.adjustsFontSizeToFitWidth = true
            positiveButton.setTitle(positiveButtonText, for: .normal)
        } else {
            positiveButton.isHidden = true
        }
        
        buttonsStackView.isHidden = negativeButton.isHidden && positiveButton.isHidden && neutralButton.isHidden
    }
    
    @IBAction func negativeButtonTapped(_ sender: UIButton) {
        
        callback?(.negative)
        dismiss(animated: true)
    }
    
    @IBAction func neutralButtonTapped(_ sender: UIButton) {
        
        callback?(.neutral)
        dismiss(animated: true)
    }
    
    @IBAction func positiveButtonTapped(_ sender: UIButton) {
        
        callback?(.positive)
        dismiss(animated: true)
    }
}
