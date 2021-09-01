//
//  AddReviewViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 30/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class AddReviewViewController: UIViewController {
    
    @IBOutlet weak var CommentTextView: UITextView!
    
    var delegate:ViewRecipeDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func AddReviewBtnAction(_ sender: Any) {
        delegate?.myReview(review: CommentTextView.text!)
        self.dismiss(animated: true, completion: nil)
    }
}
