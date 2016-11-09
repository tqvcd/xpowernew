//
//  Avartar.swift
//  BarApp
//
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import JSQMessagesViewController
import Parse

class Avatar {
    
    static var avartarImages = [String:JSQMessagesAvatarImage]()

    static let rootRef = FIRDatabase.database().reference()
    
    static var avatarRef: FIRDatabaseReference!

    class func createAvatar(senderId:String, senderDisplayName:String, user:PFUser?, color:UIColor)  {
        avatarRef = rootRef.child("avatars")
        
        let ref = FIRStorage.storage().reference().child("avatarimages").child(senderId)
        
        if avartarImages[senderId] != nil {
            
            avartarImages.removeValueForKey(senderId)
            
        }
        
        if avartarImages[senderId] == nil {
            
             if user != nil && (user!.objectForKey("hasavartar")! as! Bool) {
                
                let pic = NSURL.init(string:  user!.objectForKey("avartarimageurl")! as! String)         
                
                let data = NSData(contentsOfURL: pic!)
                
                            avartarImages[senderId] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: data!), diameter: 30)
                
                
               ImageCache.sharedCache.setObject(UIImage(data: data!)!, forKey: senderId, cost:data!.length)
                
               avatarRef.queryOrderedByChild("id").queryEqualToValue(senderId).observeEventType(.Value, withBlock: {
                    
                    snapShot in
                    
                    if snapShot.value is NSNull {
                        if let uploadData = UIImageJPEGRepresentation(UIImage(data:data!)!, 0.2) {
                            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                
                                if error != nil {
                                    print("Failed to upload image:", error)
                                    return
                                }
                                
                                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                                    
                                    let avatarItemRef = self.avatarRef.childByAutoId()
                                    
                                    let avatarItem = ["id":senderId, "imageurl":imageUrl]
                                                                        
                                    let query =   avatarRef.queryOrderedByChild("id").queryEqualToValue(senderId).observeEventType(.Value, withBlock: {
                                        snapShot in
                                        if snapShot.value is NSNull? {
                                            
                                            avatarRef.child(snapShot.key).removeValue()
                                            
                                            avatarItemRef.setValue(avatarItem)
                                        }                                    
                                    })         
                                }                              
                            })
                        }
                    }else{                                               
                        let avatarItem = ["id":senderId, "imageurl":user!.objectForKey("avartarimageurl")!]
                        
                        let all = (snapShot.value?.allKeys)! as? [String]

                        avatarRef.child(all![0]).setValue(avatarItem)
                    }    
                })
            }else if user != nil && (user!.objectForKey("hasavartar")! as! Bool) == false {
                 
                self.avartarImages[senderId] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named:"defaultavartar"), diameter: 30)
                     
                ImageCache.sharedCache.setObject(UIImage(named:"defaultavartar")!, forKey: senderId, cost:(UIImageJPEGRepresentation(UIImage(named: "defaultavartar")!, 1)?.length)!)
                        
          }
         } 
        }
    }

    
    
