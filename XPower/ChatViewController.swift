
import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseDatabase
import FirebaseStorage
import GoogleSignIn
import AssetsLibrary
import MediaPlayer
import Parse
extension MPMoviePlayerViewController {
    func test()  {
        self.moviePlayer.stop()
    }   
}




class ChatViewController:JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var displaymessageagain = true
    var handle: UInt = 0
    let storage = FIRStorage.storage()
    var titleString = ""
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var deviceUserIdForOneSignal: String!
    
    var messageQuery:  FIRDatabaseQuery?
    var receiverId:String!
    var receiverName:String!
    let rootRef = FIRDatabase.database().reference()
    var messageRef: FIRDatabaseReference!
    var deviceUserTokenOneSignalRef:FIRDatabaseReference!
    var friendSignalId:String!
    
    //Typing 
    var userIsTypingRef: FIRDatabaseReference! //create a reference that tracks whether the local user is typing
    private var localTyping = false // store whether the local user is typing in a private property
    
    //Query for typing users
    var usersTypingQuery: FIRDatabaseQuery!
    var avatarRef: FIRDatabaseReference!
    
    
    var isTyping: Bool{ //using a computed property, update userIsTypingRef each time you update this property
        get {
            return localTyping
        }
        
        set{
            
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
        
    }
    
    
    //observe isTyping text 
    private func observeTyping(){
        let typingIndicatorRef = rootRef.child("typingIndicator") // creates a reference to the URL /typingIndicator, which is where you'll upate status of user
    
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue() //you can delete this reference once the user left or disconnect using onDisconnectRemoveValue
 
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true) // you initialize the query by retrieving all users who are typing. This is basically saying. "Hey Firebase, go to the key/typing indicators and get me all users for whom the value is true"
        //querying for typing users
        usersTypingQuery.observeEventType(.Value, withBlock: { //observe for changes using .Value; this will give you an upate anytime anything changes.
            data in
            if data.childrenCount == 1 && self.isTyping {  // check if one user and istyping and the local user is typing, do not display the inidicator
                return
            }
            
            self.showTypingIndicator = data.childrenCount > 0 //if more than zero users is typing and local user is not, so scroll to bottom animated to ensure the indicator is displayed
            self.scrollToBottomAnimated(true)
        })
    }
    
    
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        isTyping  = textView.text != ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = receiverName
        setupBubbles()
    
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height: kJSQMessagesCollectionViewAvatarSizeDefault)
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height: kJSQMessagesCollectionViewAvatarSizeDefault)
        messageRef = rootRef.child("messages") 
        avatarRef = rootRef.child("avatars") 
        deviceUserTokenOneSignalRef = rootRef.child("usernameandonesignalid")
    
        let deviceUserItemRef = deviceUserTokenOneSignalRef.childByAutoId()
        
        let query = deviceUserTokenOneSignalRef.queryOrderedByChild("username").queryEqualToValue(receiverId)
    
        query.observeEventType(.ChildAdded, withBlock: {
        
            (snapShot) in
               print(snapShot.value!)        
    })
    observeTyping()
  }
    
   override func didPressAccessoryButton(sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .ActionSheet)
        let photoAction = UIAlertAction(title: "Send photo", style: .Default) { (action) in     
        let imagePickerControllerTest = UIImagePickerController()
            
        imagePickerControllerTest.allowsEditing = true
            
        imagePickerControllerTest.delegate = self
            
            
        self.presentViewController(imagePickerControllerTest, animated: true, completion: nil)
   }
        
        
   let videoAction = UIAlertAction(title: "Send video", style: .Default) { (action) in
           
         let imagePickerControllerTest = UIImagePickerController()
            
         imagePickerControllerTest.allowsEditing = true
            
         imagePickerControllerTest.delegate = self

         imagePickerControllerTest.mediaTypes = ["public.movie"]
               
         self.presentViewController(imagePickerControllerTest, animated: true, completion: nil)
    }
                
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        
        self.presentViewController(sheet, animated: true, completion: nil)
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
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
    
    private func uploadVideotoFirebaseStorage(video:NSURL?){
        let imageName = NSUUID().UUIDString
        let ref = FIRStorage.storage().reference().child("message_videos").child(imageName)

        let assetLibrary = ALAssetsLibrary()
        assetLibrary.assetForURL(video!, resultBlock: {
            asset in
            
            let rep = asset.defaultRepresentation()
            
            var buffer = UnsafeMutablePointer<UInt8>(malloc(Int(rep.size())))
            
            let buffered = rep.getBytes(buffer, fromOffset: 0, length: Int(rep.size()), error: nil)
            
            let videoData = NSData.init(bytesNoCopy: buffer, length: buffered, freeWhenDone: true)
            
            ref.putData(videoData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    self.sendMessageWithImageUrl(imageUrl)
                }
                
            })
           }, failureBlock: {
                
                error in
                print(error)
        })       
    }
    
    private func uploadImagetoFirebaseStorage(image:UIImage){
        
        let imageName = NSUUID().UUIDString
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
       
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    self.sendMessageWithImageUrl(imageUrl)
                }
                
            })
        }
    }
    
    private func sendMessageWithImageUrl(imageUrl:String){
        
        print(imageUrl)
        let itemRef = messageRef.childByAutoId()
        let messageItem = ["text": imageUrl, "senderId":senderId, "receiverId":receiverId]
        
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        isTyping = false
        finishSendingMessage()
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    private func setupBubbles(){
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
    }
    
    func addMessage(id:String, text:String, media:JSQMessageMediaData?)  {
        var message: JSQMessage?
        
        if(media == nil){
           message = JSQMessage(senderId: id, displayName: "", text: text)
        }else {
           message = JSQMessage(senderId: id, displayName: "", media: media)
        }
        
        messages.append(message!)
    } 
  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(handle == 0) {
           observeMessages()
        }
    }
  
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
  
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
     
        if message.senderId == senderId
        {
            return outgoingBubbleImageView
        }else {
            return incomingBubbleImageView   
        } 
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.row]
        let temp = Avatar.avartarImages
        
        if Avatar.avartarImages[message.senderId] == nil {
            
            return JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "defaultavartar"), diameter: 30)
        }
        
        return Avatar.avartarImages[message.senderId]
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
                
        if message.senderId == senderId  && message.isMediaMessage == false {
            
            cell.textView!.textColor = UIColor.whiteColor()
            
            
        }else if (message.senderId != senderId) && message.isMediaMessage == false   {
            
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        let message = messages[indexPath.row]
        let temp = message.media as? JSQVideoMediaItem
        
        if(message.isMediaMessage && (temp?.fileURL.path!.containsString("mov"))!) {
            let movieUrl = temp?.fileURL

            if NSFileManager.defaultManager().fileExistsAtPath(movieUrl!.path!){
            
                  let moviePlayer = MPMoviePlayerViewController.init(contentURL: movieUrl)                  
                  moviePlayer.moviePlayer.controlStyle = MPMovieControlStyle.Default
                
                  moviePlayer.moviePlayer.shouldAutoplay = true
                  self.presentMoviePlayerViewControllerAnimated(moviePlayer)
                                      
                  moviePlayer.moviePlayer.setFullscreen(false, animated: true)   
//                  NSNotificationCenter.defaultCenter().addObserver(moviePlayer, selector: #selector(test), name: MPMoviePlayerDidEnterFullscreenNotification, object: nil)                       
             }
        }
        
     }
    
     override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        let itemRef = messageRef.childByAutoId()
        
        let prefixwordaddornot = self.userDefaults.objectForKey("prefixwords") as? Bool
        
        var messageItem = [String:String!]()
        
        if(prefixwordaddornot != nil && prefixwordaddornot! ){
            messageItem = ["text": "The user \(PFUser.currentUser()!.username!) challenges you to - \n" + text, "senderId":senderId, "receiverId":receiverId]        
        }else{
            messageItem = ["text": text, "senderId":senderId, "receiverId":receiverId]    
        }
        
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        isTyping = false
        
        finishSendingMessage()
    }
    
    
    
    //Synchronizing the Data Source
    
    private func observeMessages(){
       messageQuery = messageRef.queryLimitedToLast(25) //start by synchronization to the last 25 messages
        
       messageQuery!.queryOrderedByChild("receiverId")
       handle =  messageQuery!.observeEventType(.ChildAdded, withBlock: {
            //use the .ChildAdded event to observe for every child item that has been added and will be added at the messages location
            (snapShot) in
        
            let temp = snapShot.value!.objectForKey("receiverId") as! String
            
            let tempSelfName = snapShot.value!.objectForKey("senderId") as! String
            
            if (temp == self.receiverId && tempSelfName == PFUser.currentUser()!.username!) || (temp == PFUser.currentUser()!.username! && tempSelfName == self.receiverId)  {
            
            let id = snapShot.value!.objectForKey("senderId") as! String
            let text = snapShot.value!.objectForKey("text") as! String
               
            if text.containsString("firebasestorage")
            {
                    let url = NSURL(string: text)
                    let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
   
                    if text.containsString("message_images") {
                 
                       var messageMediaData =  JSQPhotoMediaItem(image:UIImage(data: data!))
                        
                       messageMediaData.appliesMediaViewMaskAsOutgoing = false
                        
                       self.addMessage(id, text: text, media: messageMediaData )
                    }else if text.containsString("message_videos") {
                        let dataStr = NSTemporaryDirectory() + "temp.mov"
                        
                        data!.writeToFile(dataStr, atomically:  true)
                        
                        let movieUrl = NSURL(fileURLWithPath: dataStr)   
         
                        self.addMessage(id, text: dataStr, media: JSQVideoMediaItem(fileURL:movieUrl, isReadyToPlay: true))    
                    }
            
             }else{
           
                 self.addMessage(id, text:  text, media: nil) //add new message to data source

            }
        
            self.finishReceivingMessage() //inform JSQMessageViewController that a message has been received   
         }
        })
  
    }
 
}
