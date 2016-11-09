//
//  TurnOnOrOffTouchIdViewController.swift
//  XPower
//
//  Created by hua on 9/12/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse

class TurnOnOrOffTouchIdViewController: UIViewController {

    let helper = TouchIdKeyChainHelper()
    
    let user = PFUser.currentUser()!
    let userDefaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var touchIdswitchButton: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let img = UIImage(named: "touchid")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        // Do any additional setup after loading the view.
        
        let currentUser = PFUser.currentUser()!
        
        if currentUser.objectForKey("touchIdOn") == nil {
            
            currentUser.setValue(false, forKey: "touchIdOn")
            
            do{
                
                try currentUser.save()
            }catch{
                print("set user touchIdOn property fails")
                return
            }
            
            touchIdswitchButton.on = false
            
            
        }else if currentUser.objectForKey("touchIdOn") as! Bool == true
        {
            
            touchIdswitchButton.on = true
            
        }else if currentUser.objectForKey("touchIdOn") as! Bool == false{
            
            touchIdswitchButton.on = false
            
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func statuschange(sender: AnyObject) {
        if(touchIdswitchButton.on){
            user.setValue(true, forKey: "touchIdOn")
            do
            {try user.save()
            }catch{
                print("Error happens when save user data")
            }
            
            userDefaults.setValue(true, forKey: "useTouchId")
            let namepluspassword = "\(userDefaults.objectForKey("loginPwd")!) \(userDefaults.objectForKey("username")!)"
            
            helper.addTouchIDItemAsync(namepluspassword.dataUsingEncoding(NSUTF8StringEncoding)!)
            
        }else{
            userDefaults.setValue(false, forKey: "useTouchId")
            user.setValue(false, forKey: "touchIdOn")
            do
            {try user.save()
            }catch{
                print("Error happens when save user data")
            }
         
            helper.deleteItemAsync()
        }
    }

}
