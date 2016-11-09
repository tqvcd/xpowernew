//
//  PointsTableViewController.swift
//  XPower
//
//  Created by hua on 9/7/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Parse
import Firebase
import FirebaseDatabase
import AFNetworking

extension NSDateFormatter {
    convenience init(dateStyle: NSDateFormatterStyle) {
        self.init()
        self.dateStyle = dateStyle
    }
}


extension NSDate {
    struct Formatter {
        static let longDate = NSDateFormatter.init(dateStyle: .FullStyle)
//        [dateFormatter3 setDateStyle:NSDateFormatterMediumStyle];
//        [dateFormatter3 setDateFormat:@"HH:mm:ss"];
        
    
    }
    var longDate: String {
        
        return Formatter.longDate.stringFromDate(self)
    }
}

class PointsTableViewController: UITableViewController{
    
    var tempArr = [String]()
    
    var thisTableView:UITableView?
    
    var pointsviewController : PointsViewController?
    
    let searchController = UISearchController.init(searchResultsController: nil)
    
    static let sharedPointsTableViewControllerInstance = PointsTableViewController()
    
    var filteredPointsListArray = [String]()
    
    var manager = AFHTTPSessionManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    

    
    
    
    var pointsListArray = [String:[String]]()
        
        //["Water":["Shake your hands (5 points)", "Turn of the sink while brushing teeth (7 points)", "Only turn the sink on ¼ of the way while washing your hands (6 points)", "Use a cloth instead of paper towels (3 points)", "Shower for 5 minutes (25 points)", "Shower for 10 minutes (15 points)", "Shower for 15 minutes (7 points)", "Shower for 20 minutes (3 points)", "Turn your sprinklers on during the evening not morning (15 points)", "Hand wash your car in your lawn (17 points)", "Air-dry your clothes (25 points)", "Switch to a dishwashing powder that’s biodegradable and plantbased (try Ecover Ecological or Trader Joe’s powders) (20 points)", "Cold wash your clothes (15 points)", "Use one water glass per person a day at home (15 points)", "Stick a bucket under the faucet while you wait for your shower water to heat up (use that water for watering your plants) (17 points)"], "Paper":["Borrow books instead of buying them (10 points)", "Print double-sided (7 points)", "Go paperless and do work on your computer (if allowed) (30 points)", "Use recycled napkins (30 points)", "Plant a tree (70 points)", "Start use recycled paper (20 points)"], "Electronics": ["Turn off lights when not in a room (8 points)", "Use led light bulbs (40 points)", "Put on more clothes instead of turning up the heating (18 points)", "Use a rake instead of a leaf blower (25 points)"], "Travel":["Carpool (20 points)", "If you can bike there, do it (25 points)", "Using public transportation (15 points)"], "Recycle":["Packing peanuts to the Plastic Loose Fill Council (20 points)", "Aluminum can ( 5 points)", "Aluminum foil and bakeware (5 points)", "Steel cans and tin cans (5 points)", "Magazine (5 points)", "Office paper (5 points)", "Newspaper (5 points)", "Paper juice and dairy cartons (5 points)", "Paper Board (5 points)", "Retail bags [without hard plastic and string handles] (10 points)", "Paper towel and toilet paper plastic wrap (8 points)", "Paper towel and toilet paper cardboard roll (8 points)", "Plastic newspaper bags (15 points)", "Plastic dry cleaning bags (10 points)", "Plastic Bottles (3 points)", "Glass [bottles, must be see through] (5 points)", "Naked(the drink) bottle (5 points)", "Cereal box [without plastic bag inside] (5 points)", "Coke can or Bottle [must be clean] (5 points)", "Cardboard box (10 points)", "Pizza boxes [clean] (10 points)", "VHS Cassettes to Green Disk (25 points)", "Crayons to Crazy Crayons (25 points)", "Running shoes to Nike’s Reuse - a - shoeor One World Running (30 points)", "Brita Water Filters - drop off at a Whole Foods or send to Preserve Products (20 points)", "Corks to Whole Foods (20 points)", "Mattresses to a mattress recycling center (30 points)", "Bras to Bra Recyclers (25 points)", "Apple products back to an apple store (25 points)", "Vehicles (60 points)", "Glasses to OneSight (30 points)", "Hearing aids to Starkey Hearing Foundation ( 40 points)", "Five Batteries to a Radio Shack or Office Depot (20 points)", "Backpacks to American Birding Association (30 points)", "Old phones with Call2Recycle.org or The wireless Foundation or any local store (30 points)", "All clean, clear bags labeled with a #1 or #2 or #4 (8 points)", "Any other recyclable objects (8 points)"], "Reuse" : ["Use a ceramic mug or a coffee mug instead of disposable cups [per day] (5 points)", "Upcycle clean and reuse [ Glass Jars, Grocery bags, Containers or Cans, Gallon Jugs, Plastic Soda Bottles, Takeout and Other Plastic Containers, Newspapers, Magazines, Paper/Plastic Bags, Clothes and Towels] (25 points)", "Get a recyclable water bottle (10 points) → after being added once cannot be added again", "Buy items with no to minimal packaging when grocery shopping (10 points)", "Reuse pasta water [use to water plants after cooled down] ( 7 points)"], "Others" : ["Don’t eat meat one day a week (15 points)", "Compost leftovers and napkins (7 points)", "Buy local foods grown in that season in your area (20 points)", "Use biodegradable cat litter or golf balls (20 points)", "Use nontoxic cleaning products (30 points)"] ]
    
