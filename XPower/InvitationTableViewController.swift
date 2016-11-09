//
//  InvitationTableViewController.swift
//  BarApp
//
//  Created by hua on 8/15/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Parse

class InvitationTableViewController: UITableViewController {

    static var invitationRow = 0
    
    var invitations = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(myHandler(_:))
        )

        
        let img = UIImage(named: "invitation")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
    
        self.navigationController?.navigationBarHidden = false

        
        let rootRef = FIRDatabase.database().reference()
        
        
        let invitationRef = rootRef.child("invitation")
        
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(removeAcceptedorRefusedInvitation), name: "needtoupdatetableview", object: self)
        
        
        let query = invitationRef.queryOrderedByChild("receivername")
        
        query.observeEventType(.ChildAdded, withBlock: {
            
            snapShot in
            
            let receivername =  snapShot.value!.objectForKey("receivername") as! String
            
            let flag = snapShot.value!.objectForKey("accepted") as! Bool
            
            
            if receivername == PFUser.currentUser()!.username! &&  flag == false {
                
                //                let alertView =  UIAlertView.init(title: "", message: "Do you want to add \(self.emailTextField.text!)", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
                //
                //                alertView.show()
                
                self.invitations.append((snapShot.value!.objectForKey("sendername") as! String))
                
                self.tableView.reloadData()
                
            }
            
        })

        
        
        
        
//        let invitationMessage =  ["senderemail": AppDelegate.selfEmailAddress,
//                                  "sendername": AppDelegate.userName, "receiver":self.emailTextField.text!, "receivername":self.friendName]
        
        
        
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
        return invitations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CustomerCell(frame: CGRectMake(0, 0, self.view.frame.width, 150), title:invitations[indexPath.row], object: self, row:indexPath.row)


        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    
    class CustomerCell : UITableViewCell {
        
        var cellButton : UIButton!
        var cellLabel : UILabel!
        
        var cellIndicatorLabel : UILabel!
        var cellMinusButton : UIButton!
        
        var cellPriceValue: Double!
        
        
        var invitationTableObject: InvitationTableViewController!
        
        var sendName:String!
        
        init(frame: CGRect, title:String, object:InvitationTableViewController, row:Int) {
            
            super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "invitecell")
            
            InvitationTableViewController.invitationRow = row
            
            sendName = title
            
            cellLabel = UILabel(frame : CGRectMake(self.frame.width/2, 20, 250, 40))
            
            
            cellLabel.textColor = UIColor.whiteColor()
            
            
            cellLabel.font = UIFont.systemFontOfSize(20)
            
            cellButton = UIButton(frame: CGRectMake(10, 5, 35, 35))
            cellButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            let checkmarkButtonImageView = UIImageView.init(frame: CGRectMake(10, 0, 35, 35))
            
            checkmarkButtonImageView.image = UIImage(named: "checkmark")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)

            
            checkmarkButtonImageView.center = CGPointMake(cellButton.frame.size.width/2, cellButton.frame.size.height/2)
            
            checkmarkButtonImageView.tintColor = UIColor.whiteColor()
            
            cellButton.addSubview(checkmarkButtonImageView)
            
            
            cellButton.addTarget(self, action: #selector(plusIndictorLabel), forControlEvents:UIControlEvents.TouchUpInside)
            
            
           // cellButton.setTitle("Accept", forState: UIControlState.Normal)
            
            
            cellMinusButton = UIButton(frame: CGRectMake(0, 60, 35, 35))
            cellMinusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            cellMinusButton.tag = 11
            
            //            cellMinusButton.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            
            cellMinusButton.addTarget(self, action: #selector(minusIndictorLabel), forControlEvents:UIControlEvents.TouchUpInside)
            
            
            let cancelButtonImageView = UIImageView.init(frame: CGRectMake(10, 0, 35, 35))
            
            cancelButtonImageView.image = UIImage(named: "cancel")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            
            
            checkmarkButtonImageView.center = CGPointMake(cellMinusButton.frame.size.width/2, cellMinusButton.frame.size.height/2)
            
            cancelButtonImageView.tintColor = UIColor.whiteColor()
            
            cellMinusButton.addSubview(cancelButtonImageView)
            
            
            
            
            
            
          //  cellMinusButton.setTitle("Refuse", forState: UIControlState.Normal)
            
            
            cellLabel.text = title
            
            invitationTableObject = object
            
            
            addSubview(cellLabel)
            addSubview(cellButton)
            addSubview(cellMinusButton)
            
            
        }
        
        
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?){
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }
        
        func minusIndictorLabel()  {
            
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "needtoupdatetableview", object: invitationTableObject))
            
            
        }
        
        
        func plusIndictorLabel()  {
            
            
            let rootRef = FIRDatabase.database().reference()
            
            
            let friendRef = rootRef.child("friends")
            
            let friendItemRef = friendRef.childByAutoId()
            
            var friendMessage = ["user": PFUser.currentUser()!.username!, "friend":sendName]
            
            friendItemRef.setValue(friendMessage)
            
            friendMessage = ["user":sendName, "friend": PFUser.currentUser()!.username! ]
            
            let friendItemRefTwo = friendRef.childByAutoId()

            friendItemRefTwo.setValue(friendMessage)

            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "needtoupdatetableview", object: invitationTableObject))
            
            
            
            
        }
        
        
        
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100.0
    }
    
    func removeAcceptedorRefusedInvitation() {
        
        
        let rootRef = FIRDatabase.database().reference()
        
        
        let invitationRef = rootRef.child("invitation")
        
        let query = invitationRef.queryOrderedByChild("invitation")

        
        let invitationcopy = [String](self.invitations)
        
        query.observeEventType(.ChildAdded, withBlock: {
            
            snapShot in
            
            let senderName =  snapShot.value!.objectForKey("sendername") as! String
            
            
            if senderName == invitationcopy[InvitationTableViewController.invitationRow]  {
                
               invitationRef.child(snapShot.key).removeValue()
                
            }
            
        })
        
        
        self.invitations.removeAtIndex(InvitationTableViewController.invitationRow)

        
        self.tableView.reloadData()
        
        
    }
    
    
    func myHandler(sender:UIBarButtonItem){
        
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        
        
        
        let rightMenuNavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier("rightmenunavigationcontroller")
        
        presentViewController(rightMenuNavigationController, animated: true, completion: nil)
        
    }


}


