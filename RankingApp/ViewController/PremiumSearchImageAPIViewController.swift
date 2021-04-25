//
//  PremiumSearchImageAPIViewController.swift
//  ShulRanking
//
//  Created by 佐々木英彦 on 2021/02/20.
//

import UIKit

class PremiumSearchImageAPIViewController: BaseModalViewController {
    
    @IBOutlet weak var fitFillButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var imageSearchRemainingCountLabel: UILabel!
    
    private var presenter: PremiumSearchImageAPIViewPresenterProtocol!
    
    private var imageRatioType: ImageRatioType {
        presenter.getImageRatioType()
    }
    
    private var isFit: Bool {
        presenter.getIsFit()
    }
    
    /// 画像を格納する配列
    private var imageList: [UIImage] {
        presenter.getImageList()
    }
    
    init(searchText: String,
         imageRatioType: ImageRatioType,
         isCloseBackgroundTouch: Bool,
         completion: @escaping (UIImage) -> Void) {
        
        super.init(nibName: "SearchImageAPIViewController", bundle: nil, isCloseBackgroundTouch: isCloseBackgroundTouch)
        
        presenter = PremiumSearchImageAPIViewPresenter(
            view: self,
            searchText: searchText,
            imageRatioType: imageRatioType,
            isCloseBackgroundTouch: isCloseBackgroundTouch,
            completion: completion)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.register(cellType: GoogleSearchImageAPICollectionViewCell.self)
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageCollectionView.flashScrollIndicators()
    }
    
    @IBAction func fitTapped(_ sender: UIButton) {
        
        presenter.fitTapped()
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        
        // キーボードを隠す
        searchTextField.resignFirstResponder()
        
        presenter.searchTapped()
    }
    
    @IBAction func suarchMoreTapped(_ sender: UIButton) {
        
        presenter.suarchMoreTapped()
    }
}

// MARK: - UITextFieldDelegate
extension PremiumSearchImageAPIViewController: UITextFieldDelegate {
    
    /// リターンボタンタップ
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        presenter.textFieldReturnTapped(searchWord: textField.text!)
        
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension PremiumSearchImageAPIViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(with: GoogleSearchImageAPICollectionViewCell.self, for: indexPath)
        
        cell.setData(imageView: imageList[indexPath.row], isFit: isFit)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PremiumSearchImageAPIViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presenter.itemSelected(index: indexPath.item)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        presenter.scrollViewWillBeginDragging()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PremiumSearchImageAPIViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellCgsize: CGSize
        
        switch imageRatioType {
        case .ratio4to3:
            let space: CGFloat = 1
            let cellWidth: CGFloat = collectionView.bounds.width / 2 - space
            cellCgsize = CGSize(width: cellWidth, height: cellWidth / 4 * 3)
            
        case .ratio1to1:
            let space: CGFloat = 1
            let cellWidthHeight: CGFloat = collectionView.bounds.width / 2 - space
            cellCgsize = CGSize(width: cellWidthHeight, height: cellWidthHeight)
        }
        
        return cellCgsize
    }
}

// MARK: - PremiumSearchImageAPIViewProtocol
extension PremiumSearchImageAPIViewController: PremiumSearchImageAPIViewProtocol {
    
    func presentVC(nextVC: UIViewController, completion: (() -> Void)?) {
        
        present(nextVC, animated: true) {
            
            completion?()
        }
    }
    
    func dismissSelfVC(completion: (() -> Void)?) {
        
        dismiss(animated: true, completion: completion)
    }
    
    func hideKeyboard() {
        
        // キーボードを隠す
        searchTextField.resignFirstResponder()
    }
    
    func reloadCollectionView() {
        
        imageCollectionView.reloadData()
    }
    
    func setSearchWord(word: String) {
        
        searchTextField.text = word
    }
    
    func setFitFillButtonImage(image: UIImage) {
        
        fitFillButton.setImage(image, for: .normal)
    }
    
    func setDecreaseImageSearchRemainingCount(text: String) {
        
        imageSearchRemainingCountLabel.text = text + "回"
    }
}

