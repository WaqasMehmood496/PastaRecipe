//
//  UserDetailTableViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 29/07/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
