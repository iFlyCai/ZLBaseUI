//
//  ZLBaseViewController.m
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "ZLBaseViewController+Notification.h"
#import "ZLKeyboardNotificationPayload.h"
#import "ZLBaseUIConfig.h"
#import "ZLBaseViewModel.h"
#import <objc/Runtime.h>
#import <objc/message.h>
#import <RTRootNavigationController/RTRootNavigationController.h>


@interface ZLBaseViewController ()
    
@property(nonatomic, strong) NSMutableSet * realSubViewModels;

@end

@implementation ZLBaseViewController


#pragma mark -- initial方法

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.realSubViewModels = [NSMutableSet new];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder{
    if(self = [super initWithCoder:coder]) {
        self.realSubViewModels = [NSMutableSet new];
    }
    return self;
}

#pragma mark -- 生命周期方法
- (void)viewDidLoad{
    [super viewDidLoad];
    self.isDebug = YES;
    // 初始化UI
    [self setBaseUpUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewWillAppear];
    }
    [self _registerNotificationWhenViewWillAppear];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewDidAppear];
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewWillDisappear];
    }
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewDidDisappear];
    }
    [self _unregisterNotificationWhenViewDidDisappear];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_didReceiveMemoryWarning];
    }
}


#pragma mark - 初始化UI
- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 获取当前的用户界面风格
    UIUserInterfaceStyle style = self.traitCollection.userInterfaceStyle;
    NSString *imageName = (style == UIUserInterfaceStyleDark) ? @"back_button_dark" : @"back_button_light";

    // 获取资源 Bundle
    NSBundle *bundle = [NSBundle bundleForClass:[ZLBaseViewController class]];
    NSURL *resourceBundleURL = [bundle URLForResource:@"ZLBaseUI" withExtension:@"bundle"];
    
    if (!resourceBundleURL) {
        [self debugLog:@"⚠️ 未找到 ZLBaseUI.bundle，在 Framework Bundle 中查找失败"];
        return nil;
    }

    NSBundle *resourceBundle = [NSBundle bundleWithURL:resourceBundleURL];
    if (!resourceBundle) {
        [self debugLog:@"⚠️ 无法加载 ZLBaseUI.bundle"];
        return nil;
    }

    // 从资源 Bundle 加载图片
    UIImage *image = [UIImage imageNamed:imageName inBundle:resourceBundle compatibleWithTraitCollection:self.traitCollection];

    if (image) {
        [self debugLog:[NSString stringWithFormat:@"✅ 成功加载图片：%@", imageName]];
        [button setImage:image forState:UIControlStateNormal];
    } else {
        [self debugLog:[NSString stringWithFormat:@"❌ 无法加载图片：%@（请检查 ZLBaseUI.bundle 是否正确包含该资源）", imageName]];
    }

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void) setBaseUpUI{
    self.view.backgroundColor = [ZLBaseUIConfig sharedInstance].viewControllerBackgoundColor;
}
#pragma mark - ZLBaseViewModel
- (ZLBaseViewController *) viewController{
    return self;
}

- (id<ZLBaseViewModel>) superViewModel{
    return nil;
}

- (NSArray *) subViewModels{
    return [_realSubViewModels allObjects];
}

/**
 * 添加子viewModel， 建立父子关系
 * @param subViewModel        子viewModel
 **/
- (void) addSubViewModel:(ZLBaseViewModel *) subViewModel{
    if(!subViewModel){
        return;
    }
    [subViewModel setValue:self forKey:@"realSuperViewModel"];
    [self.realSubViewModels addObject:subViewModel];
}

- (void) addSubViewModels:(NSArray<ZLBaseViewModel *> *) subViewModels{
    if(!subViewModels){
        return;
    }
    [subViewModels setValue:self forKey:@"realSuperViewModel"];
    [self.realSubViewModels addObjectsFromArray:subViewModels];
}

- (void) removeSubViewModel:(ZLBaseViewModel *) subViewModel{
    if(!subViewModel){
        return;
    }
    if([self.realSubViewModels containsObject:subViewModel]){
        [subViewModel setValue:nil forKey:@"realSuperViewModel"];
        [self.realSubViewModels removeObject:subViewModel];
    }
}

- (void) removeAllSubViewModels {
    for(ZLBaseViewModel * subViewModel in _realSubViewModels) {
        [subViewModel setValue:nil forKey:@"realSuperViewModel"];
    }
    [_realSubViewModels removeAllObjects];
}

