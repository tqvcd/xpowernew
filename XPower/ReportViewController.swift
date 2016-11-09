//
//  ReportViewController.swift
//  XPower
//
//  Created by hua on 9/9/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse

class ReportViewController: UIViewController {
    
    @IBOutlet weak var concernstextview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: "concerns")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        self.concernstextview.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendConcerns(sender: AnyObject) {

        if self.concernstextview.text.characters.count > 0 {
   
            let emailHandler = EmailHandler.sharedEmailHandler
            
            emailHandler.sendEmail("\(PFUser.currentUser()!.username!) (Email address: \(PFUser.currentUser()!.email!)) has following concerns: \n\(self.concernstextview.text)", receiver: "xpower3578@gmail.com", subject: "Concerns")
     
            self.navigationController?.popViewControllerAnimated(true)
        }

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.concernstextview.resignFirstResponder()
    }

}
