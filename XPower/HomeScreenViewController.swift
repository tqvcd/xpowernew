//
//  HomeScreenViewController.swift
//  XPower
//
//  Created by hua on 9/7/16.
//

import UIKit
import Parse
import FirebaseDatabase
import AFNetworking

extension NSDate {
    
    func beginningOfDay() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: self)
        return calendar.dateFromComponents(components)!
    }
    
    func endOfDay() -> NSDate {
        let components = NSDateComponents()
        components.day = 1
        var date = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.beginningOfDay(), options: [])!
        date = date.dateByAddingTimeInterval(-1)
        return date
    }
}


class HomeScreenViewController: UIViewController {

    @IBOutlet weak var settingbutton: UIButton!
    
    @IBOutlet weak var totalallscoreslabel: UILabel!
    @IBOutlet weak var scorebutton: UIButton!
    @IBOutlet weak var pointsbutton: UIButton!
    @IBOutlet weak var pointslabel: UILabel!
    @IBOutlet weak var logoutlabel: UILabel!
    @IBOutlet weak var logoutbutton: UIButton!
    
    @IBOutlet weak var friends: UIButton!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var totalscoreLabel: UILabel!
    
    let rootRef = FIRDatabase.database().reference()
    
    var totalScoreRef:FIRDatabaseReference?
    
    var totalScores = 0
    
