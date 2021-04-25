//
//  PremiumSearchImageAPIViewPresenter.swift
//  ShulRanking
//
//  Created by 佐々木英彦 on 2021/02/20.
//

import UIKit

class PremiumSearchImageAPIViewPresenter: PremiumSearchImageAPIViewPresenterProtocol {
    
    private weak var view: PremiumSearchImageAPIViewProtocol?
    private let model: PremiumSearchImageAPIModel
    
    private let imageRatioType: ImageRatioType
    private let completion: (UIImage) -> Void
    
    private var searchText: String
    
    private var isFit: Bool = false
    
    /// 画像を格納する配列
    private var imageList: [UIImage] = []
    
    init(view: PremiumSearchImageAPIViewProtocol,
         searchText: String,
         imageRatioType: ImageRatioType,
         isCloseBackgroundTouch: Bool,
         completion: @escaping (UIImage) -> Void) {
        
        self.view = view
        self.searchText = searchText
        self.imageRatioType = imageRatioType
        self.completion = completion
        
        model = PremiumSearchImageAPIModel()
        model.delegate = self
    }
    
    func viewDidLoad() {
        
        view?.setSearchWord(word: searchText)
        
        model.searchImage(searchText: searchText, isMore: false)
    }
    
    func getImageRatioType() -> ImageRatioType {
        imageRatioType
    }
    
    func getImageList() -> [UIImage] {
        imageList
    }
    
    func getIsFit() -> Bool {
        isFit
    }
    
    func textFieldReturnTapped(searchWord: String) {
        
        searchText = searchWord
        
        model.searchImage(searchText: searchText, isMore: false)
        
        view?.hideKeyboard()
    }
    
    func itemSelected(index: Int) {
        
        // 値の設定
        completion(imageList[index])
        
        view?.dismissSelfVC(completion: nil)
    }
    
    func scrollViewWillBeginDragging() {
        
        view?.hideKeyboard()
    }
    
    func fitTapped() {
        
        isFit.toggle()
        
        guard let image = isFit ? UIImage(named: "expansion") : UIImage(named: "reduction") else { return }
        
        view?.setFitFillButtonImage(image: image)
        
        view?.reloadCollectionView()
    }
    
    func searchTapped() {
        
        model.searchImage(searchText: searchText, isMore: false)
    }
    
    func suarchMoreTapped() {
        
        model.searchImage(searchText: searchText, isMore: true)
    }
}

// MARK: - PremiumSearchImageAPIModelProtocol
extension PremiumSearchImageAPIViewPresenter: PremiumSearchImageAPIModelProtocol {
    
    func impossibleSearhForCount() {
        
        // エラー表示
        let alertVC = OriginalAlertViewController(
            descriptionText: "検索利用可能回数を超えています",
            isCloseBackgroundTouch: true)
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.view?.presentVC(nextVC: alertVC) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
                    alertVC.dismiss(animated: true)
                }
            }
        }
    }
    
    func responseErrorOccurred(error: Error?) {
        
        // 利用不可能アラート表示
        let alertVC = OriginalAlertViewController(
            descriptionText: error?.localizedDescription ?? "エラーが発生しました。",
            isCloseBackgroundTouch: true)
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.view?.presentVC(nextVC: alertVC) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
                    alertVC.dismiss(animated: true)
                }
            }
        }
    }
    
    func imageSearchedResult(imageList: [UIImage]) {
        
        self.imageList = imageList
        
        view?.reloadCollectionView()
    }
    
    func decreaseSearchable(count: Int) {
        
        view?.setDecreaseImageSearchRemainingCount(text: String(count))
    }
}

