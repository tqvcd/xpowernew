//
//  RecentTasksTableViewController.swift
//  XPower
//
//  Created by hua on 11/8/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import AFNetworking
import Parse

class RecentTasksTableViewController: UITableViewController {
    
    var responseRecentArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib.init(nibName: "CustomerCellView", bundle: nil), forCellReuseIdentifier: "customercell")

        
        var manager = AFHTTPSessionManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        
        let img = UIImage(named: "addpointsbackground")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var paramsUsername = ["Username":PFUser.currentUser()!.username!]
        
        manager.POST("http://www.consoaring.com/PointService.svc/getrecentdeeds", parameters: paramsUsername, success: {
                (task, response) in
        
                  let responseRecentArray = response as! [AnyObject]
        
                   for recent in responseRecentArray{
        
                        var recentDict = recent as! [String:String]
        
                        self.responseRecentArray.append(recentDict["deed"]!)
        
                    }
        
            
                     self.tableView.reloadData()
        
                    }, failure: {
                            (task, error) in
                            print(error.localizedDescription)
                        
                })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.responseRecentArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customercell", forIndexPath: indexPath) as! CustomerTableViewCell

        // Configure the cell...
        
        cell.customerlabel.text = self.responseRecentArray[indexPath.row]
        
        cell.customerlabel.textColor = UIColor.whiteColor()
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.contentView.userInteractionEnabled = false
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
