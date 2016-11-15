//
//  ScoreboardViewController.swift
//  XPower
//
//  Created by hua on 9/8/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Parse
import AFNetworking

class ScoreboardViewController: UIViewController {

    
    @IBOutlet weak var anotherschoolname: UILabel!
    
    @IBOutlet weak var anotherschoolpoints: UILabel!
    
    var schoolNameText:String?
    var schoolPointsText:String?
    
    let manager = AFHTTPSessionManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    let userDefaults = NSUserDefaults.standardUserDefaults()

    static let scoreboardViewControllerInstance = ScoreboardViewController()
    
    @IBOutlet weak var schoolpoints: UILabel!
    @IBOutlet weak var schoolname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let img = UIImage(named: "scoreboard")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        schoolname.text = PFUser.currentUser()!.objectForKey("schoolname") as! String
        
        var schoolscores = 0
        
        anotherschoolname.text = (userDefaults.objectForKey("schoolnamedictionary") as![String:String])[schoolname.text!]
        
        var anotherSchoolScores = 0
        
        var totalScoreRef = FIRDatabase.database().reference().child("totalScore")
        
        let query = totalScoreRef.queryOrderedByChild("schoolname").queryEqualToValue(PFUser.currentUser()!.objectForKey("schoolname") as! String).observeEventType(.Value, withBlock: {
            
           snapShot in
            if snapShot.value is NSNull? {     
                return
            }
            
            let all = (snapShot.value?.allKeys)! as? [String]
            
            for a in all! {
                
                let result = snapShot.value!.objectForKey(a) as! [String:String]
                
                schoolscores += Int(result["totalscore"]!)!
                
            }
            
            
//            self.schoolpoints.text = String(schoolscores)
//            
//            self.schoolname.text = PFUser.currentUser()!.objectForKey("schoolname") as! String
//            
//            self.schoolname.setNeedsDisplay()
//            self.schoolpoints.setNeedsDisplay()
            
        })
        
        let anotherquery = totalScoreRef.queryOrderedByChild("schoolname").queryEqualToValue(anotherschoolname?.text).observeEventType(.Value, withBlock: {
                  
            snapShot in
            
            if snapShot.value is NSNull? {
                
                return
                
            }
            
            let all = (snapShot.value?.allKeys)! as? [String]
            
            for a in all! {
                
                let result = snapShot.value!.objectForKey(a) as! [String:String]
                
                anotherSchoolScores += Int(result["totalscore"]!)!
                
            }
            
//            self.anotherschoolpoints.text = String(anotherSchoolScores)
//                        
//            self.anotherschoolname.text = (userDefaults.objectForKey("schoolnamedictionary") as![String:String])[self.schoolname.text!]
//            
//            self.anotherschoolname.setNeedsDisplay()
//            self.anotherschoolpoints.setNeedsDisplay()
   
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = false
        
        
        
        var paramsSchoolname = ["SchoolName":(PFUser.currentUser()!.objectForKey("schoolname")?.lowercaseString)!]
        
        anotherschoolname.text = (userDefaults.objectForKey("schoolnamedictionary") as![String:String])[schoolname.text!]
        
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        self.manager.POST("http://www.consoaring.com/PointService.svc/totalschoolpoints", parameters: paramsSchoolname, success: {
            (task, response) in
            
            print(response)
            var responseDict = response as! [String:Int]
            
            if let totalps =  responseDict["totalpoints"] {
                
                self.schoolpoints.text = String(totalps)
                
                self.schoolname.text = PFUser.currentUser()!.objectForKey("schoolname") as! String
                
                self.schoolname.setNeedsDisplay()
                self.schoolpoints.setNeedsDisplay()

                
            }
            
            
            
            }, failure: {
                (task, error) in
                print(error.localizedDescription)
                
        })

        var paramsAnotherSchoolname = ["SchoolName": anotherschoolname.text!.lowercaseString]
        
        
        self.manager.POST("http://www.consoaring.com/PointService.svc/totalschoolpoints", parameters: paramsAnotherSchoolname, success: {
            (task, response) in
            
            print(response)
            var responseDict = response as! [String:Int]
            
            if let totalps =  responseDict["totalpoints"] {
                
                            
                self.anotherschoolpoints.text = String(totalps)
                
                self.anotherschoolname.text = (self.userDefaults.objectForKey("schoolnamedictionary") as![String:String])[self.schoolname.text!]
                
                self.anotherschoolname.setNeedsDisplay()
                self.anotherschoolpoints.setNeedsDisplay()

                
                
            }
            
            
            
            }, failure: {
                (task, error) in
                print(error.localizedDescription)
                
        })

        

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
