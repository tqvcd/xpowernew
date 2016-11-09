//
//  RightMenuTableController.swift
//  BMWDealerApp
//
//  Created by hua on 7/7/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit

class RightMenuTableController: UITableViewController, UIAlertViewDelegate {
    
    let rigthMenuNames = ["Home Screen", "Add Friend", "Friends List", "Friend Requests"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let img = UIImage(named: "rightmenubackground")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
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
        return rigthMenuNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("rightmenucell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel!.text = rigthMenuNames[indexPath.row]
        
        cell.textLabel?.textAlignment = .Left
        
        cell.textLabel?.textColor = UIColor.blackColor()
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 24)
           
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100.0
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let imageView = UIImageView(image: UIImage(named: "stars"))
        imageView.frame = self.tableView.bounds
        tableView.backgroundView = imageView
    }
    
    
    func openController(controllerName:String) {
        
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(controllerName)
        //        let mainNavigationController = storyboard?.instantiateViewControllerWithIdentifier("mainController") as! UINavigationController
        self.navigationController!.pushViewController(viewController!, animated: true)
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {  
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            openController("homescreen")
        case 1:
            
            openController("addFriend")
        case 2:

            openController("friends")
            
        case 3:
            openController("invitation")
        
        default:
             break
        }
     
    }

}
