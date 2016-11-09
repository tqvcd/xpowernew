//
//  ResetPasswordViewController.swift
//  XPower
//
//  Created by hua on 9/9/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var resetpassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var resetPasswordAction: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func resetPassword(sender: AnyObject) {
        
        do{
            
            try PFUser.requestPasswordResetForEmail(self.resetpassword.text!)
            
        }catch{
            
            print("reset password error")
        }
        
        navigationController!.popViewControllerAnimated(true)
        
    }
}
