//
//  ResetPasswordViewController.swift
//  XPower
//
//  Created by hua on 9/9/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

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
        
//        do{
//            
//            try PFUser.requestPasswordResetForEmail(self.resetpassword.text!)
//            
//        }catch{
//            
//            print("reset password error")
//        }
        
        var manager = AFHTTPSessionManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        var parametersResetEmail = ["Email":self.resetpassword.text!]
        
        print(self.resetpassword.text!)
        
        
        manager.POST("http://www.consoaring.com/UserService.svc/resetpassword", parameters: parametersResetEmail, success: {
            (task, response) in
            
               print(response)
            
            }, failure: {
                (task, error) in
                print(error.localizedDescription)
                
        })

        
        
        navigationController!.popViewControllerAnimated(true)
        
    }
}
