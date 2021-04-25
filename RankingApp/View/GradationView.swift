//
//  GradationView.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/11/27.
//

import UIKit

class GradationView: UIView {
    
    @IBInspectable var topColor: UIColor?
    @IBInspectable var bottomColor: UIColor?
    
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    func setGradation() {
        
        guard let gradientLayer = layer as? CAGradientLayer,
              let topColor = topColor,
              let bottomColor = bottomColor else { return }
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
