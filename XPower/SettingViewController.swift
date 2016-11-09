//
//  SettingViewController.swift
//  XPower
//
//  Created by hua on 9/8/16.
//

import UIKit
import Parse

class SettingViewController: UIViewController {
    let helper = TouchIdKeyChainHelper()
    
    let user = PFUser.currentUser()!
    let userDefaults = NSUserDefaults.standardUserDefaults()


    @IBOutlet weak var touchIdswitchButton: UISwitch!
    @IBOutlet weak var newpasswordtextfield: UITextField!
    @IBOutlet weak var touchIdSwitch: UISwitch!
    @IBOutlet weak var oldpasswordtextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let img = UIImage(named: "settings")
        
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
    

    @IBAction func updateSetting(sender: AnyObject) {
        
        if oldpasswordtextfield.text?.characters.count > 0 && newpasswordtextfield.text?.characters.count > 0 && oldpasswordtextfield.text == (userDefaults.objectForKey("loginPwd") as! String) {
            
            PFUser.currentUser()!.password = newpasswordtextfield.text
            
            do{
            try PFUser.currentUser()!.save()
            }catch{
                
                print("update password error")
            }
            
            
            if touchIdswitchButton.on {
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            userDefaults.setObject(newpasswordtextfield.text!, forKey: "loginPwd")
            userDefaults.setObject(PFUser.currentUser()!.username!, forKey: "username")
            
            
            helper.deleteItemAsync()
            
            userDefaults.setValue(true, forKey: "useTouchId")
            let namepluspassword = "\(userDefaults.objectForKey("loginPwd")!) \(userDefaults.objectForKey("username")!)"
            
            helper.addTouchIDItemAsync(namepluspassword.dataUsingEncoding(NSUTF8StringEncoding)!)


            }
            
            
            self.navigationController!.popViewControllerAnimated(true)
            
        }else{
            
            
            let alertView = UIAlertView.init(title: "Error", message: "Please make sure input right old password and both old password and new password are not empty", delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
            
            
        }
 
    }
    
     @IBAction func statuschanged(sender: AnyObject) {
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBarHidden = false
        
    }

    
    @IBAction func changeProfileImage(sender: AnyObject) {
        
        
        let temp = self.storyboard!.instantiateViewControllerWithIdentifier("uploadavartar") as! UploadAvartarViewController
  
        temp.dismiss = true
        
        self.navigationController?.pushViewController(temp, animated: true)
      
    }
    
    
     @IBAction func reportConcern(sender: AnyObject) {
        
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("reportconcern"), animated: true)
        
        
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
