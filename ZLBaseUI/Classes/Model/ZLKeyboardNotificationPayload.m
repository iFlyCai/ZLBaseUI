//
//  ZLKeyboardNotificationPayload.m
//  ZLBaseUI
//
//  Created by 朱猛 on 2022/3/5.
//

#import "ZLKeyboardNotificationPayload.h"

@implementation ZLKeyboardNotificationPayload

- (instancetype)init {
    if(self = [super init]) {
        self.beginFrame = CGRectZero;
        self.endFrame = CGRectZero;
        self.duration = 0;
        self.curve = UIViewAnimationCurveEaseInOut;
    }
    return self;
}

@end
