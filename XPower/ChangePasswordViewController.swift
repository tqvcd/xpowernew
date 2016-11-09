//
//  ChangePasswordViewController.swift
//  XPower
//
//  Created by hua on 9/12/16.
//

import UIKit
import Parse

class ChangePasswordViewController: UIViewController {
    
    let helper = TouchIdKeyChainHelper()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let img = UIImage(named: "changepassword")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var passwordagain: UITextField!

    @IBOutlet weak var password: UITextField!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func updateAction(sender: AnyObject) {
        if password.text?.characters.count > 0 && passwordagain.text?.characters.count > 0 && password.text == (userDefaults.objectForKey("loginPwd")! as! String) {
                      
            PFUser.currentUser()!.password = passwordagain.text
            do{
                try PFUser.currentUser()!.save()
            }catch{
                
                print("update password error")
            }
            
            userDefaults.setObject(passwordagain.text!, forKey: "loginPwd")
            userDefaults.setObject(PFUser.currentUser()!.username!, forKey: "username")
            
            if userDefaults.objectForKey("useTouchId") != nil &&  userDefaults.objectForKey("useTouchId") as! Bool {
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
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.password.resignFirstResponder()
        self.passwordagain.resignFirstResponder()
    }
}
