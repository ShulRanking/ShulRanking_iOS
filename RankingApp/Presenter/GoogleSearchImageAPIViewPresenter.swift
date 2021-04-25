//
//  GoogleSearchImageAPIViewPresenter.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/21.
//

import UIKit

class GoogleSearchImageAPIViewPresenter: GoogleSearchImageAPIViewPresenterProtocol {
    
    private weak var view: GoogleSearchImageAPIViewProtocol?
    private let model: GoogleSearchImageAPIModel
    
    private let imageRatioType: ImageRatioType
    private let completion: (UIImage) -> Void
    
    private var searchText: String
    
    private var isFit: Bool = false
    
    /// 画像を格納する配列
    private var imageList: [UIImage] = []
    
    init(view: GoogleSearchImageAPIViewProtocol,
         searchText: String,
         imageRatioType: ImageRatioType,
         isCloseBackgroundTouch: Bool,
         completion: @escaping (UIImage) -> Void) {
        
        self.view = view
        self.searchText = searchText
        self.imageRatioType = imageRatioType
        self.completion = completion
        
        model = GoogleSearchImageAPIModel()
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

// MARK: - GoogleSearchImageAPIModelProtocol
extension GoogleSearchImageAPIViewPresenter: GoogleSearchImageAPIModelProtocol {
    
    func responseErrorOccurred(error: Error?) {
        
        // エラー表示
        let alertVC = OriginalAlertViewController(
            descriptionText: error?.localizedDescription ?? "エラーが発生しました。",
            isCloseBackgroundTouch: true)
        
        DispatchQueue.main.sync {
            
            view?.presentVC(nextVC: alertVC) {
                
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
}