    var pointstable = [String:Int]()
        //["Shake your hands (5 points)" : 5, "Turn of the sink while brushing teeth (7 points)" : 7, "Only turn the sink on ¼ of the way while washing your hands (6 points)" : 6, "Use a cloth instead of paper towels (3 points)" : 3, "Shower for 5 minutes (25 points)" : 25, "Shower for 10 minutes (15 points)" : 15, "Shower for 15 minutes (7 points)" : 7, "Shower for 20 minutes (3 points)" : 3, "Turn your sprinklers on during the evening not morning (15 points)" : 15, "Hand wash your car in your lawn (17 points)" : 17, "Air-dry your clothes (25 points)" : 25, "Switch to a dishwashing powder that’s biodegradable and plantbased (try Ecover Ecological or Trader Joe’s powders) (20 points)" : 20, "Cold wash your clothes (15 points)" : 15, "Use one water glass per person a day at home (15 points)" : 15, "Stick a bucket under the faucet while you wait for your shower water to heat up (use that water for watering your plants) (17 points)" : 17, "Borrow books instead of buying them (10 points)" : 10, "Print double-sided (7 points)" : 7, "Go paperless and do work on your computer (if allowed) (30 points)" : 30, "Use recycled napkins (30 points)" : 30, "Plant a tree (70 points)" : 70, "Start use recycled paper (20 points)" : 20, "Turn off lights when not in a room (8 points)" : 8,  "Use led light bulbs (40 points)" : 40, "Put on more clothes instead of turning up the heating (18 points)" : 18, "Use a rake instead of a leaf blower (25 points)" : 25, "Carpool (20 points)" : 20, "If you can bike there, do it (25 points)" : 25, "Using public transportation (15 points)" : 15, "Packing peanuts to the Plastic Loose Fill Council (20 points)" : 20, "Aluminum can ( 5 points)" : 5, "Aluminum foil and bakeware (5 points)" : 5, "Steel cans and tin cans (5 points)" : 5, "Magazine (5 points)" : 5, "Office paper (5 points)" : 5, "Newspaper (5 points)" : 5, "Paper juice and dairy cartons (5 points)" : 5, "Paper Board (5 points)" : 5, "Retail bags [without hard plastic and string handles] (10 points)" : 10, "Paper towel and toilet paper plastic wrap (8 points)" : 8, "Paper towel and toilet paper cardboard roll (8 points)" : 8, "Plastic newspaper bags (15 points)" : 15, "Plastic dry cleaning bags (10 points)" : 10, "Plastic Bottles (3 points)" : 3, "Glass [bottles, must be see through] (5 points)" : 5, "Naked(the drink) bottle (5 points)" : 5, "Cereal box [without plastic bag inside] (5 points)" : 5, "Coke can or Bottle [must be clean] (5 points)" : 5, "Cardboard box (10 points)" : 10, "Pizza boxes [clean] (10 points)" : 10, "VHS Cassettes to Green Disk (25 points)" : 25, "Crayons to Crazy Crayons (25 points)" : 25, "Running shoes to Nike’s Reuse - a - shoeor One World Running (30 points)" : 30, "Brita Water Filters - drop off at a Whole Foods or send to Preserve Products (20 points)" : 20, "Corks to Whole Foods (20 points)" : 20, "Mattresses to a mattress recycling center (30 points)" : 30, "Bras to Bra Recyclers (25 points)" : 25, "Apple products back to an apple store (25 points)" : 25, "Vehicles (60 points)" : 60, "Glasses to OneSight (30 points)" : 30, "Hearing aids to Starkey Hearing Foundation ( 40 points)" : 40, "Five Batteries to a Radio Shack or Office Depot (20 points)" : 20, "Backpacks to American Birding Association (30 points)" : 30, "Old phones with Call2Recycle.org or The wireless Foundation or any local store (30 points)" : 30, "All clean, clear bags labeled with a #1 or #2 or #4 (8 points)" : 8, "Any other recyclable objects (8 points)" : 8, "Use a ceramic mug or a coffee mug instead of disposable cups [per day] (5 points)" : 5, "Upcycle clean and reuse [ Glass Jars, Grocery bags, Containers or Cans, Gallon Jugs, Plastic Soda Bottles, Takeout and Other Plastic Containers, Newspapers, Magazines, Paper/Plastic Bags, Clothes and Towels] (25 points)" : 25, "Get a recyclable water bottle (10 points) → after being added once cannot be added again" : 10, "Buy items with no to minimal packaging when grocery shopping (10 points)" : 10, "Reuse pasta water [use to water plants after cooled down]  7 points)" : 7, "Don’t eat meat one day a week (15 points)" : 15, "Compost leftovers and napkins (7 points)" : 7, "Buy local foods grown in that season in your area (20 points)" : 20, "Use biodegradable cat litter or golf balls (20 points)" : 20, "Use nontoxic cleaning products (30 points)" : 30 ]


    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.clearColor()
        
    }
    
    
    
    
    func filterContentForSearchText(searchText:String, scope: String = "All")  {
        filteredPointsListArray = Array(pointstable.keys).filter{
            name in
            return name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        thisTableView!.reloadData()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        thisTableView!.tableHeaderView = searchController.searchBar
        
        if searchController.active && searchController.searchBar.text != "" {
            
            return 1
        }

        return pointsListArray.keys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searchController.active && searchController.searchBar.text != "" {
            
            return filteredPointsListArray.count
        }
        
        return pointsListArray[Array(pointsListArray.keys)[section]]!.count
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:CustomerCell
        
        if searchController.active && searchController.searchBar.text != "" {
            cell = CustomerCell(frame: CGRectMake(0, 0, self.view.frame.width, 150), title:filteredPointsListArray[indexPath.row], object: self, row:indexPath.row, section:indexPath.section)
            
        }else{

        
        // Configure the cell...
          cell = CustomerCell(frame: CGRectMake(0, 0, self.view.frame.width, 150), title:pointsListArray[Array(pointsListArray.keys)[indexPath.section]]![indexPath.row], object: self, row:indexPath.row, section:indexPath.section)
       
        }
        cell.textLabel?.font = UIFont.systemFontOfSize(20)

        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(self.pointsListArray.keys)[section]
    }
    
    class CustomerCell : UITableViewCell {
        
        var cellButton : UIButton!
        
        var cellLabel : UILabel!
        
        var pointsTableObject: PointsTableViewController!
        
        var sendName:String!
        
        var tableSection:Int?
        
        var tableRow:Int?
        
        
        init(frame: CGRect, title:String, object:PointsTableViewController, row:Int, section: Int) {
            
            super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "invitecell")
            
            sendName = title
            
            cellLabel = UILabel(frame : CGRectMake(50, 10, 250, 80))
            
            cellLabel.lineBreakMode = .ByWordWrapping
            
            cellLabel.numberOfLines = 0
            
            cellLabel.textColor = UIColor.whiteColor()
            
            cellButton = UIButton(frame: CGRectMake(0, 28, 35, 35))
            
            cellButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            cellButton.addTarget(self, action: #selector(plusIndictorLabel), forControlEvents:UIControlEvents.TouchUpInside)
            
            let pointsImageView = UIImageView.init(frame: CGRectMake(0, 0, 35, 35))
            pointsImageView.image = UIImage(named: "points")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            
            pointsImageView.center = CGPointMake(cellButton.frame.size.width/2, cellButton.frame.size.height/2)
            
            pointsImageView.tintColor = UIColor.whiteColor()
            
            cellButton.addSubview(pointsImageView)
            
            cellLabel.text = title
            
            tableSection = section
            
            tableRow = row
            
            pointsTableObject = object
            
            addSubview(cellLabel)
            addSubview(cellButton)
            
            
        }
        
        
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?){
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }
        
        
        
       func plusIndictorLabel()  {
        
          pointsTableObject.pointsviewController?.obtainedtableview.beginUpdates()
        
          ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance.obtainedPointsArray.insert(sendName, atIndex: 0)
//        (pointsTableObject.pointsListArray[Array(pointsTableObject.pointsListArray.keys)[tableSection!]]![tableRow!], atIndex: 0)
        
//             ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance.obtainedPointsArray.insert(pointsTableObject.pointsListArray[Array(pointsTableObject.pointsListArray.keys)[tableSection!]]![tableRow!], atIndex: 0)
        
            AppDelegate.totalScoreLoad = false
            

            
          let alertView = UIAlertView.init(title: "Add Points!", message:sendName , delegate: nil, cancelButtonTitle: nil)
            
          alertView.show()
            
          let delay = 2 * Double(NSEC_PER_SEC)
          var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
          dispatch_after(time, dispatch_get_main_queue(), {
                alertView.dismissWithClickedButtonIndex(-1, animated: true)
          })
            
          pointsTableObject.pointsviewController?.obtainedtableview.reloadData()
          let newIndexPath = NSIndexPath(forRow: 0, inSection: 0)
 
          pointsTableObject.pointsviewController?.obtainedtableview.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)  
            
          pointsTableObject.pointsviewController?.obtainedtableview.endUpdates()
        
           let dateFormatter = NSDateFormatter()
        
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
            var dateString = dateFormatter.stringFromDate(NSDate())
        
        
            var paramsUserAddDeeds = ["user":PFUser.currentUser()!.username!, "deed":sendName, "date":dateString]

            let manager = AFHTTPSessionManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        
           manager.POST("http://www.consoaring.com/PointService.svc/adddeeds", parameters: paramsUserAddDeeds, success: {
                        (task, response) in
                        print(response)
        
                        }, failure: {
                            (task, error) in
                            print(error.localizedDescription)
                            
            })

        
        
           
          let rootRef = FIRDatabase.database().reference()
            
          let schoolTotalScore = rootRef.child("schooltotalscore")
            
          let schooltotalScoreItem = schoolTotalScore.childByAutoId()
            
          let totalScore = rootRef.child("totalScore")
            
          let totalScoreItem = totalScore.childByAutoId()
                    
          var totalScoreMessage = ["useremail": PFUser.currentUser()!.email!, "totalscore": String(pointsTableObject.pointstable[sendName]!), "name": sendName, "schoolname": PFUser.currentUser()!.objectForKey("schoolname") as! String, "date":String(NSDate().timeIntervalSince1970)]
                        
          totalScoreItem.setValue(totalScoreMessage)
            
          schoolTotalScore.setValue(totalScoreMessage)
        
        }
  
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    
        view.tintColor = UIColor.clearColor()
        
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.whiteColor()
        
    }

}

extension PointsTableViewController: UISearchResultsUpdating{
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
