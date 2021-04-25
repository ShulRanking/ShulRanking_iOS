//
//  UIView+.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/12.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

extension UIView {
    
    /// addSubview後に上下左右の端が一致するconstraintsを付与
    func addSubviewWithSameFrameConstraints(_ view: UIView) {
        
        addSubview(view)
        addSameFrameConstraints(view)
    }
    
    /// 上下左右の端が一致するようconstraintsを付与
    func addSameFrameConstraints(_ subview: UIView) {
        
        if !contains(view: subview) {
            
            fatalError("Cannot add constraints to views not in same view hierarchy.")
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        let top = subview.topAnchor.constraint(equalTo: topAnchor)
        let bottom = subview.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = subview.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = subview.trailingAnchor.constraint(equalTo: trailingAnchor)
        let width = subview.widthAnchor.constraint(equalTo: widthAnchor)
        let height = subview.heightAnchor.constraint(equalTo: heightAnchor)
        addConstraints([top, bottom, leading, trailing, width, height])
    }
    
    /// 渡したviewが自身のsubViewか、全ての階層を調べる
    func contains(view subview: UIView) -> Bool {
        
        subview.contained(by: self)
    }
    
    /// 渡したviewが自身のsuperViewか、全ての階層を調べる
    func contained(by view: UIView) -> Bool {
        
        var superview: UIView? = self.superview
        
        // 再帰的に確認
        while nil != superview {
            
            if view == superview {
                
                return true
            }
            
            superview = superview!.superview
        }
        
        return false
    }
}
