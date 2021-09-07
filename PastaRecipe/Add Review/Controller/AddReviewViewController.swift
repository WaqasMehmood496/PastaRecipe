//
//  AddReviewViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 30/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import Cosmos

class AddReviewViewController: UIViewController {
    
    @IBOutlet weak var RatingView: CosmosView!
    @IBOutlet weak var CommentTextView: UITextView!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var TitleField: UITextField!
    
    var delegate:ViewRecipeDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaddingOnFields()
        if let user = CommonHelper.getCachedUserData() {
            self.NameField.text = user.user_detail.user_name
            self.EmailField.text = user.user_detail.user_email
        }
    }
    
    @IBAction func AddReviewBtnAction(_ sender: Any) {
        delegate?.myReview(review: self.CommentTextView.text!, title: self.TitleField.text!, name: self.NameField.text!, email: self.EmailField.text!, rating: String(RatingView.rating))
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:- Helping Method's
extension AddReviewViewController {
    func setupPaddingOnFields() {
        self.NameField.setLeftPaddingPoints(4)
        self.EmailField.setLeftPaddingPoints(4)
        self.TitleField.setLeftPaddingPoints(4)
        self.NameField.setRightPaddingPoints(4)
        self.EmailField.setRightPaddingPoints(4)
        self.TitleField.setRightPaddingPoints(4)
    }
}
