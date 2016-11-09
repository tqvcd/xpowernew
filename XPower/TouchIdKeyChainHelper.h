//
//  TouchIdKeyChainHelper.h
//  Dealer
//
//  Created by hua on 6/30/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LoginViewController;

@interface TouchIdKeyChainHelper : NSObject
- (void)addItemAsync:(NSData *)secretCredentialData;
- (void)addTouchIDItemAsync: (NSData *) secretData;
- (NSString *)copyMatchingAsync:(LoginViewController *)loginCon;
- (void)deleteItemAsync;
@end
