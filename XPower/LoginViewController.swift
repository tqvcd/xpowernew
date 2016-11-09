//
//  LoginViewController.swift
//  XPower
//
//  Created by hua on 9/7/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    var helper:TouchIdKeyChainHelper?

    var loginName:String?
    var loginPassword:String?

    let rootRef = FIRDatabase.database().reference()
    
    var totalScoreRef:FIRDatabaseReference?
    
    var totalScores = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBarHidden = false
        
        let img = UIImage(named: "login")
        
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
    

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
 
    @IBAction func loginAction(sender: AnyObject) {
        
        if(self.userName.text?.characters.count > 0 && self.password.text?.characters.count > 0) || (self.loginName != nil && self.loginPassword != nil && self.loginName!.characters.count > 0 && self.loginPassword!.characters.count > 0){
            
            if(self.userName.text!.characters.count > 0 && self.password.text!.characters.count > 0){
            loginName = self.userName.text
            loginPassword = self.password.text
            }
            
            dispatch_async(dispatch_get_main_queue()){
         
                PFUser.logInWithUsernameInBackground(self.loginName!, password: self.loginPassword!){
                    
                    (user:PFUser?, error:NSError?)->Void in
                    
                    if(user != nil){
                        dispatch_async(dispatch_get_main_queue()){
                            
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            
                            userDefaults.setObject(self.loginPassword, forKey: "loginPwd")
                            userDefaults.setObject(self.loginName, forKey: "username")
                  
                            if userDefaults.objectForKey("useTouchId") != nil &&  userDefaults.objectForKey("useTouchId") as! Bool {

                                self.helper!.deleteItemAsync()
                                
                                userDefaults.setValue(true, forKey: "useTouchId")
                                let namepluspassword = "\(userDefaults.objectForKey("loginPwd")!) \(userDefaults.objectForKey("username")!)"
                                
                                self.helper!.addTouchIDItemAsync(namepluspassword.dataUsingEncoding(NSUTF8StringEncoding)!)
                                
                            }

                            let rootRef = FIRDatabase.database().reference()
                            
                            let userRef = rootRef.child("user")
                            
                            let userItemRef = userRef.childByAutoId()
                            
                            let query = userRef.queryOrderedByChild("useremail").queryEqualToValue(PFUser.currentUser()!.email!)
                            
                            
                            query.observeEventType(.Value, withBlock: {
                                
                                snapShot in
                                
                                
                                let test = (snapShot.value as? NSNull)
                                
                                
                                if test != nil && (snapShot.value as? NSNull)!.isEqual(NSNull.init()) {
                                    
                                    userItemRef.setValue(["useremail": PFUser.currentUser()!.email!, "username":PFUser.currentUser()!.username!])
                                    
                                    
                                }
                            })
                
                            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("homescreen") as! HomeScreenViewController
                     
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }else{
                        
                        let alertView = UIAlertView.init(title: "Error", message: error?.localizedDescription, delegate: self, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                    
                }
                
                
                self.userName.text = ""
                self.password.text = ""
                
            }

        }
  
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let useTouchIdOn = userDefaults.objectForKey("useTouchId") as? Bool
        
        if(useTouchIdOn == true){
            
            
            helper = TouchIdKeyChainHelper()
            
            helper?.copyMatchingAsync(self)
            
            
        }
        
    }
    
    
    func loginUsingTouchId(nameStr:String, passwordStr:String)  {
        
        
        loginName = nameStr
        
        loginPassword = passwordStr
        
        self.loginAction(self)
        
        
    }

    
    
    @IBOutlet weak var useTouchIdLogin: UIButton!
    
    

    @IBAction func loginUseTouchId(sender: AnyObject) {
       
        let userDef = NSUserDefaults.standardUserDefaults()
        
        let userTouchIdOn = userDef.objectForKey("useTouchId") as? Bool
        
        if(userTouchIdOn == true){
            
            helper = TouchIdKeyChainHelper()
            
            helper?.copyMatchingAsync(self)
        }
 
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.password.resignFirstResponder()
        self.userName.resignFirstResponder()
        
    }
   
    
    @IBAction func gotoResetPasswordPage(sender: AnyObject) {
             
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("resetpassword"), animated: true)
        
    }
    
    
}
