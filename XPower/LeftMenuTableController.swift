//
//  LeftMenuTableController.swift
//  BMWDealerApp
//
//  Created by hua on 7/7/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse

class LeftMenuTableController: UITableViewController {
    
    let currUser = PFUser.currentUser()

    var leftSideMenuNames = ["Home", "Inventory", "Calendar", "Service", "Garage", "Settings", "About", "Logout"]
    
    var leftSideGuestMenuNames = ["Home", "Inventory", "Calendar", "Service", "Garage", "About", "Go to Login"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    
        if PFUser.currentUser() == nil || currUser!.username == "guest"{
        
            leftSideMenuNames = leftSideGuestMenuNames
        
        }
        
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
        return leftSideMenuNames.count
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let imageView = UIImageView(image: UIImage(named: "stars"))
        imageView.frame = self.tableView.bounds
        tableView.backgroundView = imageView
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("leftmenucell", forIndexPath: indexPath)
        
        cell.textLabel?.text = leftSideMenuNames[indexPath.row]
        
        cell.textLabel?.textAlignment = .Left
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 18)

        cell.backgroundColor = UIColor.clearColor()
        // Configure the cell...

        return cell
    }
    
    
    func openController(controllerName:String) {

        let viewController = storyboard?.instantiateViewControllerWithIdentifier(controllerName)
        self.navigationController!.pushViewController(viewController!, animated: true)
        
    }
     
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
             openController("Home")
        case 1:
             openController(leftSideMenuNames[1])
        case 2:
            openController(leftSideMenuNames[2])
        case 3:
            openController(leftSideMenuNames[3])
        case 4:
            openController(leftSideMenuNames[4])
        case 5:
            openController(leftSideMenuNames[5])
        case 6:
            if(PFUser.currentUser() == nil)
            {
                self.openController("Login")
                return 
            }
            else if currUser!.username == "guest"
            {
                PFUser.logOut()
                self.openController("Login")

                return
            }
            openController(leftSideMenuNames[6])
        
        default:
            PFUser.logOut()
            self.openController("Login")
        }
 
    }

}
