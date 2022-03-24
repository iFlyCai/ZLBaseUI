//
//  ZLBaseNavigationController.m
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import "ZLBaseNavigationController.h"

@interface ZLBaseNavigationController () <UIGestureRecognizerDelegate>
{
    UIScreenEdgePanGestureRecognizer * _ScreenEdgePanGestureRecognizer;
}

@end

@implementation ZLBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCustomPopGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIPanGestureRecognizer *) zlInteractivePopGestureRecognizer {
    return _ScreenEdgePanGestureRecognizer;
}

#pragma mark - 右滑手势支持

- (void) setUpCustomPopGestureRecognizer
{
    /**
     * 当不使用系统的返回按钮，右滑手势interactivePopGestureRecognizer将会失效
     * 这里创建UIScreenEdgePanGestureRecognizer 实现右滑 target 和 delegate 均为interactivePopGestureRecognizer.delegate
     **/
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
   
    UIScreenEdgePanGestureRecognizer * recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    recognizer.edges = UIRectEdgeLeft;
    // 当NavigationController只有一个childVC，右滑会卡住整个应用
    // recognizer.delegate = self.interactivePopGestureRecognizer.delegate;
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    [[super interactivePopGestureRecognizer] setEnabled:NO];
    
    _ScreenEdgePanGestureRecognizer = recognizer;
}

#pragma mark -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(self.forbidGestureBack){
        return NO;
    }
    return self.childViewControllers.count == 1 ? NO : YES;
}

// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
//
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return false;
//}

// called once per attempt to recognize, so failure requirements can be determined lazily and may be set up between recognizers across view hierarchies
// return YES to set up a dynamic failure requirement between gestureRecognizer and otherGestureRecognizer
//
// note: returning YES is guaranteed to set up the failure requirement. returning NO does not guarantee that there will not be a failure requirement as the other gesture's counterpart delegate or subclass methods may return YES

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 右滑退出手势优先级最高 
    return true;
}

@end
