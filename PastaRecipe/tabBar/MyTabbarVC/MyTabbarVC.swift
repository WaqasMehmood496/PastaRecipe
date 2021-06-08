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
        //audioId = createAudio()
        // First Set Icons of tabs
        self.setIconsOnTabbar()
        //set delegate
        tabController.delegate = self
        //set child controllers
        self.initializaViewControllersOnTabbar()
        


        //customize

//        let color = UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
//
//        tabController.selectedColor = color
//
//        tabController.highlightColor = color
//
//        tabController.highlightedBackgroundColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
//
        tabController.buttonsBackgroundColor = UIColor(named: "Theam 2")!
        tabController.selectedColor = .white
        //tabController.defaultColor = UIColor(named: "Theam 2")!
//
//        //tabController.highlightButton(atIndex: 2)
//
//        tabController.buttonsBackgroundColor = UIColor(red: (247.0/255), green: (247.0/255), blue: (247.0/255), alpha: 1.0)
//
//        tabController.selectionIndicatorHeight = 0
//
//        tabController.selectionIndicatorColor = color
//
//        tabController.tabBarHeight = 60
//
//        tabController.notificationBadgeAppearance.backgroundColor = .red
//        tabController.notificationBadgeAppearance.textColor = .white
//        tabController.notificationBadgeAppearance.borderColor = .clear
//        tabController.notificationBadgeAppearance.borderWidth = 0.2
//
//        tabController.setBadgeText("!", atIndex: 4)
//
//        tabController.setIndex(10, animated: true)
//
////        tabController.setAction(atIndex: 3){
////            self.counter = 0
////            self.tabController.setBadgeText(nil, atIndex: 3)
////        }
////
////        tabController.setAction(atIndex: 2) {
////            self.tabController.onlyShowTextForSelectedButtons = !self.tabController.onlyShowTextForSelectedButtons
////        }
//
////        tabController.setAction(atIndex: 4) {
////            //self.tabController.setBar(hidden: true, animated: true)
////        }
//
//        tabController.setIndex(1, animated: true)
//
//        tabController.animateTabChange = true
//        tabController.onlyShowTextForSelectedButtons = false
////        tabController.setTitle("Home", atIndex: 0)
////        tabController.setTitle("Search", atIndex: 1)
////        tabController.setTitle("Camera", atIndex: 2)
////        tabController.setTitle("Feed", atIndex: 3)
////        tabController.setTitle("Profile", atIndex: 4)
//        tabController.font = UIFont(name: "AvenirNext-Regular", size: 12)
//
//        let container = tabController.buttonsContainer
//        container?.layer.shadowOffset = CGSize(width: 0, height: -2)
//        container?.layer.shadowRadius = 10
//        container?.layer.shadowOpacity = 0.1
//        container?.layer.shadowColor = UIColor.black.cgColor
//
//
//        tabController.setButtonTintColor(color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), atIndex: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setIconsOnTabbar()
        //set delegate
        tabController.delegate = self
        //set child controllers
        self.initializaViewControllersOnTabbar()
        


        //customize

//        let color = UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
//
//        tabController.selectedColor = color
//
//        tabController.highlightColor = color
//
//        tabController.highlightedBackgroundColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
//
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
    
//    func createAudio()->SystemSoundID{
//        var soundID: SystemSoundID = 0
//        let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "blop" as CFString?, "mp3" as CFString?, nil)
//        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
//        return soundID
//    }
    
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
//
//extension MyTabbarVC: AZSearchViewDelegate{
//
//    func searchView(_ searchView: AZSearchViewController, didSearchForText text: String) {
//        searchView.dismiss(animated: false, completion: nil)
//    }
//
//    func searchView(_ searchView: AZSearchViewController, didTextChangeTo text: String, textLength: Int) {
//        self.resultArray.removeAll()
//        if textLength > 3 {
//            for i in 0..<arc4random_uniform(10)+1 {self.resultArray.append("\(text) \(i+1)")}
//        }
//
//        searchView.reloadData()
//    }
//
//    func searchView(_ searchView: AZSearchViewController, didSelectResultAt index: Int, text: String) {
//        searchView.dismiss(animated: true, completion: {
//        })
//    }
//}
//
//extension MyTabbarVC: AZSearchViewDataSource{
//
//    func results() -> [String] {
//        return self.resultArray
//    }
//}

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
//
//class ButtonController: UIViewController{
//    class func controller(badgeCount:Int, currentIndex: Int )-> ButtonController{
//        
//        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ButtonController") as! ButtonController
//        controller.badgeCount = badgeCount
//        controller.currentIndex = currentIndex
//        return controller
//    }
//    
//    var badgeCount: Int = 0
//    var currentIndex: Int = 0
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        for view in view.subviews{
//            if view is UIButton{
//                view.badge(text: nil)
//            }
//        }
//        
//        currentTabBar?.setBadgeText(nil, atIndex: currentIndex)
//    }
//    
//    @IBAction func didClickButton(_ sender: UIButton) {
//        badgeCount += 1
//        
//        //currentTabBar?.removeAction(atIndex: 2)
//        
//        if let tabBar = currentTabBar{
//            tabBar.setBadgeText("\(badgeCount)", atIndex: currentIndex)
//            sender.badge(text: "\(badgeCount)")
//        }
//    }
//    
//    
//}

