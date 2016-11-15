//
//  CustomerTableViewCell.swift
//  XPower
//
//  Created by hua on 11/9/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import AFNetworking
import Parse
import Firebase
import FirebaseDatabase


class CustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var customerlabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        addButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        addButton.addTarget(self, action: #selector(plusIndictorLabel), forControlEvents:UIControlEvents.TouchUpInside)
        
        let pointsImageView = UIImageView.init(frame: CGRectMake(0, 0, 35, 35))
        pointsImageView.image = UIImage(named: "points")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        pointsImageView.center = CGPointMake(addButton.frame.size.width/2, addButton.frame.size.height/2)
        
        pointsImageView.tintColor = UIColor.whiteColor()
        
        addButton.addSubview(pointsImageView)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    

    func plusIndictorLabel()  {
        
        PointsTableViewController.sharedPointsTableViewControllerInstance.pointsviewController?.obtainedtableview.beginUpdates()
        
        ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance.obtainedPointsArray.insert(customerlabel.text!, atIndex: 0)
        //        (pointsTableObject.pointsListArray[Array(pointsTableObject.pointsListArray.keys)[tableSection!]]![tableRow!], atIndex: 0)
        
        //             ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance.obtainedPointsArray.insert(pointsTableObject.pointsListArray[Array(pointsTableObject.pointsListArray.keys)[tableSection!]]![tableRow!], atIndex: 0)
        
        AppDelegate.totalScoreLoad = false
        
        
        
        let alertView = UIAlertView.init(title: "Add Points!", message:customerlabel.text! , delegate: nil, cancelButtonTitle: nil)
        
        alertView.show()
        
        let delay = 2 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertView.dismissWithClickedButtonIndex(-1, animated: true)
        })
        
        PointsTableViewController.sharedPointsTableViewControllerInstance.pointsviewController?.obtainedtableview.reloadData()
        let newIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        PointsTableViewController.sharedPointsTableViewControllerInstance.pointsviewController?.obtainedtableview.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        PointsTableViewController.sharedPointsTableViewControllerInstance.pointsviewController?.obtainedtableview.endUpdates()
        
        
        let manager = AFHTTPSessionManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var dateString = dateFormatter.stringFromDate(NSDate())
        
        var paramsUserAddDeeds = ["user":PFUser.currentUser()!.username!, "deed":customerlabel.text!, "date":dateString]
        
        manager.POST("http://www.consoaring.com/PointService.svc/adddeeds", parameters: paramsUserAddDeeds, success: {
            (task, response) in
            print(response)
             NSNotificationCenter.defaultCenter().postNotificationName("addtasks", object: self)
            
            }, failure: {
                (task, error) in
                print(error.localizedDescription)
                
        })
        
       
        
        
        let rootRef = FIRDatabase.database().reference()
        
        let schoolTotalScore = rootRef.child("schooltotalscore")
        
        let schooltotalScoreItem = schoolTotalScore.childByAutoId()
        
        let totalScore = rootRef.child("totalScore")
        
        let totalScoreItem = totalScore.childByAutoId()
        
        var totalScoreMessage = ["useremail": PFUser.currentUser()!.email!, "totalscore": String(PointsTableViewController.sharedPointsTableViewControllerInstance.pointstable[customerlabel.text!]!), "name": customerlabel.text!, "schoolname": PFUser.currentUser()!.objectForKey("schoolname") as! String, "date":String(NSDate().timeIntervalSince1970)]
        
        totalScoreItem.setValue(totalScoreMessage)
        
        schooltotalScoreItem.setValue(totalScoreMessage)


        
    }

    
    
    
    
    
    
}