    var manager = AFHTTPSessionManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(RecentTasksTableViewController.sharedRecentTasksInstance, selector:#selector(RecentTasksTableViewController.sharedRecentTasksInstance.updateRecentTasks), name: "addtasks", object: nil)
        
        
        let img = UIImage(named: "homescreenbackground")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        
        self.pointsbutton.layer.borderWidth = 0
        self.pointsbutton.layer.borderColor = UIColor.whiteColor().CGColor
        self.pointsbutton.layer.cornerRadius = self.pointsbutton.layer.bounds.size.width/2
        self.pointsbutton.layer.masksToBounds = true
        
        
        let pointsImageView = UIImageView.init(frame: CGRectMake(0, 0, 35, 35))
        pointsImageView.image = UIImage(named: "points")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        pointsImageView.center = CGPointMake(self.pointsbutton.frame.size.width/2, self.pointsbutton.frame.size.height/2)
        
        pointsImageView.tintColor = UIColor.whiteColor()
        
        self.pointsbutton.addSubview(pointsImageView)
        
        
        
        self.friends.layer.borderWidth = 1
        self.friends.layer.borderColor = UIColor.whiteColor().CGColor
        self.friends.layer.cornerRadius = self.pointsbutton.layer.bounds.size.width/2
        
        self.friends.layer.masksToBounds = true
        
        let friendsImageView = UIImageView.init(frame: CGRectMake(0, 0, 45, 45))
        friendsImageView.image = UIImage(named: "user")!
            .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        friendsImageView.center = CGPointMake(self.friends.frame.size.width/2, self.friends.frame.size.height/2)
        
        friendsImageView.tintColor = UIColor.whiteColor()
        self.friends.addSubview(friendsImageView)
        
        
        
        self.scorebutton.layer.borderWidth = 1
        self.scorebutton.layer.borderColor = UIColor.whiteColor().CGColor
        self.scorebutton.layer.cornerRadius = self.pointsbutton.layer.bounds.size.width/2
        
        self.scorebutton.layer.masksToBounds = true
        
        let scorebuttonImageView = UIImageView.init(frame: CGRectMake(0, 0, 26, 26))
        scorebuttonImageView.image = UIImage(named: "cup")!
        .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        scorebuttonImageView.center = CGPointMake(self.scorebutton.frame.size.width/2, self.scorebutton.frame.size.height/2)
        
        scorebuttonImageView.tintColor = UIColor.whiteColor()
        self.scorebutton.addSubview(scorebuttonImageView)
        
        
        
        self.settingbutton.layer.borderWidth = 1
        self.settingbutton.layer.borderColor = UIColor.whiteColor().CGColor
        self.settingbutton.layer.cornerRadius = self.settingbutton.layer.bounds.size.width/2
        
        self.settingbutton.layer.masksToBounds = true
        
        let settingbuttonImageView = UIImageView.init(frame: CGRectMake(0, 0, 30, 30))
        settingbuttonImageView.image = UIImage(named: "settings-1")!
        .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        settingbuttonImageView.center = CGPointMake(self.settingbutton.frame.size.width/2, self.settingbutton.frame.size.height/2)
        
        settingbuttonImageView.tintColor = UIColor.whiteColor()
        self.settingbutton.addSubview(settingbuttonImageView)
        
        var manager = AFHTTPSessionManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        manager.GET("http://www.consoaring.com/PointService.svc/pointslistarray", parameters: nil, success: {
            (task, response) in
            print("********")
            
            
            
            do {
                let responseDict =
                    response as! [String:[AnyObject]]
                
                
                for (dictKey, dictValue) in responseDict
                {
                    PointsTableViewController.sharedPointsTableViewControllerInstance.pointsListArray[dictKey] = [String]()
                    
                    for i in  0 ..< dictValue.count{
                        // let test = ((responseDict[dictKey])![i]["Task"]!)!
                        
                        let testDict = ((responseDict[dictKey])![i]) as! [String:AnyObject]
                        
                        for(testkey, testvalue) in testDict{
                            
                            PointsTableViewController.sharedPointsTableViewControllerInstance.pointsListArray[dictKey]!.append(testvalue as! String)
                            // print("\(dictKey), \(testkey), \(testvalue)")
                            
                        }
                        
                        //self.displayTextView.text = test as! String
                        
                    }
                    
                    
                }
                
                
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                
            }
            
            print("*******")
            
            }, failure: {(task, error) in
                print(error.localizedDescription)
        })

        
        
        manager.GET("http://www.consoaring.com/PointService.svc/pointstable", parameters: nil, success: {(task, response)
            in
            
            let test = response as! [AnyObject]
            
            for i in 0 ..< test.count{
                
                let testDict = test[i] as! [String:AnyObject]
                
                PointsTableViewController.sharedPointsTableViewControllerInstance.pointstable[testDict["Description"] as! String ] = testDict["Point"] as! Int
                
                //                    for(testkey, testval) in testDict{
                //
                //                        print("\(testkey), \(testval)")
                //
                //                    }
                
                
            }
            
            
            PointsTableViewController.sharedPointsTableViewControllerInstance.pointstable["Shake your hands (5 points)"] = 5
                        
            }
            
            , failure: {
                
                (task, error)
                in
                
                print(error.localizedDescription)
                
        })

        
        let exitImage = UIImage(named: "exit")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
    
        self.totalScores = 0
        
        self.totalScoreRef = self.rootRef.child("totalScore")
        
        AppDelegate.totalScores = 0
                
        let query = self.totalScoreRef!.queryOrderedByChild("useremail").queryEqualToValue(PFUser.currentUser()!.email!).observeEventType(.Value, withBlock: {
            
          snapShot in
            
            if snapShot.value is NSNull? {    
                return
            }
            
            let all = (snapShot.value?.allKeys)! as? [String]
            
            for a in all! {
                
                let result = snapShot.value!.objectForKey(a) as! [String:String]
                
                if result["date"] == nil {
                    continue
                }
                
                AppDelegate.totalAllScores += Int(result["totalscore"]!)!

                
                if Double(result["date"]!) < Double(NSDate().beginningOfDay().timeIntervalSince1970) || Double(result["date"]!)! > Double(NSDate().endOfDay().timeIntervalSince1970) {
                    
                    continue
                    
                }
                
                AppDelegate.totalScores += Int(result["totalscore"]!)!
                
                
                if(AppDelegate.totalScoreLoad){
                    
                    ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance.obtainedPointsArray.append(result["name"]!)
                    
                }
                
                
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                
//                self.totalscoreLabel.text = String(AppDelegate.totalScores)
//                
//                self.totalscoreLabel.setNeedsDisplay()
//                
//                
//                self.totalallscoreslabel.text = String(AppDelegate.totalAllScores)
//                
//                self.totalallscoreslabel.setNeedsDisplay()
//                
//
//                AppDelegate.totalScores = 0
//                
//                AppDelegate.totalAllScores = 0
                
            })
            
            AppDelegate.totalScoreLoad = false
  
        })

    }
     
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = true
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
            
            
            self.manager.requestSerializer = AFJSONRequestSerializer()
            self.manager.responseSerializer = AFJSONResponseSerializer()
            self.manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-type")

            
            var paramsUsername = ["Username": PFUser.currentUser()!.username!]
            
            self.manager.POST("http://www.consoaring.com/PointService.svc/dailypoints", parameters: paramsUsername, success: {
                (task, response) in
                
//                self.totalscoreLabel.text = String(AppDelegate.totalScores)
//                //
//                //                self.totalscoreLabel.setNeedsDisplay()
                
                print(response)
                
                var responseDict = response as! [String:Int]
                
                if let totalps =  responseDict["dailypoints"] {
                    
                    self.totalscoreLabel.text = String(totalps)
                    
                    self.totalscoreLabel.setNeedsDisplay()
                    
                }
                
                               
                
                }, failure: {
                    (task, error) in
                    print(error.localizedDescription)
                    
            })

            
            
            
            var paramsSchoolname = ["SchoolName":(PFUser.currentUser()!.objectForKey("schoolname")?.lowercaseString)!]
            
            
            print(paramsSchoolname)
            
            self.manager.POST("http://www.consoaring.com/PointService.svc/totalschoolpoints", parameters: paramsSchoolname, success: {
                (task, response) in
                
                
                var responseDict = response as! [String:Int]
                
                if let totalps =  responseDict["totalpoints"] {
                    
                    self.totalallscoreslabel.text = String(totalps)
                    
                    self.totalallscoreslabel.setNeedsDisplay()
                    
                }
                
                
                
                }, failure: {
                    (task, error) in
                    print(error.localizedDescription)
                    
            })

            
            
         
            
            
            
            
            
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        
        AppDelegate.totalScoreLoad = true
        
        ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance.obtainedPointsArray.removeAll()
        
        self.navigationController!.pushViewController((self.storyboard?.instantiateViewControllerWithIdentifier("firstscreen"))!, animated: true)
        
    }

    @IBAction func pointsAction(sender: AnyObject) {
        
        self.navigationController?.pushViewController((storyboard?.instantiateViewControllerWithIdentifier("pointstabcontroller"))!, animated: true)
    
    }
    
    @IBAction func interactWithFriends(sender: AnyObject) {
        
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("friendhomescreen"), animated: true)
        
    }
    
    @IBAction func gotoScoreBoard(sender: AnyObject) {
 
        let scoreboardviewcontroller = self.storyboard!.instantiateViewControllerWithIdentifier("scoreboard") as! ScoreboardViewController
    
        self.navigationController!.pushViewController(scoreboardviewcontroller, animated: true)
        
        
    }

    @IBAction func gotoSettingpage(sender: AnyObject) {
        
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewControllerWithIdentifier("newsetting"))!, animated: true)
        
    }
   
}
