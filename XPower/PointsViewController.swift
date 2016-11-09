//
//  PointsViewController.swift
//  XPower
//
//  Created by hua on 9/7/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit

class PointsViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var pointstableview: UITableView!

    @IBOutlet weak var obtainedtableview: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    static let pointsViewControllerSharedInstance = PointsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        PointsTableViewController.sharedPointsTableViewControllerInstance.pointsviewController = self
        
        PointsTableViewController.sharedPointsTableViewControllerInstance.thisTableView = pointstableview

        pointstableview.delegate = PointsTableViewController.sharedPointsTableViewControllerInstance
        
        pointstableview.dataSource = PointsTableViewController.sharedPointsTableViewControllerInstance
        pointstableview.backgroundColor = UIColor.clearColor()
        
        
        ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance.pointsViewController = self
        
        
        obtainedtableview.delegate = ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance
        
        obtainedtableview.dataSource = ObtainedPointsTableViewController.obtainedPointsTableViewControllerSharedInstance
        
        obtainedtableview.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
        
        let img = UIImage(named: "addpointsbackground")
        
        let imageView = UIImageView.init(image: img!)
        
        imageView.frame = self.view.bounds
        
        imageView.alpha = 1
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.alpha = 1
        
        self.navigationController!.navigationBarHidden = false
        
    }
    

    @IBAction func pickadateButton(sender: AnyObject) {
        
        self.view.alpha = 0.2
        
        AppDelegate.height = (self.navigationController?.navigationBar.bounds.height)!
        
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var pvc = storyboard.instantiateViewControllerWithIdentifier("modal") as! ModalCalendarViewController
        
        pvc.modalPresentationStyle = UIModalPresentationStyle.Custom
        pvc.transitioningDelegate = self
        
        
        pvc.pointViewController = self
        
        self.presentViewController(pvc, animated: true, completion: nil)
        
        
    }
    
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presentingViewController: source)
    }

}


class HalfSizePresentationController : UIPresentationController {
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return CGRect(x: 0, y:20, width: containerView!.bounds.width, height: containerView!.bounds.height/1)
    }
}
