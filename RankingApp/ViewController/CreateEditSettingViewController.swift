//
//  CreateEditSettingViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/02/14.
//

import UIKit

class CreateEditSettingViewController: BaseModalViewController {
    
    @IBOutlet weak var imageRatioTypeSegmentdeControl: UISegmentedControl!
    
    private var imageRatioType: ImageRatioType
    private let completion: (ImageRatioType) -> Void
    
    init(imageRatioType: ImageRatioType, completion: @escaping (ImageRatioType) -> Void) {
        
        self.completion = completion
        self.imageRatioType = imageRatioType
        
        super.init(nibName: "CreateEditSettingViewController", bundle: nil, isCloseBackgroundTouch: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageRatioTypeSegmentdeControl.selectedSegmentIndex = imageRatioType.getIndex()
        
        LogUtil.logAnalytics(logName: "CreateEditSettingVC")
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        
        imageRatioType = ImageRatioType.getEnumBy(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func positiveTapped(_ sender: UIButton) {
        
        completion(imageRatioType)
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
}
