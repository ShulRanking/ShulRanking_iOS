//
//  BaseEditTableViewCell.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/11.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import CropViewController

/// 作成編集画面で利用するセルのbase
class BaseEditTableViewCell: UITableViewCell {
    
    private var basetitleTextField: UITextField!
    private var baseDescriptionTextView: UITextView!
    private var baseDescriptionPlaceHolderLabel: UILabel!
    private var baseImageView: UIImageView!
    private var baseCellImage: UIImage?
    private var baseImageRatioType: ImageRatioType!
    
    weak var baseCreateEditCellDelegate: CreateEditTableViewCellDelegate?
    
    func setBase(titleTextField: UITextField,
                 descriptionTextView: UITextView,
                 descriptionPlaceHolderLabel: UILabel,
                 cellImageView: UIImageView,
                 cellImage: UIImage? = nil,
                 imageRatioType: ImageRatioType) {
        
        basetitleTextField = titleTextField
        baseDescriptionTextView = descriptionTextView
        baseDescriptionPlaceHolderLabel = descriptionPlaceHolderLabel
        baseCellImage = cellImage
        baseImageView = cellImageView
        baseImageRatioType = imageRatioType
        
        // コメント入力欄の初期設定
        initDescriptionTextView()
        
        basetitleTextField.delegate = self
        
        // cellImageタップ時のアクションを設定する
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        baseImageView.isUserInteractionEnabled = true
        baseImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// 順位削除ボタンタップ
    func deleteTapped() {
        
        baseCreateEditCellDelegate?.deleteButtonTapped(cell: self)
    }
    
    /// コメント入力欄のTextViewを初期化
    private func initDescriptionTextView() {
        
        baseDescriptionTextView.delegate = self
        
        // コメント欄の文字の有無でプレースホルダーの表示を設定
        baseDescriptionPlaceHolderLabel.isHidden = !baseDescriptionTextView.text.isEmpty
        
        // 枠のカラー
        baseDescriptionTextView.layer.borderColor = UIColor.darkGray.cgColor
        // 枠の幅
        baseDescriptionTextView.layer.borderWidth = 0.2
        // 枠を角丸にする
        baseDescriptionTextView.layer.cornerRadius = 5.0
        baseDescriptionTextView.layer.masksToBounds = true
    }
    
    /// imageView入力完了
    private func imageDidEndEditing(image: UIImage?, cropRect: CGRect?) {
        
        baseCreateEditCellDelegate?.imageDidEndEditing(cell: self, image: image, cropRect: cropRect)
    }
    
    /// imageViewタップ
    @objc func imageViewTapped() {
        
        baseCreateEditCellDelegate?.imageTapped(albumCropDelegate: self, titleText: basetitleTextField.text!, cell: self, imageViewSize: baseImageView.frame.size)
    }
}

// MARK: - UITextFieldDelegate
extension BaseEditTableViewCell: UITextFieldDelegate {
    
    /// TextFieldの入力終了
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        baseCreateEditCellDelegate?.textFieldDidEndEditing(cell: self, text: textField.text!)
    }
    
    /// クリアボタンタップ
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        baseCreateEditCellDelegate?.textFieldDidEndEditing(cell: self, text: "")
        
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

// MARK: - UITextViewDelegate
extension BaseEditTableViewCell: UITextViewDelegate {
    
    /// TextView入力完了
    func textViewDidChange(_ textView: UITextView) {
        // プレースホルダーを非表示にする
        baseDescriptionPlaceHolderLabel.isHidden = true
        
        baseCreateEditCellDelegate?.descriptionTextViewDidEndEditing(cell: self, text: textView.text!)
    }
    
    /// リターンタップ
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        true
    }
    
    /// textviewからフォーカスが外れた
    func textViewDidEndEditing(_ textView: UITextView) {
        
        // TextViewが空の場合
        if textView.text.isEmpty {
            
            // プレースホルダーを再び表示
            baseDescriptionPlaceHolderLabel.isHidden = false
        }
    }
}

// MARK: - CropViewControllerDelegate
extension BaseEditTableViewCell: CropViewControllerDelegate {
    
    /// 画像を切り取った範囲を取得
    func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        
        cropViewController.dismiss(animated: true)
        
        imageDidEndEditing(image: baseCellImage, cropRect: rect)
    }
    
    /// キャンセル時
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        
        cropViewController.dismiss(animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension BaseEditTableViewCell: UIImagePickerControllerDelegate {
    
    /// アルバムの画像を受け取る
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        imageDidEndEditing(image: image, cropRect: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension BaseEditTableViewCell: UINavigationControllerDelegate {
    // UIImagePickerControllerの利用にUINavigationControllerDelegateの批准が必要
}

// MARK: - PHPickerViewControllerDelegate
@available(iOS 14, *)
extension BaseEditTableViewCell: PHPickerViewControllerDelegate {
    
    /// アルバムの画像を受け取る
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // 選択した画像がない場合
        if results.isEmpty {
            
            picker.dismiss(animated: true)
            
            return
        }
        
        // PHPickerResultからImageを読み込む
        results[0].itemProvider.loadObject(ofClass: UIImage.self) { selectedImage, error in
            
            // UIImageに変換
            guard let wrapImage = selectedImage as? UIImage else { return }
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                picker.dismiss(animated: true)
                
                self.imageDidEndEditing(image: wrapImage, cropRect: nil)
            }
        }
    }
}
