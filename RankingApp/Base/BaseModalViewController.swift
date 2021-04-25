//
//  BaseModalViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/04.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

/// モーダル表示する画面のbase
class BaseModalViewController: UIViewController {
    
    /// コンテンツを表示する部分の親view
    var targetPopupView: UIView?
    /// コンテンツ外のタッチで画面を閉じるか
    private let isCloseBackgroundTouch: Bool
    
    /// コンテンツ外のタッチで画面を閉じる際、VCの大元のviewのtagに設定する値
    private let viewTag: Int = -1
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, isCloseBackgroundTouch: Bool) {
        
        self.isCloseBackgroundTouch = isCloseBackgroundTouch
        
        super.init(nibName: nibNameOrNil, bundle: nil)
        
        transitioningDelegate = self
        
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // コンテンツ外タッチで画面を閉じる場合
        if isCloseBackgroundTouch {
            
            view.tag = viewTag
        }
    }
    
    /// VC表示時にアニメーションが必要な場合modalViewを設定する
    func setPopupViewForAnimation(modalView: UIView) {
        
        targetPopupView = modalView
    }
    
    /// モーダルビューをタッチした場合
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            
            if touch.view?.tag == viewTag {
                
                dismiss(animated: true)
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension BaseModalViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AlertAnimation(isShow: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AlertAnimation(isShow: false)
    }
}

class AlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// true: 表示時, false: 非表示時
    let isShow: Bool
    
    /// 初期化
    /// - Parameter isShow: true: 表示時, false: 非表示時
    init(isShow: Bool) {
        
        self.isShow = isShow
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        if isShow {
            
            return 0.25
            
        } else {
            
            return 0.35
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isShow {
            
            presentAnimateTransition(transitionContext: transitionContext)
            
        } else {
            
            dismissAnimateTransition(transitionContext: transitionContext)
        }
    }
    
    private func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let modalVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? BaseModalViewController else { return }
        
        modalVC.view.frame = UIScreen.main.bounds
        let containerView = transitionContext.containerView
        modalVC.targetPopupView?.alpha = 0.0
        modalVC.targetPopupView?.center = modalVC.view.center
        modalVC.targetPopupView?.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        containerView.addSubview(modalVC.view)
        
        UIView.animate(
            withDuration: 0.25,
            animations: {
                
                modalVC.view.alpha = 1.0
                modalVC.targetPopupView?.alpha = 1.0
                modalVC.targetPopupView?.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
            },
            completion: { finished in
                
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        
                        modalVC.targetPopupView?.transform = CGAffineTransform.identity
                    },
                    completion: { finished in
                        
                        if finished {
                            
                            transitionContext.completeTransition(true)
                        }
                    })
            })
    }
    
    private func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let alertVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? BaseModalViewController else { return }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                
                alertVC.view.alpha = 0.0
                alertVC.targetPopupView?.alpha = 0.0
                alertVC.targetPopupView?.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            },
            completion: { finished in
                
                transitionContext.completeTransition(true)
            })
    }
}
