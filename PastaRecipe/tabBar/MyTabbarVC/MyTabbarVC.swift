//
//  MyTabbarVC.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 21/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AZTabBar

class MyTabbarVC: UIViewController {
    
    var counter = 0
    var tabController:AZTabBarController!
    var audioId: SystemSoundID!
    var resultArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // First Set Icons of tabs
        self.setIconsOnTabbar()
        //set delegate
        tabController.delegate = self
        //set child controllers
        self.initializaViewControllersOnTabbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setIconsOnTabbar()
        //set delegate
        tabController.delegate = self
        //set child controllers
        self.initializaViewControllersOnTabbar()
        
        tabController.buttonsBackgroundColor = UIColor(named: "Theam 2")!
        tabController.selectedColor = .white
        
    }
    
    override var childForStatusBarStyle: UIViewController?{
        return tabController
    }
    
    func setIconsOnTabbar() {
        var icons = [UIImage]()
        icons.append(UIImage(named: "Warehouse")!)
        icons.append(UIImage(named: "Users")!)
        icons.append(UIImage(named: "Tableware")!)
        icons.append(UIImage(named: "Place Marker")!)
        icons.append(UIImage(named: "Gift")!)
        icons.append(UIImage(named: "Headset")!)
        
        var sIcons = [UIImage]()
        sIcons.append(UIImage(named: "Warehouse")!)
        sIcons.append(UIImage(named: "Users")!)
        sIcons.append(UIImage(named: "Tableware")!)
        sIcons.append(UIImage(named: "Place Marker")!)
        sIcons.append(UIImage(named: "Gift")!)
        sIcons.append(UIImage(named: "Headset")!)
        
        tabController = .insert(into: self, withTabIcons: icons, andSelectedIcons: sIcons)
    }
    
    func initializaViewControllersOnTabbar() {
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC")
        tabController.setViewController(homeVC, atIndex: 0)
        
        let login_Status = defaults.bool(forKey: "userLoginStatus")
        if login_Status != true{
            
            let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            tabController.setViewController(profileVC, atIndex: 1)
        }else{
            
            let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileVC")
            tabController.setViewController(profileVC, atIndex: 1)
            
        }
        
        
        let CookWithChefVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CookWithChefVC")
        tabController.setViewController(CookWithChefVC, atIndex: 2)
        
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapVC")
        tabController.setViewController(mapVC, atIndex: 3)
        
        let giftsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "giftsVC")
        tabController.setViewController(giftsVC, atIndex: 4)
        
        let subscriptionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "suportVC")
        tabController.setViewController(subscriptionVC, atIndex: 5)
    }
    
    func getNavigationController(root: UIViewController)->UINavigationController{
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.title = title
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        return navigationController
    }
    
    func actionLaunchCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert:UIAlertController = UIAlertController(title: "Camera Unavailable", message: "Unable to find a camera on this device", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MyTabbarVC: AZTabBarDelegate{
    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int) -> UIStatusBarStyle {
        return (index % 2) == 0 ? .default : .lightContent
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int) -> Bool {
        return true//index != 2 && index != 3
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index: Int) -> Bool {
        return true
    }
    
    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int) {
        print("didMoveToTabAtIndex \(index)")
    }
    
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int) {
        print("didSelectTabAtIndex \(index)")
        if index == 1{
            let login_Status = defaults.bool(forKey: "userLoginStatus")
            if login_Status != true{
                
                let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
                tabBar.setViewController(profileVC, atIndex: index)
            }else{
                
                let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileVC")
                tabBar.setViewController(profileVC, atIndex: index)
                
            }
        }
        
    }
    
    func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index: Int) {
        print("willMoveToTabAtIndex \(index)")
    }
    
    func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index: Int) {
        print("didLongClickTabAtIndex \(index)")
    }
    
    func tabBar(_ tabBar: AZTabBarController, systemSoundIdForButtonAtIndex index: Int) -> SystemSoundID? {
        return tabBar.selectedIndex == index ? nil : audioId
    }
    
}

extension MyTabbarVC{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
    override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

class LabelController: UIViewController {
    
    class func controller(text:String, title: String)-> LabelController{
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LabelController") as! LabelController
        controller.title = title
        controller.text = text
        return controller
    }
    
    var text:String!
    
    @IBOutlet weak private var labelView:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView.text = text
    }
    
}
