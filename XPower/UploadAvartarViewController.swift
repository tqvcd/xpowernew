//
//  UploadAvartarViewController.swift
//  XPower
//
//  Created by hua on 9/8/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import Parse

class UploadAvartarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var dismiss:Bool?
    @IBOutlet weak var skipordismissbutton: UIButton!
    @IBOutlet weak var uploadavartar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    uploadavartar.image = UIImage.init(named: "defaultavartar")

        // Do any additional setup after loading the view.

        let img = UIImage(named: "uploadyourimage")
        
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
    
    @IBAction func skipUploadAvartar(sender: AnyObject) {

        if dismiss != nil && dismiss! {
            self.navigationController!.popViewControllerAnimated(true)
            return
            
        }
        
        Avatar.createAvatar(PFUser.currentUser()!.username!, senderDisplayName: "", user: PFUser.currentUser()!, color: UIColor.lightGrayColor())
            
        self.navigationController!.pushViewController(storyboard!.instantiateViewControllerWithIdentifier("homescreen"), animated: true)
    
    }

    @IBAction func uploadAvartartoStorage(sender: AnyObject) {
        
        let imagePickController = UIImagePickerController()
        
        imagePickController.allowsEditing = true
        
        imagePickController.delegate = self
        
        self.presentViewController(imagePickController, animated:true, completion:nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            uploadImagetoFirebaseStorage(selectedImage)
            
        }

        dismissViewControllerAnimated(true, completion: nil)
        
    } 
    
    private func uploadImagetoFirebaseStorage(image:UIImage){
        
        let imageName = NSUUID().UUIDString
        
        let ref = FIRStorage.storage().reference().child("avartarImage").child(imageName)
           
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error)
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.uploadavartar.image = image

                    
                })
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    PFUser.currentUser()!.setValue(true, forKey:"hasavartar" )
                    
                    PFUser.currentUser()!.setValue(imageUrl, forKey: "avartarimageurl")
                    
                    do{
                    try PFUser.currentUser()?.save()
                    }catch{
                        
                        print("update parse user fails")
                    }
                    
                    Avatar.createAvatar(PFUser.currentUser()!.username!, senderDisplayName: "", user: PFUser.currentUser()!, color: UIColor.lightGrayColor())
       
                    if self.dismiss != nil && self.dismiss! {
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                        return
                        
                    }
                  
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.navigationController?.pushViewController((self.storyboard?.instantiateViewControllerWithIdentifier("homescreen"))!, animated: true)
                        
                    })
                    
                    
                }
                
            })
        }

    }

}
