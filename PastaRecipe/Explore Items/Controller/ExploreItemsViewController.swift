//
//  ExploreItemsViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 30/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class ExploreItemsViewController: UIViewController {

    //IBOUTLET'S
    @IBOutlet weak var ExploreItemsTable: UITableView!
    
    //VARIABLE'S
    var productsArray = [ProductsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let items = CommonHelper.getCachedUserExploreItems() {
            self.productsArray = items
            self.ExploreItemsTable.reloadData()
        }
    }
}

extension ExploreItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (
            withIdentifier: "ProductsTableViewCell",
            for: indexPath
        ) as! ProductsTableViewCell
        if let url = self.productsArray[indexPath.row].recipe_data.media_file{
            cell.RecipeImage.sd_setImage(with: URL(string: url), placeholderImage:  #imageLiteral(resourceName: "101"))
        }
        cell.RecipeName.text = self.productsArray[indexPath.row].recipe_data.recipe_name
        cell.RecipeDetail.text = self.productsArray[indexPath.row].recipe_data.recipe_short_description
        cell.RecipePrice.text = "$ " + self.productsArray[indexPath.row].recipe_data.amount
        
        let backView = UIView()
        backView.backgroundColor = .clear
        cell.selectedBackgroundView = backView
        
        return cell
    }
}
