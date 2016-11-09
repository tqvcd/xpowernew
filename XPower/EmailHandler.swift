//
//  EmailHandler.swift
//  BMWDealerApp
//
//  Created by hua on 7/6/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import UIKit
import skpsmtpmessage

class EmailHandler: NSObject, SKPSMTPMessageDelegate {
    
    func sendEmail(bodyMessage: String?, receiver: String?, subject: String?) {
        let confirmEmail = SKPSMTPMessage()
        confirmEmail.subject = subject
        confirmEmail.toEmail = receiver
        confirmEmail.ccEmail = "xpowernew.service@gmail.com"
        confirmEmail.fromEmail = "xpowernew.service@gmail.com"
        confirmEmail.relayHost = "smtp.gmail.com"
        confirmEmail.requiresAuth = true
        confirmEmail.login = "xpowernew.service@gmail.com"
        confirmEmail.pass = "Station1"
        confirmEmail.wantsSecure = true
        confirmEmail.delegate = self
        
        let contentPart:[String:AnyObject] = [kSKPSMTPPartContentTypeKey:"text/plain", kSKPSMTPPartMessageKey: bodyMessage!,
                                  kSKPSMTPPartContentTransferEncodingKey: "8bit"]
        
        confirmEmail.parts = [contentPart]
        
        confirmEmail.send()
  
    }
    
    func messageSent(message: SKPSMTPMessage!) {
        print("Message has send \(message)")
    }
    
    func messageFailed(message: SKPSMTPMessage!, error: NSError!) {
        print("message-\(message) \n error-\(error)")
    }  
    
    static let sharedEmailHandler = EmailHandler()
}
