//
//  TouchIdKeyChainHelper.m
//  Dealer
//
//  Created by hua on 6/30/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

#import "TouchIdKeyChainHelper.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "XPower-Swift.h"

@implementation TouchIdKeyChainHelper


- (NSString *)copyMatchingAsync:(LoginViewController *)loginCon {
    __block NSString * returnValue = NULL;
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: @"SampleService",
                            (__bridge id)kSecReturnData: @YES,
                            (__bridge id)kSecUseOperationPrompt: @"Authenticate to access service password",
                            };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CFTypeRef dataTypeRef = NULL;
        NSString *message;
        
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &dataTypeRef);
        if (status == errSecSuccess) {
            NSData *resultData = (__bridge_transfer NSData *)dataTypeRef;
            
            NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
            
            message = [NSString stringWithFormat:@"Result: %@\n", result];
            
            
            
                NSArray *namePassword = [result componentsSeparatedByString:@" "];
            
                NSString *nameStr = NULL;
            
                NSString *passwordStr = NULL;
            
                if([namePassword count] > 1){
                    nameStr = namePassword[1];
                    passwordStr = namePassword[0];
                    [loginCon loginUsingTouchId:nameStr passwordStr: passwordStr];
                    
                
                }
            
            returnValue = result;
        }
        else {
            message = [NSString stringWithFormat:@"SecItemCopyMatching status: %@", [self keychainErrorToString:status]];
        }
        
       // NSLog(@"%@", message);
    });
    
    return returnValue;
}


- (void)updateItemAsync {
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: @"SampleService",
                            (__bridge id)kSecUseOperationPrompt: @"Authenticate to update your password"
                            };
    
    NSData *updatedSecretPasswordTextData = [@"UPDATED_SECRET_PASSWORD_TEXT" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *changes = @{
                              (__bridge id)kSecValueData: updatedSecretPasswordTextData
                              };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)changes);
        
//        NSString *errorString = [self keychainErrorToString:status];
//        NSString *message = [NSString stringWithFormat:@"SecItemUpdate status: %@", errorString];
       // NSLog(message);
        
        
    });
}

- (void)addItemAsync:(NSData *)secretCredentialData {
    CFErrorRef error = NULL;
    
    // Should be the secret invalidated when passcode is removed? If not then use kSecAttrAccessibleWhenUnlocked
    SecAccessControlRef sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                                    kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                                    kSecAccessControlUserPresence, &error);
    
    if (sacObject == NULL || error != NULL) {
        NSString *errorString = [NSString stringWithFormat:@"SecItemAdd can't create sacObject: %@", error];
        
        NSLog(@"%@", errorString);
        return;
    }
    
    // we want the operation to fail if there is an item which needs authentication so we will use
    // kSecUseNoAuthenticationUI
    NSDictionary *attributes = @{
                                 (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                 (__bridge id)kSecAttrService: @"SampleService",
                                 (__bridge id)kSecValueData: [@"SECRET_PASSWORD_TEXT" dataUsingEncoding:NSUTF8StringEncoding],
                                 (__bridge id)kSecUseNoAuthenticationUI: @YES,
                                 (__bridge id)kSecAttrAccessControl: (__bridge_transfer id)sacObject
                                 };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSStatus status =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
        
       // NSString *errorString = [self keychainErrorToString:status];
      //  NSString *message = [NSString stringWithFormat:@"SecItemAdd status: %@", errorString];
       
       // NSLog(@"%@", message);
        
    });
}

- (void)addTouchIDItemAsync: (NSData *) secretData{
    CFErrorRef error = NULL;
    
    // Should be the secret invalidated when passcode is removed? If not then use kSecAttrAccessibleWhenUnlocked
    SecAccessControlRef sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                                    kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                                    kSecAccessControlTouchIDAny, &error);
    if (sacObject == NULL || error != NULL) {
        NSString *errorString = [NSString stringWithFormat:@"SecItemAdd can't create sacObject: %@", error];
        
        NSLog(@"%@", errorString);
        return;
    }
    
    /*
     We want the operation to fail if there is an item which needs authentication so we will use
     `kSecUseNoAuthenticationUI`.
     */
   
    NSDictionary *attributes = @{
                                 (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                 (__bridge id)kSecAttrService: @"SampleService",
                                 (__bridge id)kSecValueData: secretData,
                                 (__bridge id)kSecUseNoAuthenticationUI: @YES,
                                 (__bridge id)kSecAttrAccessControl: (__bridge_transfer id)sacObject
                                 };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSStatus status =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
//        
//        NSString *message = [NSString stringWithFormat:@"SecItemAdd status: %@", [self keychainErrorToString:status]];
        
       // NSLog(@"%@", message);
    });
}


- (void)deleteItemAsync {
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: @"SampleService"
                            };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
        
       // NSString *errorString = [self keychainErrorToString:status];
//        NSString *message = [NSString stringWithFormat:@"SecItemDelete status: %@", errorString];
        
       // NSLog(@"%@", message);
        
    });
}


#pragma mark - Tools

- (NSString *)keychainErrorToString:(OSStatus)error {
    NSString *message = [NSString stringWithFormat:@"%ld", (long)error];
    
    switch (error) {
        case errSecSuccess:
            message = @"success";
            break;
            
        case errSecDuplicateItem:
            message = @"error item already exists";
            break;
            
        case errSecItemNotFound :
            message = @"error item not found";
            break;
            
        case errSecAuthFailed:
            message = @"error item authentication failed";
            break;
            
        default:
            break;
    }
    
    return message;
}

@end
