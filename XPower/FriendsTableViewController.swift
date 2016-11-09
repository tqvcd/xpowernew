//
//  FriendsTableViewController.swift
//  BarApp
//
//  Created by hua on 8/14/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Parse
import JSQMessagesViewController

class FriendsTableViewController: UITableViewController {

    var friends = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let img = UIImage(named: "friendtable")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        self.navigationController?.navigationBarHidden = false 
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(myHandler(_:))
        )
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
//        self.tabBarController!.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(editButtonItem(_:)))
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
//        self.tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(addItem))
        
        super.viewWillAppear(animated)
        
        let rootRef = FIRDatabase.database().reference()
        
        let friendRef = rootRef.child("friends")
        
        let query = friendRef.queryOrderedByChild("user")
        
        query.observeEventType(.Value, withBlock: {
            
            snapShot in
            
            if !(snapShot.value is NSNull)
            {
            
            let all = (snapShot.value?.allKeys)! as? [String]
            
            
            for a in all! {
                
                let result = snapShot.value!.objectForKey(a) as! [String:String]
                
                let user = result["user"]
                
                if user ==  PFUser.currentUser()!.username!{
                    
                    let temp = result["friend"]
                    
                    if !self.friends.contains(temp!){
                        
                        self.friends.append(temp!)
                    }
                    
                    
                }
                
                self.tableView.reloadData()
            }
                
            }
            
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
        return self.friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("friendcell", forIndexPath: indexPath)

        
        let cell = CustomerCell.init(frame: CGRectMake(0, 0, self.view.frame.width, 150), title: "", friends: self.friends, row: indexPath.row, indexPath: indexPath, friendTableObject: self)
        
        // Configure the cell...
        
        //cell.textLabel?.text = self.friends[indexPath.row]
        
        cell.backgroundColor = UIColor.clearColor()

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    

    func gotoChatView(indexPath:NSIndexPath, prefixWords:String){
        
        
        let avatarRef = FIRDatabase.database().reference().child("avatars")
        
        let query = avatarRef.queryOrderedByChild("id").queryEqualToValue(self.friends[indexPath.row]).observeEventType(.Value, withBlock: {
            
            snapShot in
            
            
            if snapShot.value is NSNull?
            {
                
               
                return
            }
            
            let all = snapShot.value!.allKeys! as! [String]
            
//            if all.count == 0 {
//                
//                
//                
//                 Avatar.avartarImages[self.friends[indexPath.row]] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "defaultavartar"), diameter: 30)
//                    
//                
//                
//            }
            
            for a in all {
                
                let result = snapShot.value?.objectForKey(a) as! [String:String]
                
                let receiverData = NSData(contentsOfURL: NSURL(string: result["imageurl"]!)!)!
                
                
                Avatar.avartarImages[result["id"]!] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: receiverData), diameter: 30)
                    
                
                
                ImageCache.sharedCache.setObject(UIImage(data: receiverData)!, forKey: result["id"]!, cost:receiverData.length)
                
            }
            
        })

        
        
        
        
        
        
        
        
       avatarRef.queryOrderedByChild("id").queryEqualToValue(PFUser.currentUser()!.username!).observeEventType(.Value, withBlock: {
            
            snapShot in
            
            
            if snapShot.value is NSNull?
            {
                
                
                return
            }
            
            let all = snapShot.value!.allKeys! as! [String]
            
            //            if all.count == 0 {
            //
            //
            //
            //                 Avatar.avartarImages[self.friends[indexPath.row]] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "defaultavartar"), diameter: 30)
            //
            //
            //
            //            }
            
            for a in all {
                
                let result = snapShot.value?.objectForKey(a) as! [String:String]
                
                let receiverData = NSData(contentsOfURL: NSURL(string: result["imageurl"]!)!)!
                
                
                Avatar.avartarImages[result["id"]!] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: receiverData), diameter: 30)
                
                
                
                ImageCache.sharedCache.setObject(UIImage(data: receiverData)!, forKey: result["id"]!, cost:receiverData.length)
                
            }
            
        })

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let messageController = self.storyboard!.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        
        messageController.senderId = PFUser.currentUser()!.username!
            
        messageController.receiverId =  self.friends[indexPath.row]
        
   
        
//        Avatar.createAvatar(messageController.receiverId, senderDisplayName: "", user: nil, color: UIColor.lightGrayColor())
        
//        messageController.deviceUserIdForOneSignal = AppDelegate.getDeviceUserTokenId()
        
        messageController.senderDisplayName = PFUser.currentUser()!.username!
        
        messageController.receiverName =  self.friends[indexPath.row]
        
        self.navigationController?.pushViewController(messageController, animated: true)

        
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
    
    func editButtonItem(send:UIBarButtonItem)  {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
        
        if(self.tableView.editing){
            self.tabBarController!.navigationItem.leftBarButtonItem!.title = "Done"
        }else{
            self.tabBarController!.navigationItem.leftBarButtonItem!.title = "Edit"
        }
        
    }
    
