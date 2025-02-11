//
//  ZLFirstViewController.m
//  ZLBaseUI_Example
//
//  Created by iFlyCai on 2025/2/12.
//  Copyright © 2025 ExistOrLive. All rights reserved.
//

#import "ZLFirstViewController.h"

@interface ZLFirstViewController ()

@end

@implementation ZLFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"First Page";

    // 创建切换到暗黑模式的按钮
    UIButton *darkModeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    darkModeButton.frame = CGRectMake(50, 100, 200, 50);
    [darkModeButton setTitle:@"Switch to Dark Mode" forState:UIControlStateNormal];
    [darkModeButton addTarget:self action:@selector(switchToDarkMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:darkModeButton];

    // 创建切换到白天模式的按钮
    UIButton *lightModeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    lightModeButton.frame = CGRectMake(50, 200, 200, 50);
    [lightModeButton setTitle:@"Switch to Light Mode" forState:UIControlStateNormal];
    [lightModeButton addTarget:self action:@selector(switchToLightMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightModeButton];
}

- (void)switchToDarkMode {
    // 全局切换到暗黑模式
    if (@available(iOS 13.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }
}

- (void)switchToLightMode {
    // 全局切换到白天模式
    if (@available(iOS 13.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

@end
