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
    
    //VARIABLE'S
    let buttonBackgroundColor = "Theam 2"
    let warehouse = "Warehouse"
    let users = "Users"
    let tableware = "Tableware"
    let placeMarker = "Place Marker"
    let gift = "Gift"
    let headset = "Headset"
    let homeVCIdentifier = "homeVC"
    let loginVCIdentifier = "LoginViewController"
    let profileVCIdentifier = "profileVC"
    let cookWithChefVCIdentifier = "CookWithChefVC"
    let mapVCIdentifier = "mapVC"
    let giftsVCIdentifier = "giftsVC"
    let suportVCIdentifer = "suportVC"
    var counter = 0
    var tabController:AZTabBarController!
    var audioId: SystemSoundID!
    var resultArray:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setIconsOnTabbar()
        tabController.delegate = self
        self.initializaViewControllersOnTabbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setIconsOnTabbar()
        tabController.delegate = self
        self.initializaViewControllersOnTabbar()
        tabController.buttonsBackgroundColor = UIColor(named: "Theam 2")!
        tabController.selectedColor =  UIColor(named: "Profile Label Color")!
        
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return tabController
    }
}

//MARK:- HELPING METHOD'S
extension MyTabbarVC {
    func setIconsOnTabbar() {
        var icons = [UIImage]()
        icons.append(UIImage(named: warehouse)!)
        icons.append(UIImage(named: users)!)
        icons.append(UIImage(named: tableware)!)
        icons.append(UIImage(named: placeMarker)!)
        icons.append(UIImage(named: gift)!)
        icons.append(UIImage(named: headset)!)
        
        var sIcons = [UIImage]()
        sIcons.append(UIImage(named: warehouse)!)
        sIcons.append(UIImage(named: users)!)
        sIcons.append(UIImage(named: tableware)!)
        sIcons.append(UIImage(named: placeMarker)!)
        sIcons.append(UIImage(named: gift)!)
        sIcons.append(UIImage(named: headset)!)
        
        tabController = .insert(into: self, withTabIcons: icons, andSelectedIcons: sIcons)
    }
    
    func initializaViewControllersOnTabbar() {
        let homeVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: homeVCIdentifier)
        tabController.setViewController(homeVC, atIndex: 0)
        
        let login_Status = defaults.bool(forKey: Constant.userLoginStatusKey)
        if login_Status != true{
            let profileVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: loginVCIdentifier)
            tabController.setViewController(profileVC, atIndex: 1)
        }else{
            let profileVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: profileVCIdentifier)
            tabController.setViewController(profileVC, atIndex: 1)
        }
        
        let CookWithChefVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: cookWithChefVCIdentifier)
        tabController.setViewController(CookWithChefVC, atIndex: 2)
        
        let mapVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: mapVCIdentifier)
        tabController.setViewController(mapVC, atIndex: 3)
        
        let giftsVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: giftsVCIdentifier)
        tabController.setViewController(giftsVC, atIndex: 4)
        
        let subscriptionVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: suportVCIdentifer)
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
    }
    
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int) {
        if index == 1{
            let login_Status = defaults.bool(forKey: Constant.userLoginStatusKey)
            if login_Status != true{
                
                let profileVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: loginVCIdentifier)
                tabBar.setViewController(profileVC, atIndex: index)
            }else{
                let profileVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: profileVCIdentifier)
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
