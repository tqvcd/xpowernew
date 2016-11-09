//
//  FriendAddViewController.swift
//  BarApp
//
//  Created by hua on 8/14/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Parse

class FriendAddViewController: UIViewController, UIAlertViewDelegate {

    var friendName:String!
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(myHandler(_:))
        )
        
        let img = UIImage(named: "addfriend")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func findFriend(sender: AnyObject) {
        
        let rootRef = FIRDatabase.database().reference()
        
        
        let userRef = rootRef.child("user")
        
        let userItemRef = userRef.childByAutoId()
        
        
        let query = userRef.queryOrderedByChild("useremail").queryEqualToValue(self.emailTextField.text!)
        
        
        query.observeEventType(.Value, withBlock: {
            
            snapShot in
            
            let test = (snapShot.value as? NSNull)
            
            if(snapShot.value is NSNull){
                
                
                let noUserAlertView =  UIAlertView.init(title: "", message: "No such user", delegate: nil, cancelButtonTitle: "Ok")
                
                noUserAlertView.show()
            }
            else{
                
                
                let all = (snapShot.value?.allKeys)! as? [String]
                
                
              //  && ( ( (snapShot.value!["sendEmail"])! as! String) == self.emailTextField.text!)
                
                for a in all! {
                    
                    let result = snapShot.value!.objectForKey(a) as! [String:String]
                    
                    
                    self.friendName = result["username"]!
                    
                    let alertView =  UIAlertView.init(title: "", message: "Do you want to add \(self.friendName) (\(self.emailTextField.text!))", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
                    
                    alertView.show()
                    
                    break
                    
                    
                }
            
                
                
            }

           
            
            
        
        })
        
        
    }
    
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
           
            
            let rootRef = FIRDatabase.database().reference()
            
            
            let invitationRef = rootRef.child("invitation")
            
            let invitationItemRef = invitationRef.childByAutoId()
            
            let invitationMessage =  ["senderemail": PFUser.currentUser()!.email!,
                                      "sendername": PFUser.currentUser()!.username!, "receiver":self.emailTextField.text!, "receivername":self.friendName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), "accepted":false]
            
            invitationItemRef.setValue(invitationMessage)
            
            
            self.emailTextField.text = ""
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }
    }
    
    func myHandler(sender:UIBarButtonItem){
        
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        
        
        
        let rightMenuNavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier("rightmenunavigationcontroller")
        
        presentViewController(rightMenuNavigationController, animated: true, completion: nil)
        
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
