//
//  ZLKeyboardNotificationPayload.h
//  ZLBaseUI
//
//  Created by 朱猛 on 2022/3/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLKeyboardNotificationPayload : NSObject

@property(nonatomic, assign) CGRect beginFrame;

@property(nonatomic, assign) CGRect endFrame;

@property(nonatomic, assign) double duration;              // 动画耗时

@property(nonatomic, assign) UIViewAnimationCurve curve;   

@property(nonatomic, assign) BOOL isLocal;       // 是否为当前APP的键盘

@end

NS_ASSUME_NONNULL_END