//    func addItem() {
//        let addFriendController = storyboard?.instantiateViewControllerWithIdentifier("addFriend")
//        
//        self.presentViewController(addFriendController!, animated: true, completion: nil)
//    }
    
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        
//        if(alertView.tag == 100 && buttonIndex == 1){
//            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
//            
//            self.navigationController?.pushViewController(viewController, animated: true)
//            
//        }else if (alertView.tag == 100 && buttonIndex == 0) {
//            
//            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
//            
//            self.navigationController?.pushViewController(viewController, animated: true)
//            
//        }
//  }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.tabBarController!.navigationItem.rightBarButtonItem = nil
    }
    
    

    class CustomerCell : UITableViewCell {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()

        
        var messageButton : UIButton!
        
        var cellLabel : UILabel!
        
        var challengeButton : UIButton!
        
        var indexP:NSIndexPath?
        
        var friendObject:FriendsTableViewController?
        
        init(frame: CGRect, title:String, friends:[String], row:Int, indexPath:NSIndexPath, friendTableObject:FriendsTableViewController) {
            
            super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "customerchatcell")
            
            
            self.friendObject = friendTableObject
            self.indexP = indexPath
            
            cellLabel = UILabel(frame : CGRectMake(40, 30, 120, 40))
            
            
            cellLabel.textColor = UIColor.whiteColor()
            
            cellLabel.font = UIFont.systemFontOfSize(20)

        
            cellLabel.text = friends[row]
            
            
            
//            messageButton = UIButton(frame: CGRectMake(self.frame.width/2, 5, 35, 35))
//            messageButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//            
//            messageButton.titleLabel?.text = "Message"
//            
            
            
            
            // cellButton.setTitle("Accept", forState: UIControlState.Normal)
            
            messageButton = UIButton(frame: CGRectMake(self.frame.width/2+20, 30, 80, 35))
            messageButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
//            let checkmarkButtonImageView = UIImageView.init(frame: CGRectMake(10, 0, 35, 35))
//            
//            checkmarkButtonImageView.image = UIImage(named: "checkmark")!
//            
//            checkmarkButtonImageView.center = CGPointMake(messageButton.frame.size.width/2, messageButton.frame.size.height/2)
//            
//            messageButton.addSubview(checkmarkButtonImageView)
            
            messageButton.setTitle("message", forState: UIControlState.Normal)

            
            messageButton.addTarget(self, action: #selector(messageButtonAction), forControlEvents:UIControlEvents.TouchUpInside)
            
            
            
            
            
            
            
            
            
            
            
            challengeButton = UIButton(frame: CGRectMake(self.frame.width/2 + 140, 30, 80, 35))
            challengeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            challengeButton.setTitle("challenge", forState: UIControlState.Normal)
            
            
            //  cellMinusButton.setTitle("Refuse", forState: UIControlState.Normal)
            
            challengeButton.addTarget(self, action: #selector(challengeButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            
            addSubview(cellLabel)
            addSubview(messageButton)
            addSubview(challengeButton)
            
            
        }
        
        
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?){
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }
        
        func challengeButtonAction()  {
            
            self.friendObject?.gotoChatView(self.indexP!, prefixWords:"")
            
            userDefaults.setObject(true, forKey: "prefixwords")

            
        }
        
        
        func messageButtonAction()  {
            
            self.friendObject!.gotoChatView(self.indexP!,prefixWords: "The user \(PFUser.currentUser()!.username!) challenges you to - \n")
            
            userDefaults.setObject(false, forKey: "prefixwords")
            
//            let rootRef = FIRDatabase.database().reference()
//            
//            
//            let friendRef = rootRef.child("friends")
//            
//            let friendItemRef = friendRef.childByAutoId()
//            
//            var friendMessage = ["user": PFUser.currentUser()!.username!, "friend":sendName]
//            
//            friendItemRef.setValue(friendMessage)
//            
//            friendMessage = ["user":sendName, "friend": PFUser.currentUser()!.username! ]
//            
//            let friendItemRefTwo = friendRef.childByAutoId()
//            
//            friendItemRefTwo.setValue(friendMessage)
//            
//            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "needtoupdatetableview", object: invitationTableObject))
            
            
            
            
        }
        
        
        
        
    }
    
    
    func myHandler(sender:UIBarButtonItem){
        
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        
        
        
        let rightMenuNavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier("rightmenunavigationcontroller")
        
        presentViewController(rightMenuNavigationController, animated: true, completion: nil)
        
    }


    

}
