//
//  ZLBaseViewController+Notification.h
//  ZLBaseUI
//
//  Created by 朱猛 on 2022/3/5.
//

#import "ZLBaseViewController.h"
@class ZLKeyboardNotificationPayload;

NS_ASSUME_NONNULL_BEGIN

@interface ZLBaseViewController (Notification)

#pragma mark - Notification

- (BOOL) watchApplicationStatusNotification;

- (BOOL) watchKeyboardStatusNotification;

#pragma mark - application status

- (void) applicationDidBecomeActive;

- (void) applicationDidEnterBackground;

- (void) applicationWillResignActive;

- (void) applicationWillEnterForeground;

- (void) applicationWillTerminate;

#pragma mark - keyboard status

- (void) keyboardDidChangeFrame:(ZLKeyboardNotificationPayload *) payload;

- (void) keyboardWillChangeFrame:(ZLKeyboardNotificationPayload *) payload;

- (void) keyboardWillShow:(ZLKeyboardNotificationPayload *) payload;

- (void) keyboardDidShow:(ZLKeyboardNotificationPayload *) payload;

- (void) keyboardWillHide:(ZLKeyboardNotificationPayload *) payload;

- (void) keyboardDidHide:(ZLKeyboardNotificationPayload *) payload;

@end

NS_ASSUME_NONNULL_END
