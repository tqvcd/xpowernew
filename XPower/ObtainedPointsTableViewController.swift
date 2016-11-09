//
//  ObtainedPointsTableViewController.swift
//  XPower
//
//  Created by hua on 9/7/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse
import Firebase
import FirebaseDatabase

class ObtainedPointsTableViewController: UITableViewController {
    var  rootRef:FIRDatabaseReference?
    
    var obtainedPointsArray = [String]()
    static let obtainedPointsTableViewControllerSharedInstance = ObtainedPointsTableViewController()
    
    var pointsViewController: PointsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return obtainedPointsArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = CustomerCell(frame: CGRectMake(0, 0, self.view.frame.width, 150), title:obtainedPointsArray[indexPath.row], object: self, row:indexPath.row, section:indexPath.section)
  
        cell.backgroundColor = UIColor.clearColor()
        
        cell.textLabel?.font = UIFont.systemFontOfSize(20)

        
        return cell
    }
    
    
    
    class CustomerCell : UITableViewCell {
        
        var cellButton : UIButton!
        var cellLabel : UILabel!
        
        
        var obtainedpointsTableObject: PointsTableViewController!
        
        var sendName:String!
        
        var tableSection:Int?
        
        var tableRow:Int?
        
        init(frame: CGRect, title:String, object:ObtainedPointsTableViewController, row:Int, section: Int) {
            
            super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "invitecell")
            
            
            sendName = title
            
            cellLabel = UILabel(frame : CGRectMake(50, 5, 250, 80))
            
            
            cellLabel.lineBreakMode = .ByWordWrapping
            cellLabel.numberOfLines = 0
            
            cellLabel.textColor = UIColor.whiteColor()
            
            cellButton = UIButton(frame: CGRectMake(0, 28, 35, 35))
           
            cellButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            let temp = object.obtainedPointsArray[row]
                        
            cellButton.setTitle(String(PointsTableViewController.sharedPointsTableViewControllerInstance.pointstable[title]!), forState: .Normal)
            
            cellLabel.text = title
            
            tableSection = section
            
            tableRow = row
            
            
            addSubview(cellLabel)
            
            addSubview(cellButton)
            
            
        }   
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?){
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
   
}
