//
//  PointsTabViewController.swift
//  XPower
//
//  Created by hua on 11/4/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit

class PointsTabViewController: TabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image = UIImage(named: "points")
        
       // image!.drawInRect(CGRectMake(0, 0, 5, 5))
        

       var sizeNew = CGSizeMake(30, 30)
        
        for var tabBarItem in self.tabBar.items! {
            
                        tabBarItem.title = "Points";
                        var test = imageResize(image!, newSize: sizeNew )
            print(test)
                        tabBarItem.image = test
            
                        tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0)
            
                        break
                    }
        
        
        
        
        
        
//        let tabImageInsetsTrueOrFalse = NSUserDefaults.standardUserDefaults().boolForKey("tabimagesize")
//
//        if tabImageInsetsTrueOrFalse {
//        for var tabBarItem in self.tabBar.items! {
//            
//            tabBarItem.title = "Points";
//            tabBarItem.image = UIImage(named: "points")
//            tabBarItem.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "tabimagesize")
//            break
//        }
//        
//             NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resetTabBarImageInsets), name: "FinishLoading", object: self)
        
            
            
        }
    
    
    
    func imageResize(img:UIImage, newSize:CGSize) -> UIImage {
        var scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale);
        img.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    

        // Do any additional setup after loading the view.
 //   }

//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        NSNotificationCenter.defaultCenter().postNotificationName("FinishLoading", object: self)
//
//    }
    
    
//    func resetTabBarImageInsets(notification:NSNotification) {
//        for var tabBarItem in self.tabBar.items! {
//            
//            tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "tabimagesize")
//            break
//        }
   
    
  //  }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
