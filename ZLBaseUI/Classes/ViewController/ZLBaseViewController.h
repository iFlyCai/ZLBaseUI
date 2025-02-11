//
//  ZLBaseViewController.h
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLBaseViewModel.h"

@interface ZLBaseViewController : UIViewController <ZLBaseViewModel>


@property (nonatomic, assign) BOOL isDebug; // 添加 isDebug 属性

@end