/**
 * UIViewController 不需要
 */
- (void) removeFromSuperViewModel{
  
}

/**
 * 绑定 viewModel,View,model, 由superViewModel或者VC调用
 * @param targetModel           model
 * @param targetView         view
 **/
- (void) bindModel:(id) targetModel andView:(UIView *) targetView{
    /**
     * code
     * 绑定 viewModel,View,model
     **/
}

- (void) updateModel:(id)targetModel{
    
}

/**
 * 子ViewModel给父vViewModel上报事件
 * @param event             事件内容
 * @param subViewModel      子viewModel
 **/
- (void) getEvent:(id)event  fromSubViewModel:(ZLBaseViewModel *) subViewModel{
    /**
     * code
     * 父viewModel 处理event
     **/
}

#pragma mark - Notification

- (void) _registerNotificationWhenViewWillAppear {
    // application
    if([self watchApplicationStatusNotification]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
  
    // keyboard
    if([self watchKeyboardStatusNotification]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardDidChangeFrameNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
    }
}

- (void) _unregisterNotificationWhenViewDidDisappear {
    
    // application
    if([self watchKeyboardStatusNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidBecomeActiveNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillResignActiveNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillEnterForegroundNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillTerminateNotification
                                                      object:nil];
    }
    
    // keyboard
    if([self watchKeyboardStatusNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardDidChangeFrameNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillChangeFrameNotification
                                                      object:nil];

        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardDidShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardDidHideNotification
                                                      object:nil];
    }
}


- (void) _onNotificaitonArrived:(NSNotification *) notification {
    
    // KeyBoard
    if (notification.name == UIKeyboardDidChangeFrameNotification ||
        notification.name == UIKeyboardWillChangeFrameNotification ||
        notification.name == UIKeyboardWillShowNotification ||
        notification.name == UIKeyboardDidShowNotification ||
        notification.name == UIKeyboardWillHideNotification ||
        notification.name == UIKeyboardDidHideNotification )  {
        CGRect beginFrame;
        CGRect endFrame;
        double duration;
        UIViewAnimationCurve curve;
        
        NSValue *beginFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
        NSValue *endFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        NSNumber *durationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curveValue = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        [beginFrameValue getValue:&beginFrame size:sizeof(CGRect)];
        [endFrameValue getValue:&endFrame size:sizeof(CGRect)];
        duration = [durationValue doubleValue];
        curve = (UIViewAnimationCurve) [curveValue integerValue];
        ZLKeyboardNotificationPayload *payload = [[ZLKeyboardNotificationPayload alloc] init];
    
        payload.beginFrame = beginFrame;
        payload.endFrame = endFrame;
        payload.curve = curve;
        payload.duration = duration;
        
        if (notification.name == UIKeyboardDidChangeFrameNotification) {
            [self keyboardDidChangeFrame:payload];
        } else if (notification.name == UIKeyboardWillChangeFrameNotification) {
            [self keyboardWillChangeFrame:payload];
        } else if (notification.name == UIKeyboardWillShowNotification) {
            [self keyboardWillShow:payload];
        } else if (notification.name == UIKeyboardDidShowNotification) {
            [self keyboardDidShow:payload];
        } else if (notification.name == UIKeyboardWillHideNotification) {
            [self keyboardWillHide:payload];
        } else if (notification.name == UIKeyboardDidHideNotification) {
            [self keyboardDidHide:payload];
        }
    }
    
    // application
    if (notification.name == UIApplicationDidBecomeActiveNotification) {
        [self applicationDidBecomeActive];
    } else if (notification.name == UIApplicationDidEnterBackgroundNotification) {
        [self applicationDidEnterBackground];
    } else if (notification.name == UIApplicationWillResignActiveNotification) {
        [self applicationWillResignActive];
    } else if (notification.name == UIApplicationWillEnterForegroundNotification) {
        [self applicationWillEnterForeground];
    } else if (notification.name == UIApplicationWillTerminateNotification) {
        [self applicationWillTerminate];
    }
    
}


#pragma mark - Debug Log
/// 仅在 isDebug = YES 时输出日志
- (void)debugLog:(NSString *)message {
    if (self.isDebug) {
        NSLog(@"%@", message);
    }
}

@end

