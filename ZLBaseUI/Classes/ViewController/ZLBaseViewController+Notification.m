//
//  ZLBaseViewController+Notification.m
//  ZLBaseUI
//
//  Created by 朱猛 on 2022/3/5.
//

#import "ZLBaseViewController+Notification.h"
#import "ZLKeyboardNotificationPayload.h"

@implementation ZLBaseViewController (Notification)

#pragma mark -

- (BOOL) watchApplicationStatusNotification {
    return NO;
}

- (BOOL) watchKeyboardStatusNotification {
    return NO;
}


#pragma mark -

- (void) applicationDidBecomeActive {
    
}

- (void) applicationDidEnterBackground {
    
}

- (void) applicationWillResignActive {
    
}

- (void) applicationWillEnterForeground {
    
}

- (void) applicationWillTerminate {
    
}

#pragma mark -

- (void) keyboardDidChangeFrame:(ZLKeyboardNotificationPayload *) payload {
    
}

- (void) keyboardWillChangeFrame:(ZLKeyboardNotificationPayload *) payload {
    
}

- (void) keyboardWillShow:(ZLKeyboardNotificationPayload *) payload {
    
}

- (void) keyboardDidShow:(ZLKeyboardNotificationPayload *) payload {
    
}

- (void) keyboardWillHide:(ZLKeyboardNotificationPayload *) payload {
    
}

- (void) keyboardDidHide:(ZLKeyboardNotificationPayload *) payload {
    
}

@end
