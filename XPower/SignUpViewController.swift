//
//  SignUpViewController.swift
//  XPower
//
//  Created by hua on 9/7/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse
import FirebaseDatabase
import AFNetworking

class SignUpViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var signupName: UITextField!
    @IBOutlet weak var signupEmail: UITextField!
    
    let myKeyChainWrapper = KeychainWrapper()
    var passwordStr:String?
    
    var nameDominDict = [String:String]()
    
    @IBOutlet weak var signupPassword: UITextField!
    
    @IBOutlet weak var signupReenterPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let img = UIImage(named: "signup")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        
        nameDominDict["Haverford"] = "haverford.org"
        
        nameDominDict[
            "Agnes Irwin School"] = "agnesirwin.org"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        
        let userName = self.signupName.text
        let userEmail = self.signupEmail.text
        
        let password = self.signupPassword.text
        let reenteredpassword = self.signupReenterPassword.text
        
        passwordStr = password
        
        if(userName?.characters.count == 0) {
            
            let alert1 = UIAlertView.init(title: "Error", message: "Username can not be empty", delegate: nil, cancelButtonTitle: "OK")
            
            alert1.show()
            return
            
        }else if(userEmail?.characters.count == 0){
            let alert2 = UIAlertView.init(title: "Error", message: "Email can not be empty", delegate: nil, cancelButtonTitle: "OK")
            alert2.show()
            return
        }else if !(userEmail?.containsString("test"))! && !(userEmail?.containsString("neerajm"))! &&   !((userEmail?.containsString(nameDominDict[AppDelegate.schoolName!]!))!){
            let alert3 = UIAlertView.init(title: "Error", message: "Should use school email address", delegate: nil, cancelButtonTitle: "OK")
            
            alert3.show()
            
            return
            
        } else if(password != reenteredpassword || password?.characters.count < 1){
            
            let alert4 = UIAlertView.init(title: "Error", message: "Password and Reentered is not same", delegate: nil, cancelButtonTitle: "OK")
            
            self.signupPassword.text = ""
            self.signupReenterPassword.text = ""
            
            alert4.show()
            return
            
        }else {
            
            let newUser = PFUser()
            
            newUser.username = userName!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            newUser.email = userEmail
            newUser.password = password
            newUser.setValue(false, forKey: "hasavartar")
            newUser.setValue(AppDelegate.schoolName, forKey: "schoolname")
            
            myKeyChainWrapper.mySetObject(password, forKey: kSecValueData)
            myKeyChainWrapper.writeToKeychain()
            
            var manager = AFHTTPSessionManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
            
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-type")
            
            var params = ["Password":password!,"Username":userName!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), "Email":userEmail!, "SchoolName":AppDelegate.schoolName!, "Avatar":"false", "Avatarimageurl":""]
            
            
            manager.POST("http://www.consoaring.com/UserService.svc/CreateUserAccount", parameters:params, success: {
                (task, response) in
                print(response)
                }, failure: {
                    (task, error) in
                    print(error.localizedDescription)
            })

            
            newUser.signUpInBackgroundWithBlock({ (succeeded: Bool, error:NSError?) in
                
                if((error) != nil){
                    
                    let alertView = UIAlertView.init(title:"Error", message:error?.localizedDescription , delegate: self, cancelButtonTitle: "OK")
                    
                    alertView.show()
                    alertView.tag = 19
                    
                }else{
                       
                    let alertView = UIAlertView.init(title:"Success", message:"You have signed up", delegate: self, cancelButtonTitle: "Go to home")
                    
                    alertView.show()
                    
                }

            }) 
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.signupName.resignFirstResponder()
        self.signupPassword.resignFirstResponder()
        self.signupEmail.resignFirstResponder()
        self.signupReenterPassword.resignFirstResponder()
    }

    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 19 {
            
            signupName.text = ""
            signupReenterPassword.text = ""
            signupEmail.text = ""
            signupPassword.text = ""
            
            return
        }
        
        if buttonIndex == 0 {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            userDefaults.setObject(passwordStr, forKey: "loginPwd")
            userDefaults.setObject(PFUser.currentUser()!.username!, forKey: "username")
            
            let rootRef = FIRDatabase.database().reference()
            
            let userRef = rootRef.child("user")
            
            let userItemRef = userRef.childByAutoId()
            
            let query = userRef.queryOrderedByChild("useremail").queryEqualToValue(PFUser.currentUser()!.email!)
            
            
            query.observeEventType(.Value, withBlock: {
                
                snapShot in

                
                
                let test = (snapShot.value as? NSNull)
                
                 print(AppDelegate.schoolName!)
                
                if test != nil && (snapShot.value as? NSNull)!.isEqual(NSNull.init()) {
                    
                    userItemRef.setValue(["useremail": PFUser.currentUser()!.email!, "username":PFUser.currentUser()!.username!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), "schoolname":AppDelegate.schoolName!])
                    
                    
                }
            })
            
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("uploadavartar")
                
                self.navigationController?.pushViewController(viewController!, animated: true)

            })
            
            
        }
        
    }

}
