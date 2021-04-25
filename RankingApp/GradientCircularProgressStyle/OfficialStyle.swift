//
//  OfficialStyle.swift
//  GradientCircularProgress
//
//  Created by 佐々木英彦 on 2020/12/15.
//

import UIKit
import GradientCircularProgress

@available(iOS 11.0, *)
/// GradientCircularProgress(インジケータ)のスタイル
public struct OfficialStyle: StyleProperty {
    
    /// Progress Size
    public var progressSize: CGFloat = 80
    
    /// Gradient Circular
    public var arcLineWidth: CGFloat = 6.0
    public var startArcColor: UIColor = UIColor.clear
    public var endArcColor: UIColor = UIColor.orange
    
    /// Base Circular
    public var baseLineWidth: CGFloat?
    public var baseArcColor: UIColor?
    
    /// Ratio
    public var ratioLabelFont: UIFont? = UIFont.systemFont(ofSize: 13.0)
    public var ratioLabelFontColor: UIColor? = UIColor(named: "DarkGrayCustomColor")!
    
    /// Message
    public var messageLabelFont: UIFont? = UIFont.systemFont(ofSize: 9.0)
    public var messageLabelFontColor: UIColor? = UIColor(named: "DarkGrayCustomColor")!
    
    /// Background
    public var backgroundStyle: BackgroundStyles = .transparent
    
    /// Dismiss
    public var dismissTimeInterval: Double? = nil // 'nil' for default setting.
    
    public init() {}
}
