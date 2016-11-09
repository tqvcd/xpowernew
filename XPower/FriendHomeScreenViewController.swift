//
//  FriendHomeScreenViewController.swift
//  XPower
//
//  Created by hua on 9/12/16.
//

import UIKit
import Parse
import FirebaseDatabase

class FriendHomeScreenViewController: UIViewController {

    @IBOutlet weak var invitationlabel: UIButton!
    
    var invitationcount:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let img = UIImage(named: "friendhomescreen")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        self.navigationController?.navigationBarHidden = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(myHandler(_:))
        )

        
        invitationcount = UILabel.init(frame: CGRectMake(self.invitationlabel.frame.width + 25, 0, 20, 20))
        invitationcount.textColor = UIColor.whiteColor()
        invitationcount.textAlignment = NSTextAlignment.Center
        invitationcount.text = String(getInvitationNumber())
        invitationcount.layer.borderWidth = 1;
        invitationcount.layer.cornerRadius = 10;
        invitationcount.layer.masksToBounds = true;
        invitationcount.layer.borderColor = UIColor.clearColor().CGColor;
        invitationcount.layer.shadowColor = UIColor.clearColor().CGColor;
        invitationcount.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        invitationcount.layer.shadowOpacity = 0.0;
        invitationcount.backgroundColor = UIColor.orangeColor()
            //UIColor.init(red: 247.0/255.0, green: 45.0/255.0, blue: 143.0/255.0, alpha: 1.0)
        invitationcount.font = UIFont.init(name: "ArialMT", size: 11)
        invitationcount.text = "0"
        
        self.invitationlabel.addSubview(invitationcount)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        getInvitationNumber()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFriendAction(sender: AnyObject) {
        
        let addFriendController = storyboard?.instantiateViewControllerWithIdentifier("addFriend")
        
        self.presentViewController(addFriendController!, animated: true, completion: nil)

        
    }

    @IBAction func gotoFriendListAction(sender: AnyObject) {
        
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewControllerWithIdentifier("friends"))!, animated: true)
        
    }
    
    
    @IBAction func gotoFriendRequestAction(sender: AnyObject) {
        
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewControllerWithIdentifier("invitation"))!, animated: true)
    }
    
    
    
    func myHandler(sender:UIBarButtonItem){  
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

        let rightMenuNavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier("rightmenunavigationcontroller")
        
                    presentViewController(rightMenuNavigationController, animated: true, completion: nil)

    }

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func getInvitationNumber()  {    
        var temp = [String]()
        
        let rootRef = FIRDatabase.database().reference()
        
        let invitationRef = rootRef.child("invitation")
        

        let query = invitationRef.queryOrderedByChild("receivername").queryEqualToValue(PFUser.currentUser()!.username!)
        
        print(PFUser.currentUser()!.username!)
        
        query.observeEventType(.Value, withBlock: {
            snapShot in
            
              let test = (snapShot.value as? NSNull)
            
              if(snapShot.value is NSNull){
                print("snapShotValue is null")
              }
              else{
                let all = (snapShot.value?.allKeys)! as? [String]
                
                print(all?.count)
                //  && ( ( (snapShot.value!["sendEmail"])! as! String) == self.emailTextField.text!)
                

                for a in all! {
                                        
                    let result = snapShot.value!.objectForKey(a)! as! [String:AnyObject]
                    
                    let flag  = result["accepted"]! as! Bool
                    
                    let name = result["sendername"]
                    
                    if(flag == false){
                        
                        temp.append(name! as! String)
                        
                    }
   
                }
                
                self.invitationcount.text = String(temp.count)
                
                self.invitationcount.setNeedsDisplay()
                
            }
 
        })

        self.invitationcount.text = "0"
        
        self.invitationcount.setNeedsDisplay()
            
    }


}
