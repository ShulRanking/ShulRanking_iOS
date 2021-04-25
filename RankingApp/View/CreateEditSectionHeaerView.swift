//
//  CreateEditSectionHeaerView.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2021/01/17.
//

import UIKit
import Photos
import PhotosUI
import CropViewController

class CreateEditSectionHeaerView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageRatio43Constraint: NSLayoutConstraint!
    @IBOutlet weak var imageRatio11Constraint: NSLayoutConstraint!
    
    private var mainImage: UIImage?
    
    weak var delegate: CreateEditTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // mainImageViewタップ時のアクションを設定する
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setData(rankingViewModel: RankingViewModel) {
        
        // セルの各値をセットする
        titleTextField.text = rankingViewModel.mainTitle
        mainImageView.setImageViewRect(targetImage: rankingViewModel.mainImage, rect: rankingViewModel.mainImageRect)
        
        emptyImageView.isHidden = rankingViewModel.mainImage != nil
        
        // 画像比率を設定
        switch rankingViewModel.imageRatioType {
        case .ratio4to3:
            imageRatio43Constraint.isActive = true
            imageRatio11Constraint.isActive = false

        case .ratio1to1:
            imageRatio43Constraint.isActive = false
            imageRatio11Constraint.isActive = true
        }
        
        mainImage = rankingViewModel.mainImage
    }
    
    /// imageViewの入力終わったら呼ばれる
    private func imageDidEndEditing(image: UIImage?, cropRect: CGRect?) {
        
        delegate?.imageDidEndEditing(cell: nil, image: image, cropRect: cropRect)
    }
    
    /// imageViewタップ時
    @objc func imageViewTapped() {
        
        delegate?.imageTapped(albumCropDelegate: self, titleText: titleTextField.text!, cell: nil, imageViewSize: mainImageView.frame.size)
    }
}

// MARK: - UITextFieldDelegate
extension CreateEditSectionHeaerView: UITextFieldDelegate {
    
    /// TextFieldの入力終了
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        delegate?.textFieldDidEndEditing(cell: nil, text: textField.text!)
    }
    
    /// クリアボタンタップ
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        delegate?.textFieldDidEndEditing(cell: nil, text: "")
        
        return true
    }
    
    /// TextFieldでの編集終了
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        true
    }
    
    /// 改行ボタンタップ
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // キーボードを隠す
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - CropViewControllerDelegate
extension CreateEditSectionHeaerView: CropViewControllerDelegate {
    
    /// 画像を切り取った範囲を取得
    func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        
        cropViewController.dismiss(animated: true)
        
        imageDidEndEditing(image: mainImage, cropRect: rect)
    }
    
    /// キャンセル時
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        
        cropViewController.dismiss(animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreateEditSectionHeaerView: UIImagePickerControllerDelegate {
    
    /// アルバムの画像を受け取る
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        imageDidEndEditing(image: image, cropRect: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension CreateEditSectionHeaerView: UINavigationControllerDelegate {
    // UIImagePickerControllerの利用にUINavigationControllerDelegateの批准が必要
}

// MARK: - PHPickerViewControllerDelegate
@available(iOS 14, *)
extension CreateEditSectionHeaerView: PHPickerViewControllerDelegate {
    
    /// アルバムの画像を受け取る
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty {
            
            picker.dismiss(animated: true)
            
            return
        }
        
        // PHPickerResultからImageを読み込む
        results[0].itemProvider.loadObject(ofClass: UIImage.self) { [weak self] selectedImage, error in
            
            guard let self = self else { return }
            
            // UIImageに変換
            guard let wrapImage = selectedImage as? UIImage else { return }
            
            DispatchQueue.main.async {
                
                picker.dismiss(animated: true)
                
                self.imageDidEndEditing(image: wrapImage, cropRect: nil)
            }
        }
    }
}

