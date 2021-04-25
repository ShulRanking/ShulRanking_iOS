//
//  CreateEditTableViewCellDelegate.swift
//  RankingApp
//
//  Created by 佐々木英彦 on 2020/07/12.
//  Copyright © 2020 Akihiko Sasaki. All rights reserved.
//

import UIKit

protocol CreateEditTableViewCellDelegate: class {
    
    func textFieldDidEndEditing(cell: BaseEditTableViewCell?, text: String)
    func descriptionTextViewDidEndEditing(cell: BaseEditTableViewCell, text: String)
    func imageDidEndEditing(cell: BaseEditTableViewCell?, image: UIImage?, cropRect: CGRect?)
    func deleteButtonTapped(cell: BaseEditTableViewCell)
    func displayItemMenu(menuVC: MenuDialogViewController)
    func imageTapped(albumCropDelegate: Any, titleText: String, cell: BaseEditTableViewCell?, imageViewSize: CGSize)
}
