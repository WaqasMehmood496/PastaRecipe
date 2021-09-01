//
//  CommonHelper.swift
//  TradeAir
//
//  Created by Adeel on 08/10/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit

class CommonHelper
{
    static let sharedInstance = CommonHelper() //<- Singleton Instance
    
    private init() { /* Additional instances cannot be created */ }
    
    class func round(_ val: Double, to decimals: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.roundingMode = .up
        let ret = formatter.string(from: val as NSNumber)
        
        return ret
    }
    class func saveCachedUserData(_ userData:LoginModel){
        let userDefaults = UserDefaults.standard
        do {
            
            try userDefaults.setObject(userData, forKey: Constant.login_key)
            userDefaults.synchronize()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    class func saveCachedUserExploreItems(_ items:[ProductsModel]){
        let userDefaults = UserDefaults.standard
        do {

            try userDefaults.setObject(items, forKey: Constant.user_Explore_Items_key)

        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func getCachedUserData() -> LoginModel? {
        let userDefaults = UserDefaults.standard
        do {
            let user = try userDefaults.getObject(forKey: Constant.login_key, castTo: LoginModel.self)
            print(user.user_detail.user_id)
            return user
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    class func getCachedUserExploreItems() -> [ProductsModel]? {
        let userDefaults = UserDefaults.standard
        do {
            let user = try userDefaults.getObject(forKey: Constant.user_Explore_Items_key, castTo: [ProductsModel].self)
            print(user[0].recipe_data.recipe_id ?? "0")
            return user
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    class func removeCachedUserData() {
        let userDefaults = UserDefaults.standard
        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        userDefaults.synchronize()
    }
    
    
    class func setLeftPadding(_ txt: UITextField?)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        txt?.leftView = paddingView
        txt?.leftViewMode = .always
        txt?.setNeedsLayout()
        txt?.setNeedsDisplay()
    }
    
    class func getLocale() -> String? {
        return NSLocale.preferredLanguages[0]
    }
    
    class func showAllFontsFamiliesNames() -> Void
    {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
    class func getLocalizedImage(_ name: String?) -> UIImage? {
        return UIImage(named: "\(URL(fileURLWithPath: name ?? "").deletingPathExtension().absoluteString)_\(CommonHelper.getLocale() ?? "")")
    }
    
    
    // MARK: - Activity Indicator Inside Button
    func showActivityIndicator(_ activityIndicatorForButton: UIActivityIndicatorView?, inside buttonObj: UIButton?) {
        DispatchQueue.main.async(execute: {
            if (buttonObj?.frame.size.width ?? 0.0) <= 133.0 {
                buttonObj?.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
            }
            let halfButtonHeight: CGFloat = (buttonObj?.bounds.size.height ?? 0.0) / 2
            let buttonWidth: CGFloat? = buttonObj?.bounds.size.width
            activityIndicatorForButton?.center = CGPoint(x: (buttonWidth ?? 0.0) - halfButtonHeight, y: halfButtonHeight)
            if let aButton = activityIndicatorForButton {
                buttonObj?.addSubview(aButton)
            }
            activityIndicatorForButton?.hidesWhenStopped = true
            activityIndicatorForButton?.startAnimating()
            buttonObj?.isUserInteractionEnabled = false
            /// Disable Other Controls
            //////////////////////////////////////////////////////////////////////
        })
    }
    
    func hideActivityIndicator(_ activityIndicatorForButton: UIActivityIndicatorView?, inside buttonObj: UIButton?) {
        if activityIndicatorForButton != nil {
            DispatchQueue.main.async(execute: {
                if (buttonObj?.frame.size.width ?? 0.0) <= 133.0 {
                    buttonObj?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
                activityIndicatorForButton?.removeFromSuperview()
                activityIndicatorForButton?.stopAnimating()
                buttonObj?.isUserInteractionEnabled = true
                /// Disable Other Controls
                //////////////////////////////////////////////////////////////////////
            })
        }
    }
    
    
    // MARK: - Country Code for Current Device
    func getCountryCodeForCurrentDevice() -> String? {
        let currentLocale = NSLocale.current as NSLocale // get the current locale.
        let countryCode = currentLocale.object(forKey: .countryCode) as? String
        return countryCode
    }
    
    func getImagefromURL(url_:String) -> UIImage{
        
        var image:UIImage?

        
        if url_ != nil{
            
            let url = URL(string:url_)
               if let data = try? Data(contentsOf: url!)
               {
                image = UIImage(data: data)
               }
            if image == nil{
                image = UIImage(named: "ic_work")
            }
            
        }
        else{
            image = UIImage(named: "ic_work")
        }
        
        
        
        
        return image!
        
        
    }
    
    // MARK: - Images
    func image(with color: UIColor?, andSize imageSize: CGSize) -> UIImage? {
        let imageSizeRect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        UIGraphicsBeginImageContext(imageSizeRect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor((color?.cgColor)!)
        context?.fill(imageSizeRect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: - Screen Size
    var appScreenRect: CGRect {
        let appWindowRect = UIApplication.shared.keyWindow?.bounds ?? UIWindow().bounds
        return appWindowRect
    }
    func getDirectoryPath(isImage:Bool = false) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var documentsDirectory = paths[0] as String
        if isImage{
            
            documentsDirectory = (paths[0] as NSString).appendingPathComponent("Images") as String
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: documentsDirectory){
                return documentsDirectory
            }
            else{
                do{
                    try fileManager.createDirectory(atPath: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
                    return documentsDirectory
                }
                catch{
                    print(error)
                    return ""
                }
            }
        }
        else{
            if let appname = Bundle.main.displayName{
                documentsDirectory = (paths[0] as NSString).appendingPathComponent(appname + ".sqlite3") as String
                debugPrint(documentsDirectory)
                return documentsDirectory
            }
            else{
                debugPrint(documentsDirectory)
                return documentsDirectory
            }
            
        }
        
    }
    
    // MARK:- ALERT CONTROLLER
    func ShowAlert(view: UIViewController,message:String,Title:String)
    {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            print(message)
        }))
        view.present(alert, animated: true, completion: nil)
    }
    
    func changeFullVC(identifier:String,vc:UIViewController) -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vcc: UIViewController = storyboard.instantiateViewController(withIdentifier: identifier) as UIViewController
        vcc.modalPresentationStyle = .fullScreen
        vc.present(vcc, animated: true, completion: nil)
        return vcc
        //defaults.set(true, forKey: "userLoginStatus")
    }
    
//    func changeRootViewController(storyboardId:String) {
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
//        self.window?.rootViewController = initialViewController
//        self.window?.makeKeyAndVisible()
//    }
    
//    class func saveCachedUserData(_ userData:[DashModel]){
//        let userDefaults = UserDefaults.standard
//        do {
//            try userDefaults.setObject(userData, forKey: Constant.product_cache_key)
//        } catch {
//          print(error.localizedDescription)
//        }
//      }
//      class func getCachedUserData() -> [DashModel]? {
//        let userDefaults = UserDefaults.standard
//        do {
//            let user = try userDefaults.getObject(forKey: Constant.product_cache_key, castTo: [DashModel].self)
//          //print(user.user_id ?? "0")
//          return user
//        } catch {
//          print(error.localizedDescription)
//          return nil
//        }
//      }
//      class func removeCachedUserData() {
//        let userDefaults = UserDefaults.standard
//        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//        userDefaults.synchronize()
//      }
    
}

