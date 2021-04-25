//
//  BaseTabPageViewController.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/10/20.
//

import UIKit

class BaseTabPageViewController: UIPageViewController {
    
    var pageDelegate: PageViewControllerDelegate?
    var pageViewControllers: [UIViewController] = []
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
    }
    
    /// 前後のViewControllerを読み込む
    func nextViewController(viewController: UIViewController, isAfter: Bool) -> UIViewController? {
       
       guard var index = pageViewControllers.firstIndex(of: viewController) else { return nil }
       
       index = isAfter ? index + 1 : index - 1
       
       // 無限ループさせる
       if index < 0 {
        
           index = pageViewControllers.count - 1
        
       } else if index == pageViewControllers.count {
        
           index = 0
       }
       
       if index >= 0 && index < pageViewControllers.count {
        
           return pageViewControllers[index]
       }
       
       return nil
   }
}

// MARK: - UIPageViewControllerDataSource
extension BaseTabPageViewController: UIPageViewControllerDataSource {

    /// 右にスワイプ(戻る)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewControllers![0] == viewController {
            
            pageDelegate?.pageChanged(isAfter: false)
        }
        
        return nextViewController(viewController: viewController, isAfter: false)
    }

    /// 左にスワイプ(進む)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewControllers![0] == viewController {
            
            pageDelegate?.pageChanged(isAfter: true)
        }
        
        return nextViewController(viewController: viewController, isAfter: true)
    }
}

// MARK: - UIPageViewControllerDelegate
extension BaseTabPageViewController: UIPageViewControllerDelegate {
}
