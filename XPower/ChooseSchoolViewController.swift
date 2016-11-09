//
//  ChooseSchoolViewController.swift
//  XPower
//
//  Created by hua on 9/7/16.
//

import UIKit

class ChooseSchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var schoolNames: UITableView!
    
    let schoolNamesArray = ["Haverford", "Agnes Irwin School"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let img = UIImage(named: "chooseyourschool")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)

        
        
        self.navigationController!.navigationBarHidden = false

        
        schoolNames.delegate = self
        schoolNames.dataSource = self

        schoolNames.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        schoolNames.separatorStyle = UITableViewCellSeparatorStyle.None
        // Do any additional setup after loading the view.
        
        self.schoolNames.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.font = UIFont.systemFontOfSize(20)

        cell.textLabel?.text = schoolNamesArray[indexPath.row]
        
        AppDelegate.schoolName = schoolNamesArray[indexPath.row]
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.indentationLevel = 10
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        AppDelegate.schoolName = schoolNamesArray[indexPath.row]

        self.navigationController?.pushViewController((storyboard?.instantiateViewControllerWithIdentifier("signup"))!, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
