//
//  NewSettingViewController.swift
//  XPower
//
//  Created by hua on 9/12/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse

class NewSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let img = UIImage(named: "newsettingbackground")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changePassword(sender: AnyObject) {
        
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewControllerWithIdentifier("changepassword"))!, animated:true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func changePhoto(sender: AnyObject) {
        
        let temp = self.storyboard!.instantiateViewControllerWithIdentifier("uploadavartar") as! UploadAvartarViewController
        
        
        temp.dismiss = true
        
        self.navigationController?.pushViewController(temp, animated: true)
        
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        
        
        PFUser.logOut()
        
        AppDelegate.totalScoreLoad = true
        
        ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance.obtainedPointsArray.removeAll()
        
        self.navigationController!.pushViewController((self.storyboard?.instantiateViewControllerWithIdentifier("firstscreen"))!, animated: true)
        
        
    }
    
    @IBAction func gotoTouchIdPage(sender: AnyObject) {
        
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewControllerWithIdentifier("touchid"))!, animated: true)
        
    }
    
    @IBOutlet weak var reportIssue: UIButton!
    
    @IBAction func reportIssueAction(sender: AnyObject) {
        
        
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("reportconcern"), animated: true)
        
    }
}
